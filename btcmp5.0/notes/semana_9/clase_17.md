# Semana 9 · Clase 17 — PySpark: desnormalizar Northwind con Python

> 🎯 **Objetivo:** primer contacto con **Python** y **Spark**. Repetimos la desnormalización de la [Clase 15](../semana_8/clase_15.md), pero con un script de **PySpark** que corre en Docker, y exportamos el esquema estrella a **CSV** para analizarlo en la próxima clase.
>
> 📝 **Tarea:** [Tarea Clase 17 — Desnormalizar Northwind con PySpark](../../tasks/semana_9/clase_17.md)

---

## 🧩 1. Python en 10 minutos

Lo justo para poder leer el script de hoy.

```python
# Comentario: Python ignora todo lo que va después de #

# Variables (no se declara el tipo)
tabla = "orders"                 # texto (str)
filas = 830                      # número entero (int)
descuento = 0.15                 # número con decimales (float)

# f-strings: texto con variables adentro
print(f"La tabla {tabla} tiene {filas} filas")

# Listas: varios valores en orden
tablas = ["orders", "customers", "products"]
print(tablas[0])                 # orders

# Diccionarios: pares clave → valor
conexion = {"user": "myuser", "password": "mypassword"}
print(conexion["user"])          # myuser

# Funciones: se definen con def y el bloque va INDENTADO (4 espacios)
def saludar(nombre):
    """Texto que explica qué hace la función."""
    return f"Hola, {nombre}"

print(saludar("Northwind"))      # Hola, Northwind

# for: recorrer una lista
for t in tablas:
    print(t)

# import: usar código de otras librerías
import os
from pyspark.sql import functions as F   # F pasa a ser un "apodo"
```

> 💡 En Python la **indentación** es parte de la sintaxis: lo que está "adentro" de una función o un `for` se escribe con 4 espacios más.

---

## 🧩 2. ¿Qué es Spark / PySpark?

- **Apache Spark** es un motor para procesar **grandes volúmenes de datos** repartiendo el trabajo entre muchas máquinas (un *cluster*).
- **PySpark** es la forma de usar Spark desde Python.
- Trabaja con **DataFrames**: tablas con filas y columnas, con operaciones muy parecidas a SQL.

> ⚠️ Northwind es chiquita: para 2.155 filas Spark es exagerado (Postgres lo resuelve mejor). Lo usamos porque **es la misma lógica que se usa con millones de filas**, cuando los datos ya no entran en una sola base.

Lo que vamos a hacer es un **ETL**:

| Paso                | Qué hacemos                                     |
| ------------------- | ----------------------------------------------- |
| **E**xtract (extraer)   | Leer las tablas normalizadas de Postgres     |
| **T**ransform (transformar) | Armar hechos y dimensiones (desnormalizar) |
| **L**oad (cargar)       | Guardar el resultado en archivos CSV          |

### SQL ↔ PySpark

| SQL                                  | PySpark                                           |
| ------------------------------------ | ------------------------------------------------- |
| `SELECT a, b AS c`                   | `df.select("a", F.col("b").alias("c"))`           |
| `WHERE x > 10`                       | `df.where(F.col("x") > 10)`                       |
| `JOIN otra USING (id)`               | `df.join(otra, on="id")`                          |
| `LEFT JOIN otra USING (id)`          | `df.join(otra, on="id", how="left")`              |
| `GROUP BY a` + `SUM(b)`              | `df.groupBy("a").agg(F.sum("b"))`                 |
| `ORDER BY a`                         | `df.orderBy("a")`                                 |
| `SELECT DISTINCT`                    | `df.distinct()`                                   |
| `CREATE TABLE ... AS SELECT`         | `df.write.csv(...)` (guardar el resultado)        |

---

## 🧩 3. Un `docker-compose` propio para esta clase

Para esta práctica usamos un `docker-compose.yml` **separado** del de la Clase 8, que hace todo solo:

1. Levanta un **Postgres** y le carga `northwind.sql` automáticamente.
2. Cuando Northwind terminó de cargarse, levanta el contenedor de **PySpark**, que ejecuta el script.
3. El script deja los CSV en la carpeta `output/` de nuestra máquina.

📁 Carpeta del repo: [`pyspark/`](../../pyspark/)

```text
btcmp5.0/
├── datasets/
│   └── northwind.sql                 ← se carga solo en Postgres
└── pyspark/
    ├── docker-compose.yml
    ├── desnormalizar_northwind.py    ← el script de PySpark
    └── output/                       ← acá aparecen los CSV (se crea sola)
```

