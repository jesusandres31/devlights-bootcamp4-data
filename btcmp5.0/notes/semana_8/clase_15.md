# Semana 8 · Clase 15 — Modelo estrella (OLAP) a partir de Northwind

> 🎯 **Objetivo:** transformar la base transaccional de Northwind en un **esquema estrella** (tabla de hechos + dimensiones) usando `CREATE TABLE ... AS SELECT` (CTAS), y consultarlo para análisis.
>
> 📝 **Tarea:** [Tarea Clase 15 — Esquema estrella + gráficos en Metabase](../../tasks/semana_8/clase_15.md)

---

## 🧩 1. ¿Qué es un esquema estrella?

- **Tabla de hechos (fact):** mide el evento de negocio → cada venta / línea de pedido. Tiene números (cantidad, monto) y claves hacia las dimensiones.
- **Dimensiones (dim):** dan el contexto → **quién**, **qué**, **cuándo**, **cómo**.

### Tabla de hechos: `fact_sales`

📦 Origen: `orders` + `order_details`. Cada fila es una línea de pedido (un producto dentro de una orden).

| Campo          | Origen                                           |
| -------------- | ------------------------------------------------ |
| `order_id`     | `order_details.order_id`                         |
| `order_date`   | `orders.order_date`                              |
| `customer_id`  | `orders.customer_id`                             |
| `employee_id`  | `orders.employee_id`                             |
| `shipper_id`   | `orders.ship_via`                                |
| `product_id`   | `order_details.product_id`                       |
| `quantity`     | `order_details.quantity`                         |
| `unit_price`   | `order_details.unit_price`                       |
| `discount`     | `order_details.discount`                         |
| `total_amount` | `quantity * unit_price * (1 - discount)`         |

### Dimensiones

| Dimensión      | Fuente en Northwind                    | Campos principales                                          | Responde        |
| -------------- | -------------------------------------- | ----------------------------------------------------------- | --------------- |
| `dim_customer` | `customers`                            | customer_id, company_name, contact_name, country, city, region | Quién compra    |
| `dim_product`  | `products` + `categories` + `suppliers` | product_id, product_name, category_name, supplier_name      | Qué se vende    |
| `dim_employee` | `employees`                            | employee_id, first_name, last_name, title, city, country    | Quién vende     |
| `dim_shipper`  | `shippers`                             | shipper_id, shipper_name                                     | Cómo se envía   |
| `dim_date`     | generada desde `orders.order_date`     | date_key, year, quarter, month, day, weekday                 | Cuándo ocurre   |

---

## 🧩 2. Preparación: un schema analítico

Separamos el modelo analítico del transaccional (`public`) en su propio schema:

```sql
CREATE SCHEMA IF NOT EXISTS northwind_olap;
```

---

## 🧩 3. Tabla de hechos: `fact_sales`

`orders` y `order_details` tienen relación 1:N (un pedido tiene muchas líneas).

```sql
CREATE TABLE northwind_olap.fact_sales AS
SELECT
    od.order_id,
    o.order_date,
    o.customer_id,
    o.employee_id,
    o.ship_via AS shipper_id,
    od.product_id,
    od.quantity,
    od.unit_price,
    od.discount,
    (od.quantity * od.unit_price * (1 - od.discount))::numeric(10,2) AS total_amount
FROM public.order_details od
JOIN public.orders o ON od.order_id = o.order_id;

SELECT * FROM northwind_olap.fact_sales;
```

---

## 🧩 4. Dimensiones

### 🧭 `dim_customer`

```sql
CREATE TABLE northwind_olap.dim_customer AS
SELECT
    customer_id,
    company_name,
    contact_name,
    country,
    city,
    region
FROM public.customers;
```

### 📦 `dim_product`

Combinamos `products` con `categories` y `suppliers` (desnormalizamos):

```sql
CREATE TABLE northwind_olap.dim_product AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    s.company_name AS supplier_name
FROM public.products p
LEFT JOIN public.categories c ON p.category_id = c.category_id
LEFT JOIN public.suppliers s  ON p.supplier_id = s.supplier_id;
```

### 👩‍💼 `dim_employee`

```sql
CREATE TABLE northwind_olap.dim_employee AS
SELECT
    employee_id,
    first_name,
    last_name,
    title,
    city,
    country
FROM public.employees;
```

### 🚚 `dim_shipper`

```sql
CREATE TABLE northwind_olap.dim_shipper AS
SELECT
    shipper_id,
    company_name AS shipper_name
FROM public.shippers;
```

### 📅 `dim_date`

Generamos una tabla de fechas a partir de las fechas reales de las órdenes:

```sql
CREATE TABLE northwind_olap.dim_date AS
SELECT DISTINCT
    order_date::date AS date_key,
    EXTRACT(YEAR FROM order_date)::int    AS year,
    EXTRACT(QUARTER FROM order_date)::int AS quarter,
    EXTRACT(MONTH FROM order_date)::int   AS month,
    TO_CHAR(order_date, 'Month')          AS month_name,
    EXTRACT(DAY FROM order_date)::int     AS day,
    EXTRACT(DOW FROM order_date)::int     AS weekday,
    TO_CHAR(order_date, 'Day')            AS weekday_name
FROM public.orders
WHERE order_date IS NOT NULL;
```

### ✅ Resultado

El schema `northwind_olap` queda con: `fact_sales`, `dim_customer`, `dim_product`, `dim_employee`, `dim_shipper` y `dim_date`, listo para consultas analíticas y para conectar una herramienta de BI (Metabase, Superset, etc.).

---

## 🧩 5. Consultas analíticas

### 📊 Ventas totales por producto

```sql
SELECT
    p.product_name,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_product p ON f.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;
```

### 🌎 Ventas por país del cliente

```sql
SELECT
    c.country,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_customer c ON f.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_sales DESC;
```

### 👩‍💼 Ventas por empleado

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

### 🗓️ Ventas mensuales

```sql
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.total_amount) AS total_sales
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_date d ON f.order_date = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;
```

### 🏆 Top 10 clientes

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

### 🚚 Ventas por empresa de envío

```sql
SELECT
    s.shipper_name,
    SUM(f.total_amount) AS total_sales,
    COUNT(DISTINCT f.order_id) AS total_orders
FROM northwind_olap.fact_sales f
JOIN northwind_olap.dim_shipper s ON f.shipper_id = s.shipper_id
GROUP BY s.shipper_name
ORDER BY total_sales DESC;
```

---

## 🧩 6. Levantar Metabase

```bash
docker run -d -p 4000:3000 --name my_metabase_bootcamp metabase/metabase
```

Entrar a <http://localhost:4000>, crear el usuario admin y agregar la base:

| Campo         | Valor                   |
| ------------- | ----------------------- |
| Database type | PostgreSQL              |
| Host          | `host.docker.internal`  |
| Port          | `5433`                  |
| Database name | `northwind`             |
| Username      | `myuser`                |
| Password      | `mypassword`            |

> 💡 Metabase corre en otro contenedor: para llegar al Postgres de nuestra máquina usa `host.docker.internal` y el puerto publicado `5433`.
