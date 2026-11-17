# Semana 9 · Clase 17 · Solución — Desnormalizar Northwind con PySpark

> 📝 **Consigna:** [Tarea Clase 17](../../tasks/semana_9/clase_17.md)

---

## 1️⃣ + 2️⃣ Ejecutar el script y subir los CSV

Son los pasos de la [Clase 17](../../notes/semana_9/clase_17.md). Salida esperada:

```text
OK  fact_sales.csv  (2155 filas)
OK  dim_customer.csv  (91 filas)
OK  dim_product.csv  (77 filas)
OK  dim_employee.csv  (9 filas)
OK  dim_shipper.csv  (6 filas)
OK  dim_date.csv  (480 filas)
OK  ventas_flat.csv  (2155 filas)
```

## 3️⃣ Columnas nuevas en `fact_sales`

Después del `join` con `orders`, la columna `shipped_date` ya está disponible: solo hay que agregarla al `select`.

```python
fact_sales = (
    order_details
    .join(orders, on="order_id")
    .select(
        "order_id",
        "order_date",
        "shipped_date",                                                    # nueva
        F.datediff("shipped_date", "order_date").alias("days_to_ship"),    # nueva
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

> 💡 Los pedidos que todavía no se enviaron tienen `shipped_date` vacío, y por eso `days_to_ship` también queda vacío (`null`).

## 4️⃣ ⭐ `ventas_por_categoria.csv`

Se puede agrupar sobre `ventas_flat`, que ya tiene la categoría en cada fila:

```python
ventas_por_categoria = (
    ventas_flat
    .groupBy("category_name")
    .agg(
        F.sum("total_amount").alias("total_sales"),
        F.countDistinct("order_id").alias("orders"),
    )
    .orderBy(F.desc("total_sales"))
)

guardar_csv(ventas_por_categoria, "ventas_por_categoria")
```

Resultado esperado (8 categorías): `Beverages` primero, con `total_sales` ≈ 267868 y 354 pedidos.

> 💡 Alternativa con el esquema estrella: `fact_sales.join(dim_product, on="product_id")` y después el mismo `groupBy`.
