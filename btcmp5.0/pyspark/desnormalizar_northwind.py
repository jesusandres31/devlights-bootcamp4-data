"""
Class 17 — Denormalize Northwind with PySpark.

Reads the Northwind tables (normalized model, `public` schema) from Postgres,
builds the same star schema as Class 15 and saves it as CSV files in /output:

    fact_sales.csv, dim_customer.csv, dim_product.csv, dim_employee.csv,
    dim_shipper.csv, dim_date.csv  -> the star schema
    ventas_flat.csv                -> everything in a single table (for pandas)

Run it from this folder (btcmp5.0/pyspark) with:
    docker compose up --exit-code-from pyspark
"""

import glob
import os
import shutil

from pyspark.sql import SparkSession
from pyspark.sql import functions as F

# ---------------------------------------------------------------------------
# 1. Configuration
# ---------------------------------------------------------------------------
# "postgres-db" is the service name in docker-compose.yml
JDBC_URL = "jdbc:postgresql://postgres-db:5432/northwind"
JDBC_PROPS = {
    "user": "myuser",
    "password": "mypassword",
    "driver": "org.postgresql.Driver",
}
OUTPUT_DIR = "/output"  # folder shared with the host (volume)

spark = SparkSession.builder.appName("desnormalizar_northwind").getOrCreate()
spark.sparkContext.setLogLevel("WARN")  # fewer console messages


def leer_tabla(nombre):
    """Read a Postgres table and return it as a Spark DataFrame."""
    return spark.read.jdbc(JDBC_URL, nombre, properties=JDBC_PROPS)


def guardar_csv(df, nombre):
    """Save a DataFrame as a single /output/<nombre>.csv file."""
    # Spark writes a folder of "part-*.csv" files: coalesce(1) leaves just one,
    # which we then move so it is named <nombre>.csv
    carpeta_tmp = os.path.join(OUTPUT_DIR, f"_tmp_{nombre}")
    df.coalesce(1).write.mode("overwrite").option("header", True).csv(carpeta_tmp)

    archivo_part = glob.glob(os.path.join(carpeta_tmp, "part-*.csv"))[0]
    shutil.move(archivo_part, os.path.join(OUTPUT_DIR, f"{nombre}.csv"))
    shutil.rmtree(carpeta_tmp)
    print(f"OK  {nombre}.csv  ({df.count()} filas)")


# ---------------------------------------------------------------------------
# 2. Extract: read the normalized tables
# ---------------------------------------------------------------------------
orders = leer_tabla("orders")
order_details = leer_tabla("order_details")
customers = leer_tabla("customers")
products = leer_tabla("products")
categories = leer_tabla("categories")
suppliers = leer_tabla("suppliers")
employees = leer_tabla("employees")
shippers = leer_tabla("shippers")

# ---------------------------------------------------------------------------
# 3. Transform: build the star schema (same model as Class 15)
# ---------------------------------------------------------------------------

# Fact table: one row per order line
fact_sales = (
    order_details
    .join(orders, on="order_id")
    .select(
        "order_id",
        "order_date",
        "customer_id",
        "employee_id",
        F.col("ship_via").alias("shipper_id"),
        "product_id",
        "quantity",
        "unit_price",
        "discount",
        (F.col("quantity") * F.col("unit_price") * (1 - F.col("discount")))
        .cast("decimal(10,2)")
        .alias("total_amount"),
    )
)

# Who buys
dim_customer = customers.select(
    "customer_id", "company_name", "contact_name", "country", "city", "region"
)

# What is sold (denormalizes products + categories + suppliers)
dim_product = (
    products
    .join(categories, on="category_id", how="left")
    .join(suppliers, on="supplier_id", how="left")
    .select(
        "product_id",
        "product_name",
        "category_name",
        F.col("company_name").alias("supplier_name"),
    )
)

# Who sells
dim_employee = employees.select(
    "employee_id", "first_name", "last_name", "title", "city", "country"
)

# How it ships
dim_shipper = shippers.select(
    "shipper_id", F.col("company_name").alias("shipper_name")
)

# When: one row per date with orders
dim_date = (
    orders
    .where(F.col("order_date").isNotNull())
    .select(F.col("order_date").alias("date_key"))
    .distinct()
    .select(
        "date_key",
        F.year("date_key").alias("year"),
        F.quarter("date_key").alias("quarter"),
        F.month("date_key").alias("month"),
        F.date_format("date_key", "MMMM").alias("month_name"),
        F.dayofmonth("date_key").alias("day"),
        (F.dayofweek("date_key") - 1).alias("weekday"),  # 0 = Sunday, as in Postgres
        F.date_format("date_key", "EEEE").alias("weekday_name"),
    )
    .orderBy("date_key")
)

# Flat table ("one big table"): the facts with all their dimensions joined in.
# Not part of the star schema, but the most convenient shape for pandas.
ventas_flat = (
    fact_sales
    .join(dim_customer, on="customer_id", how="left")
    .join(dim_product, on="product_id", how="left")
    .join(dim_employee.drop("city", "country"), on="employee_id", how="left")
    .join(dim_shipper, on="shipper_id", how="left")
    .select(
        "order_id",
        "order_date",
        F.year("order_date").alias("year"),
        F.month("order_date").alias("month"),
        F.col("company_name").alias("customer"),
        "country",
        "city",
        "product_name",
        "category_name",
        "supplier_name",
        F.concat_ws(" ", "first_name", "last_name").alias("employee_name"),
        "shipper_name",
        "quantity",
        "unit_price",
        "discount",
        "total_amount",
    )
    .orderBy("order_date", "order_id")
)

# ---------------------------------------------------------------------------
# 4. Load: save each table as CSV
# ---------------------------------------------------------------------------
os.makedirs(OUTPUT_DIR, exist_ok=True)

guardar_csv(fact_sales, "fact_sales")
guardar_csv(dim_customer, "dim_customer")
guardar_csv(dim_product, "dim_product")
guardar_csv(dim_employee, "dim_employee")
guardar_csv(dim_shipper, "dim_shipper")
guardar_csv(dim_date, "dim_date")
guardar_csv(ventas_flat, "ventas_flat")

spark.stop()
