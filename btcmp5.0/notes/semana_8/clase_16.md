# Semana 8 · Clase 16 — Metabase: gráficos y dashboard sobre Northwind analítico

> 🎯 **Objetivo:** conectar **Metabase** al esquema estrella que armamos en la [Clase 15](clase_15.md), crear los primeros gráficos y llegar a un **dashboard** con pestañas, filtros (variables) y la visualización adecuada para cada pregunta.
>
> 📝 **Tarea:** [Tarea Clase 16 — Gráficos y dashboard en Metabase](../../tasks/semana_8/clase_16.md)

---

## 🧩 1. Levantar Metabase

Agregamos Metabase como un servicio más en el `docker-compose.yml` de la [Clase 8](../../tasks/semana_4/clase_8.md), debajo de `pg_admin`:

```yaml
  metabase:
    image: metabase/metabase:latest
    container_name: my_metabase_bootcamp
    restart: unless-stopped
    environment:
      MB_DB_FILE: /metabase-data/metabase.db   # guarda usuarios, preguntas y dashboards
    ports:
      - "4000:3000"
    volumes:
      - ./metabase-data:/metabase-data
    depends_on:
      - postgres-db
```

Levantarlo (igual en PowerShell y en bash, desde la carpeta del `docker-compose.yml`):

```bash
docker compose up -d
docker ps   # debería aparecer my_metabase_bootcamp
```

> 💡 La primera vez tarda 1 o 2 minutos en arrancar. Para ver cómo va: `docker logs -f my_metabase_bootcamp` (salir con `Ctrl + C`).

---

## 🧩 2. Conectar Northwind

Entrar a <http://localhost:4000>, crear el usuario admin y agregar la base:

| Campo         | Valor          |
| ------------- | -------------- |
| Database type | PostgreSQL     |
| Host          | `postgres-db`  |
| Port          | `5432`         |
| Database name | `northwind`    |
| Username      | `myuser`       |
| Password      | `mypassword`   |

> 💡 Igual que pgAdmin, Metabase corre dentro de la misma red de Docker que Postgres: por eso usa el nombre del servicio (`postgres-db`) y el puerto interno `5432`.

En **Browse data → northwind** tienen que aparecer los schemas `public` y `northwind_olap`.

---

## 🧩 3. Primeros gráficos

Cada gráfico es una **SQL question**: **+ New → SQL query**, elegir la base `northwind`, pegar la consulta, ejecutar y elegir la visualización (botón **Visualization**).

Usamos las [consultas analíticas de la Clase 15](clase_15.md#-6-consultas-analíticas):

| #  | Gráfico                         | Visualización        | Eje X / dimensión   | Eje Y / métrica |
| -- | ------------------------------- | -------------------- | ------------------- | --------------- |
| a) | Ventas totales por producto     | Row (barras horiz.)  | `product_name`      | `total_sales`   |
| b) | Ventas por país del cliente     | Map o Bar            | `country`           | `total_sales`   |
| c) | Ventas por empleado (vendedor)  | Bar                  | `employee_name`     | `total_sales`   |
| d) | Ventas mensuales                | Line                 | `year` + `month`    | `total_sales`   |
| e) | Top 10 clientes por ventas      | Row                  | `customer`          | `total_sales`   |
| f) | Ventas por empresa de envío     | Pie o Bar            | `shipper_name`      | `total_sales`   |

> 💡 Para la línea temporal queda mejor armar una fecha: `MAKE_DATE(d.year, d.month, 1) AS month_start` y agrupar por esa columna.

### Query vs. gráfico

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

## 🧩 4. Estructura del dashboard

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

## 🧩 5. Tab KPIs

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

## 🧩 6. Tab Tendencias

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

## 🧩 7. Tab Ranking

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

## 🧩 8. Tab Segmentación

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
