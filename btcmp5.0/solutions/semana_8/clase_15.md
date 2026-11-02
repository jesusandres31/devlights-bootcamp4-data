# Semana 8 · Clase 15 · Solución — Esquema estrella + gráficos en Metabase

> 📝 **Consigna:** [Tarea Clase 15](../../tasks/semana_8/clase_15.md)

---

## 1️⃣ + 2️⃣ Schema y CTAS

Son exactamente los pasos de la clase: [Clase 15 → secciones 2 a 4](../../notes/semana_8/clase_15.md#-2-preparación-un-schema-analítico). Si el alumno eligió otro nombre de schema, solo cambia el prefijo `northwind_olap.`.

## 3️⃣ DER esperado

```dbml
// Esquema estrella — northwind_olap

Table fact_sales {
  order_id integer
  order_date date [ref: > dim_date.date_key]
  customer_id varchar [ref: > dim_customer.customer_id]
  employee_id integer [ref: > dim_employee.employee_id]
  shipper_id integer [ref: > dim_shipper.shipper_id]
  product_id integer [ref: > dim_product.product_id]
  quantity integer
  unit_price numeric
  discount numeric
  total_amount numeric
}

Table dim_customer {
  customer_id varchar [pk]
  company_name varchar
  contact_name varchar
  country varchar
  city varchar
  region varchar
}

Table dim_product {
  product_id integer [pk]
  product_name varchar
  category_name varchar
  supplier_name varchar
}

Table dim_employee {
  employee_id integer [pk]
  first_name varchar
  last_name varchar
  title varchar
  city varchar
  country varchar
}

Table dim_shipper {
  shipper_id integer [pk]
  shipper_name varchar
}

Table dim_date {
  date_key date [pk]
  year integer
  quarter integer
  month integer
  month_name varchar
  day integer
  weekday integer
  weekday_name varchar
}
```

> ⚠️ Las tablas creadas con CTAS **no copian PKs ni FKs**, por eso el ERD de pgAdmin las muestra sueltas. Para que se dibujen las relaciones se pueden agregar con `ALTER TABLE ... ADD PRIMARY KEY` / `ADD FOREIGN KEY` (opcional).

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