> 💡 Es independiente del Postgres del bootcamp: usa otros contenedores y no publica puertos, así que pueden estar los dos levantados a la vez.

---

## 🧩 4. El `docker-compose.yml` línea por línea

```yaml
services:
  postgres-db:
    image: postgres:16
    container_name: pyspark_postgres
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: northwind
    volumes:
      - ../datasets/northwind.sql:/docker-entrypoint-initdb.d/northwind.sql:ro
    healthcheck:
      test: ["CMD-SHELL", "psql -h 127.0.0.1 -U myuser -d northwind -c 'SELECT 1 FROM order_details LIMIT 1'"]
      interval: 3s
      timeout: 5s
      retries: 40

  pyspark:
    image: spark:3.5.3-python3
    container_name: pyspark_job
    user: root
    depends_on:
      postgres-db:
        condition: service_healthy
    volumes:
      - ./desnormalizar_northwind.py:/app/desnormalizar_northwind.py:ro
      - ./output:/output
    command: >
      /opt/spark/bin/spark-submit
      --packages org.postgresql:postgresql:42.7.4
      --conf spark.log.level=WARN
      /app/desnormalizar_northwind.py
```

**Postgres**

| Línea                                    | Para qué                                                                      |
| ---------------------------------------- | ----------------------------------------------------------------------------- |
| `POSTGRES_DB: northwind`                 | Crea la base `northwind` vacía al arrancar                                    |
| `.../docker-entrypoint-initdb.d/...`     | Todo `.sql` que esté en esa carpeta se ejecuta solo la **primera vez** que arranca: carga Northwind |
| `:ro`                                    | *Read only*: el contenedor no puede modificar nuestro archivo                 |
| `healthcheck`                            | Cada 3 segundos prueba si ya existe `order_details`. Cuando responde, el contenedor pasa a **healthy** |

**PySpark**

| Línea                                    | Para qué                                                                      |
| ---------------------------------------- | ----------------------------------------------------------------------------- |
| `image: spark:3.5.3-python3`             | Imagen oficial de Spark con Python y Java ya instalados                       |
| `user: root`                             | Permite escribir en la carpeta `output` de nuestra máquina                    |
| `condition: service_healthy`             | No arranca hasta que Northwind esté cargada                                   |
| `./desnormalizar_northwind.py:/app/...`  | El script de nuestra máquina aparece adentro del contenedor                   |
| `./output:/output`                       | Lo que el script guarda en `/output` aparece en nuestra carpeta `output`      |
| `spark-submit`                           | Ejecuta el script con Spark                                                   |
| `--packages ...postgresql...`            | Descarga el driver JDBC para que Spark pueda leer Postgres                    |
| `--conf spark.log.level=WARN`            | Menos mensajes en la consola                                                  |

> 💡 A diferencia de Postgres o Metabase, el contenedor de PySpark **no queda corriendo**: arranca, ejecuta el script y termina.

---

## 🧩 5. El script paso a paso

### ⚙️ Configuración y conexión

```python
JDBC_URL = "jdbc:postgresql://postgres-db:5432/northwind"
JDBC_PROPS = {"user": "myuser", "password": "mypassword", "driver": "org.postgresql.Driver"}
OUTPUT_DIR = "/output"

spark = SparkSession.builder.appName("desnormalizar_northwind").getOrCreate()

def leer_tabla(nombre):
    """Read a Postgres table and return it as a Spark DataFrame."""
    return spark.read.jdbc(JDBC_URL, nombre, properties=JDBC_PROPS)
```

👉 Igual que pgAdmin y Metabase, el contenedor llega a Postgres por el nombre del servicio `postgres-db`.

### 📥 Extract: leer las tablas normalizadas

```python
orders = leer_tabla("orders")
order_details = leer_tabla("order_details")
customers = leer_tabla("customers")
# ... products, categories, suppliers, employees, shippers
```

### 🔧 Transform: la tabla de hechos

