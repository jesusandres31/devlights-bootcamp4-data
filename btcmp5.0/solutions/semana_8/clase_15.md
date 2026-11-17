# Semana 8 · Clase 15 · Solución — Consultas sobre Northwind + esquema estrella

> 📝 **Consigna:** [Tarea Clase 15](../../tasks/semana_8/clase_15.md)

---

# 📝 Parte 1: Consultas sobre Northwind

## 🟢 Nivel 1: Consultas básicas

```sql
-- 1.1 Nombre y teléfono de los proveedores
SELECT company_name, phone
FROM suppliers
ORDER BY company_name;

-- 1.2 Productos con precio < 20, de menor a mayor
SELECT product_name, unit_price
FROM products
WHERE unit_price < 20
ORDER BY unit_price;

-- 1.3 Nombre completo de empleados y país
SELECT first_name || ' ' || last_name AS empleado, country
FROM employees
ORDER BY country, empleado;

-- 1.4 Cantidad de productos por categoría
SELECT category_id, COUNT(*) AS cantidad_productos
FROM products
GROUP BY category_id
ORDER BY cantidad_productos DESC;

-- 1.5 Los 10 pedidos más antiguos
SELECT order_id, customer_id, order_date
FROM orders
ORDER BY order_date
LIMIT 10;
```

## 🟡 Nivel 2: Filtros y condiciones

```sql
-- 2.1 Clientes de Francia o Alemania
SELECT company_name, city, country
FROM customers
WHERE country IN ('France', 'Germany')
ORDER BY country, company_name;

-- 2.2 Productos descontinuados por proveedor
--     En esta versión de Northwind, discontinued es 1 (sí) / 0 (no)
SELECT supplier_id, COUNT(*) AS descontinuados
FROM products
WHERE discontinued = 1
GROUP BY supplier_id
ORDER BY descontinuados DESC;

-- 2.3 Pedidos enviados por mes durante 1997
SELECT EXTRACT(MONTH FROM shipped_date) AS mes,
       COUNT(*) AS pedidos_enviados
FROM orders
WHERE EXTRACT(YEAR FROM shipped_date) = 1997
GROUP BY mes
ORDER BY mes;
```

## 🔵 Nivel 3: Joins simples y múltiples

```sql
-- 3.1 Productos con categoría y proveedor
SELECT p.product_name,
       c.category_name,
       s.company_name AS proveedor
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s  ON p.supplier_id = s.supplier_id
ORDER BY c.category_name, p.product_name;

-- 3.2 Pedidos con cliente, empleado y empresa de envío
SELECT o.order_id,
       o.order_date,
       c.company_name AS cliente,
       e.first_name || ' ' || e.last_name AS empleado,
       sh.company_name AS envio
FROM orders o
INNER JOIN customers c  ON o.customer_id = c.customer_id
INNER JOIN employees e  ON o.employee_id = e.employee_id
INNER JOIN shippers sh  ON o.ship_via = sh.shipper_id
ORDER BY o.order_date;

-- 3.3 Todos los clientes y su cantidad de pedidos
--     COUNT(o.order_id) devuelve 0 para los clientes sin pedidos
SELECT c.company_name, COUNT(o.order_id) AS cantidad_pedidos
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.company_name
ORDER BY cantidad_pedidos DESC, c.company_name;

-- 3.4 ⭐ Precio promedio de productos por proveedor
SELECT s.company_name AS proveedor,
       ROUND(AVG(p.unit_price)::numeric, 2) AS precio_promedio
FROM products p
JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.company_name
ORDER BY precio_promedio DESC;
```

> 💡 En 1.4 y 2.2 también se puede hacer `JOIN` con `categories` / `suppliers` para mostrar el nombre en vez del id.

---

# 📝 Parte 2: Esquema estrella

## 1️⃣ + 2️⃣ Schema y CTAS

Son exactamente los pasos de la clase: [Clase 15 → secciones 3 a 5](../../notes/semana_8/clase_15.md#-3-preparación-un-schema-analítico). Si el alumno eligió otro nombre de schema, solo cambia el prefijo `northwind_olap.`.

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

## 4️⃣ Consultas analíticas

Son las de [Clase 15 → Consultas analíticas](../../notes/semana_8/clase_15.md#-6-consultas-analíticas). Valores de control:

| Consulta                    | Primer resultado              |
| --------------------------- | ----------------------------- |
| Ventas por categoría        | Beverages · 267868.16         |
| Ventas por país del cliente | USA · 245584.59               |
| Top 10 clientes             | QUICK-Stop · 110277.31        |
