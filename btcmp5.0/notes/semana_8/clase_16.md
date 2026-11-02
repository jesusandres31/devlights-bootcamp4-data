# Semana 8 · Clase 16 — Dashboard en Metabase

> 🎯 **Objetivo:** pasar de consultas sueltas a un **dashboard** en Metabase con pestañas, filtros (variables) y la visualización adecuada para cada pregunta.
>
> 📝 **Tarea:** [Tarea Clase 16 — Dashboard completo en Metabase](../../tasks/semana_8/clase_16.md)

---

## 🧩 1. Query vs. gráfico

La misma consulta se puede ver como tabla en pgAdmin o como gráfico en Metabase. Primero la probamos en pgAdmin:

```sql
-- Ventas totales por producto
SELECT
    p.product_name,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- Top 10 clientes por ventas
SELECT
    c.company_name AS customer,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.company_name
ORDER BY total_sales DESC
LIMIT 10;
```

### 🌎 Preparar datos para un mapa

El mapa de Metabase no reconoce `USA` ni `UK`. Se corrigen con `CASE`:

```sql
SELECT
    CASE
        WHEN c.country = 'USA' THEN 'United States'
        WHEN c.country = 'UK'  THEN 'United Kingdom'
        ELSE c.country
    END AS country,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_customer c ON f.customer_id = c.customer_id
GROUP BY 1
ORDER BY total_sales DESC;
```

---

## 🧩 2. Estructura del dashboard

Pestañas (tabs): **KPIs**, **Tendencias**, **Ranking** y **Segmentación**.

Las variables `{{...}}` de Metabase se convierten en filtros del dashboard:

| Variable         | Tipo en Metabase | Uso                          |
| ---------------- | ---------------- | ---------------------------- |
| `{{start_date}}` | Date             | Desde (KPIs)                 |
| `{{end_date}}`   | Date             | Hasta (KPIs)                 |
| `{{category}}`   | Text             | Filtrar por categoría        |
| `{{year}}`       | Number           | Filtrar por año              |

Consultas útiles para saber qué valores cargar en los filtros:

```sql
-- Rango de fechas disponible
SELECT MIN(date_key), MAX(date_key) FROM northwind_olap.dim_date;

-- Categorías disponibles
SELECT DISTINCT category_name
FROM northwind_olap.dim_product
ORDER BY category_name;
```

---

## 🧩 3. Tab KPIs

Visualización: **Number** (un número grande por tarjeta).

### A) Ventas totales

```sql
SELECT
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
WHERE f.order_date BETWEEN {{start_date}} AND {{end_date}};
```

### B) Cantidad de órdenes

```sql
SELECT
    COUNT(DISTINCT f.order_id) AS total_orders
FROM northwind_olap.fact_sales f
WHERE f.order_date BETWEEN {{start_date}} AND {{end_date}};
```

### C) Ticket promedio (cuánto se gasta en promedio por pedido)

```sql
SELECT
    SUM(f.total_amount) / COUNT(DISTINCT f.order_id) AS avg_ticket
FROM northwind_olap.fact_sales f
WHERE f.order_date BETWEEN {{start_date}} AND {{end_date}};
```

---

## 🧩 4. Tab Tendencias

Visualización: **Line** o **Bar**. El `[[ ... ]]` hace que el filtro sea **opcional**: si no se completa, Metabase omite esa parte del `WHERE`.

### A) Ventas anuales (filtrable por categoría)

```sql
SELECT
    d.year,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_date d    ON f.order_date = d.date_key
JOIN northwind_olap.dim_product p ON f.product_id = p.product_id
WHERE 1 = 1
  [[AND p.category_name = {{category}}]]
GROUP BY d.year
ORDER BY d.year;
```

### B) Órdenes anuales (filtrable por categoría)

```sql
SELECT
    d.year,
    COUNT(DISTINCT f.order_id) AS orders_count
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_date d    ON f.order_date = d.date_key
JOIN northwind_olap.dim_product p ON f.product_id = p.product_id
WHERE 1 = 1
  [[AND p.category_name = {{category}}]]
GROUP BY d.year
ORDER BY d.year;
```

### C) Ventas por mes de un año (filtrable por categoría y año)

```sql
SELECT
    d.month,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_date d    ON f.order_date = d.date_key
JOIN northwind_olap.dim_product p ON f.product_id = p.product_id
WHERE 1 = 1
  [[AND p.category_name = {{category}}]]
  [[AND d.year = {{year}}]]
GROUP BY d.month
ORDER BY d.month;
```

---

## 🧩 5. Tab Ranking

Visualización: **Row** (barras horizontales) o **Table**.

### A) Top 10 clientes

```sql
SELECT
    c.company_name AS customer,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.company_name
ORDER BY total_sales DESC
LIMIT 10;
```

### B) Ranking de vendedores

```sql
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    SUM(f.total_amount) AS total_sales,
    COUNT(DISTINCT f.order_id) AS orders_handled
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_employee e ON f.employee_id = e.employee_id
GROUP BY employee_name
ORDER BY total_sales DESC;
```

### C) Top 10 productos

```sql
SELECT
    p.product_name,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;
```

---

## 🧩 6. Tab Segmentación

### A) Ventas por país

Visualización: **Map → Region map → World**.

```sql
SELECT
    CASE
        WHEN c.country = 'USA' THEN 'United States'
        WHEN c.country = 'UK'  THEN 'United Kingdom'
        ELSE c.country
    END AS country,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_customer c ON f.customer_id = c.customer_id
GROUP BY 1
ORDER BY total_sales DESC;
```
