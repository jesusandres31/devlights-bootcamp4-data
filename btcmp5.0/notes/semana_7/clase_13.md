# Semana 7 · Clase 13 — Práctica SQL con Northwind

> 🎯 **Objetivo:** restaurar una base de datos "real" (Northwind) y repasar todo lo visto: `SELECT`, `WHERE`, `ORDER BY`, agregaciones y `JOIN`s.
>
> 📝 **Tarea:** [Tarea Clase 13 — Consultas sobre Northwind](../../tasks/semana_7/clase_13.md)

---

## 🧩 1. Restaurar Northwind

Northwind es la base de ejemplo de una distribuidora de alimentos: clientes, pedidos, productos, proveedores, empleados y transportistas.

1. Descargar `northwind.sql` de <https://github.com/pthom/northwind_psql>.
2. En pgAdmin, crear la base `northwind`.
3. Abrir el **Query Tool** sobre `northwind`, abrir el archivo `northwind.sql` y ejecutarlo.

Alternativa por consola:

```bash
docker cp northwind.sql my_postgres_bootcamp:/tmp/northwind.sql
docker exec -it my_postgres_bootcamp psql -U myuser -d northwind -f /tmp/northwind.sql
```

Tablas principales:

| Tabla           | Contenido                                   |
| --------------- | ------------------------------------------- |
| `customers`     | Clientes                                    |
| `orders`        | Pedidos (cliente, empleado, fechas, envío)  |
| `order_details` | Líneas de cada pedido (producto, cantidad)  |
| `products`      | Productos (precio, stock, categoría)        |
| `categories`    | Categorías de productos                     |
| `suppliers`     | Proveedores                                 |
| `employees`     | Empleados (con `reports_to` → su jefe)      |
| `shippers`      | Empresas de envío                           |

---

## 🧩 2. Ejercicios en clase

### 1️⃣ Listar todos los clientes

```sql
SELECT *
FROM customers;
```

### 2️⃣ Nombre de producto y precio unitario

```sql
SELECT product_name, unit_price
FROM products;
```

### 3️⃣ Productos con precio mayor a 50

```sql
SELECT product_name, unit_price
FROM products
WHERE unit_price > 50;
```

### 4️⃣ Clientes ordenados por país

```sql
SELECT company_name, country
FROM customers
ORDER BY country;
```

### 5️⃣ Cantidad total de pedidos

```sql
SELECT COUNT(*) AS total_pedidos
FROM orders;
```

### 6️⃣ Productos con stock bajo (menos de 10 unidades)

```sql
SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock < 10;
```

### 7️⃣ JOIN simple: productos y su proveedor

```sql
SELECT p.product_name, s.company_name AS proveedor
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id;
```

### 8️⃣ JOIN con filtro: productos caros y su categoría

```sql
SELECT p.product_name, c.category_name, p.unit_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.unit_price > 50;
```

### 9️⃣ JOIN múltiple: pedidos con cliente y empleado

```sql
SELECT o.order_id,
       c.company_name AS cliente,
       e.first_name || ' ' || e.last_name AS empleado
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN employees e ON o.employee_id = e.employee_id;
```

### 🔟 JOIN múltiple con filtro: pedidos enviados a Alemania

```sql
SELECT c.company_name AS cliente,
       p.product_name,
       od.quantity,
       o.ship_country
FROM orders o
JOIN customers c      ON o.customer_id = c.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p       ON od.product_id = p.product_id
WHERE o.ship_country = 'Germany';
```

### 1️⃣1️⃣ SELF JOIN: cada empleado y su jefe

```sql
SELECT e.first_name || ' ' || e.last_name AS empleado,
       j.first_name || ' ' || j.last_name AS jefe
FROM employees e
LEFT JOIN employees j ON e.reports_to = j.employee_id
ORDER BY jefe, empleado;
```

👉 Con `LEFT JOIN` aparece también el empleado que no reporta a nadie (jefe = `NULL`).
