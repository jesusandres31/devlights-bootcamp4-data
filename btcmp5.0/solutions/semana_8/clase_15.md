# Semana 8 · Clase 15 · Solución — Esquema estrella + gráficos en Metabase

> 📝 **Consigna:** [Tarea Clase 15](../../tasks/semana_8/clase_15.md)

---

## 1️⃣ + 2️⃣ Schema y CTAS

Son exactamente los pasos de la clase: [Clase 15 → secciones 2 a 4](../../notes/semana_8/clase_15.md#-2-preparación-un-schema-analítico). Si el alumno eligió otro nombre de schema, solo cambia el prefijo `northwind_olap.`.

## 3️⃣ PKs, FKs y DER

Las tablas creadas con CTAS **no copian PKs ni FKs**, así que el DER de pgAdmin las muestra sueltas. Se agregan con `ALTER TABLE`:

```sql
-- PKs en las dimensiones
ALTER TABLE northwind_olap.dim_customer ADD PRIMARY KEY (customer_id);
ALTER TABLE northwind_olap.dim_product  ADD PRIMARY KEY (product_id);
ALTER TABLE northwind_olap.dim_employee ADD PRIMARY KEY (employee_id);
ALTER TABLE northwind_olap.dim_shipper  ADD PRIMARY KEY (shipper_id);
ALTER TABLE northwind_olap.dim_date     ADD PRIMARY KEY (date_key);

-- PK de la tabla de hechos: una línea de pedido = pedido + producto
ALTER TABLE northwind_olap.fact_sales ADD PRIMARY KEY (order_id, product_id);

-- FKs desde la tabla de hechos hacia cada dimensión
ALTER TABLE northwind_olap.fact_sales
    ADD FOREIGN KEY (customer_id) REFERENCES northwind_olap.dim_customer(customer_id),
    ADD FOREIGN KEY (product_id)  REFERENCES northwind_olap.dim_product(product_id),
    ADD FOREIGN KEY (employee_id) REFERENCES northwind_olap.dim_employee(employee_id),
    ADD FOREIGN KEY (shipper_id)  REFERENCES northwind_olap.dim_shipper(shipper_id),
    ADD FOREIGN KEY (order_date)  REFERENCES northwind_olap.dim_date(date_key);
```

**DER esperado** (clic derecho sobre la base → **ERD For Database**): `fact_sales` en el centro y las 5 dimensiones alrededor, cada una con una relación 1:N hacia la tabla de hechos → la "estrella".

## 4️⃣ Gráficos en Metabase

Cada gráfico es una **SQL question** con la consulta correspondiente de [Clase 15 → Consultas analíticas](../../notes/semana_8/clase_15.md#-5-consultas-analíticas):

| #  | Consulta de la clase          | Visualización        | Eje X / dimensión   | Eje Y / métrica |
| -- | ----------------------------- | -------------------- | ------------------- | --------------- |
| a) | Ventas totales por producto   | Row (barras horiz.)  | `product_name`      | `total_sales`   |
| b) | Ventas por país del cliente   | Map (Region map → World) o Bar | `country` | `total_sales`   |
| c) | Ventas por empleado           | Bar                  | `employee_name`     | `total_sales`   |
| d) | Ventas mensuales              | Line                 | `year` + `month`    | `total_sales`   |
| e) | Top 10 clientes               | Row                  | `customer`          | `total_sales`   |
| f) | Ventas por empresa de envío   | Pie o Bar            | `shipper_name`      | `total_sales`   |

> 💡 Para el mapa, Metabase espera nombres de país en inglés completo: `USA` y `UK` no se pintan. Se resuelve con un `CASE` (lo vemos en la Clase 16).
>
> 💡 Para la línea temporal queda mejor armar una fecha: `MAKE_DATE(d.year, d.month, 1) AS month_start` y agrupar por esa columna.