Comparar con el CTAS de la [Clase 15](../semana_8/clase_15.md#-4-tabla-de-hechos-fact_sales): es la misma consulta.

```python
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
```

> 💡 Los paréntesis grandes permiten escribir una operación en varias líneas, un paso por línea (como un `SELECT` bien indentado).

### 🔧 Transform: una dimensión desnormalizada

```python
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
```

### 🔧 Transform: la dimensión de fechas

```python
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
        (F.dayofweek("date_key") - 1).alias("weekday"),
        F.date_format("date_key", "EEEE").alias("weekday_name"),
    )
)
```

### 🧱 Extra: la tabla plana `ventas_flat`

Además del esquema estrella, el script genera **una sola tabla** con los hechos y todas sus dimensiones ya unidas (*one big table*). Ocupa más espacio y repite datos, pero para analizar en pandas es lo más cómodo: no hace falta ningún `JOIN`.

| order_id | order_date | customer | country | product_name | category_name | employee_name | shipper_name | quantity | total_amount |
| -------- | ---------- | -------- | ------- | ------------ | ------------- | ------------- | ------------ | -------- | ------------ |
| 10248 | 1996-07-04 | Vins et alcools Chevalier | France | Queso Cabrales | Dairy Products | Steven Buchanan | Federal Shipping | 12 | 168.00 |

### 💾 Load: guardar en CSV

```python
def guardar_csv(df, nombre):
    """Save a DataFrame as a single /output/<nombre>.csv file."""
    carpeta_tmp = os.path.join(OUTPUT_DIR, f"_tmp_{nombre}")
    df.coalesce(1).write.mode("overwrite").option("header", True).csv(carpeta_tmp)

    archivo_part = glob.glob(os.path.join(carpeta_tmp, "part-*.csv"))[0]
    shutil.move(archivo_part, os.path.join(OUTPUT_DIR, f"{nombre}.csv"))
    shutil.rmtree(carpeta_tmp)

guardar_csv(fact_sales, "fact_sales")
guardar_csv(dim_product, "dim_product")
# ...
```

> 💡 Spark está pensado para escribir en paralelo: guarda una **carpeta** con varios archivos `part-*.csv`. Con `coalesce(1)` lo juntamos en uno solo y después lo renombramos.

---

## 🧩 6. Ejecutarlo

Desde la carpeta `pyspark/` (los comandos son iguales en PowerShell y en bash):

```bash
docker compose up --exit-code-from pyspark
```

- La primera vez descarga las imágenes de Postgres y Spark (~1 GB) y el driver JDBC: tarda unos minutos. Después, menos de un minuto.
- `--exit-code-from pyspark`: cuando PySpark termina, apaga también Postgres y devuelve el resultado del script.

Al final tiene que mostrar:

```text
OK  fact_sales.csv  (2155 filas)
OK  dim_customer.csv  (91 filas)
OK  dim_product.csv  (77 filas)
OK  dim_employee.csv  (9 filas)
OK  dim_shipper.csv  (6 filas)
OK  dim_date.csv  (480 filas)
OK  ventas_flat.csv  (2155 filas)
```

Y los 7 archivos aparecen en la carpeta `output/` de nuestra máquina.

Al terminar, borrar los contenedores y la base temporal:

```bash
docker compose down -v
```

> 💡 En **Linux**, los archivos quedan a nombre de `root`. Para que sean tuyos: `sudo chown -R $USER output`.
>
> 💡 La suma de `total_amount` puede diferir en algunos centavos de la de Postgres: Northwind guarda precios y descuentos como `real` (decimales aproximados), y Spark y Postgres hacen la multiplicación con distinta precisión.

---

## 🧩 7. Bonus: la misma estrella con `spark.sql`

Spark también entiende SQL. Abrimos una consola interactiva de PySpark desde la carpeta `pyspark/` (igual en PowerShell y bash). Primero levanta Postgres con Northwind y después abre la consola:

```bash
docker compose run --rm pyspark /opt/spark/bin/pyspark --packages org.postgresql:postgresql:42.7.4
```

Y adentro registramos las tablas como **vistas temporales** para consultarlas con el mismo SQL de la Clase 15:

```python
props = {"user": "myuser", "password": "mypassword", "driver": "org.postgresql.Driver"}
url = "jdbc:postgresql://postgres-db:5432/northwind"

spark.read.jdbc(url, "orders", properties=props).createOrReplaceTempView("orders")
spark.read.jdbc(url, "order_details", properties=props).createOrReplaceTempView("order_details")

fact_sales = spark.sql("""
    SELECT od.order_id, o.order_date, o.customer_id, o.employee_id,
           o.ship_via AS shipper_id, od.product_id, od.quantity, od.unit_price, od.discount,
           CAST(od.quantity * od.unit_price * (1 - od.discount) AS DECIMAL(10,2)) AS total_amount
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
""")

fact_sales.show(5)
```

Salir con `exit()` y después `docker compose down -v`.

---

## 🧩 8. Para la próxima clase: subir los CSV a Google Drive

1. Entrar a <https://drive.google.com>.
2. Crear una carpeta llamada **`northwind_csv`** en **Mi unidad**.
3. Subir los 7 archivos de `output/`.

👉 En la [Clase 18](clase_18.md) los leemos desde Google Colab con pandas.
