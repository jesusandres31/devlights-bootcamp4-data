# Semana 5 · Clase 9 · Solución — Crear tablas y consultar ventas

> 📝 **Consigna:** [Tarea Clase 9](../../tasks/semana_5/clase_9.md)

---

## 🧱 Parte 1 — Tabla de departamentos

```sql
CREATE TABLE apartments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50),
    postal_code VARCHAR(10),
    bedrooms INT,
    area_m2 NUMERIC(6,2),
    price NUMERIC(10,2),
    available BOOLEAN,
    published_date DATE
);

INSERT INTO apartments (name, address, city, postal_code, bedrooms, area_m2, price, available, published_date) VALUES
('Depto A', 'Av. Siempre Viva 123', 'Buenos Aires', 'C1000', 2, 55.5, 120000, TRUE, '2023-08-01'),
('Depto B', 'Belgrano 450', 'Corrientes', 'W3400', 1, 38.0, 65000, TRUE, '2023-08-03'),
('Depto C', 'San Martín 980', 'Resistencia', 'H3500', 3, 82.3, 98000, FALSE, '2023-07-21'),
('Depto D', 'Junín 1520', 'Corrientes', 'W3400', 2, 48.7, 78000, TRUE, '2023-08-10'),
('Depto E', 'Av. Corrientes 3200', 'Buenos Aires', 'C1193', 1, 32.0, 95000, TRUE, '2023-06-15'),
('Depto F', 'Mitre 77', 'Rosario', 'S2000', 2, 60.0, 110000, FALSE, '2023-07-02'),
('Depto G', 'Pellegrini 1200', 'Rosario', 'S2000', 3, 90.5, 150000, TRUE, '2023-08-12'),
('Depto H', 'Yrigoyen 640', 'Resistencia', 'H3500', 2, 52.0, 70000, TRUE, '2023-08-05'),
('Depto I', 'Colón 2100', 'Córdoba', 'X5000', 1, 40.0, 72000, TRUE, '2023-07-28'),
('Depto J', 'Bv. San Juan 330', 'Córdoba', 'X5000', 2, 58.4, 99000, FALSE, '2023-08-08');
-- ...
```

```sql
-- 1. Departamentos disponibles, del más barato al más caro
SELECT * FROM apartments
WHERE available = TRUE
ORDER BY price;

-- 2. Precio promedio por ciudad
SELECT city, AVG(price) AS avg_price
FROM apartments
GROUP BY city
ORDER BY avg_price DESC;

-- 3. 2 o más habitaciones y menos de 60 m²
SELECT * FROM apartments
WHERE bedrooms >= 2 AND area_m2 < 60;
```

---

## 🧱 Parte 2 — Ventas

```sql
-- 1. Ventas de la categoría Electronics
SELECT * FROM sales
WHERE category = 'Electronics';

-- 2. Total de ingresos por categoría
SELECT category, SUM(price * quantity) AS total_revenue
FROM sales
GROUP BY category;

-- 3. Categoría con mayor ingreso total
SELECT category, SUM(price * quantity) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 1;

-- 4. Ventas con precio mayor a 20
SELECT * FROM sales
WHERE price > 20;

-- 5. Total de unidades vendidas por producto
SELECT product, SUM(quantity) AS total_units
FROM sales
GROUP BY product;

-- 6. Ingreso promedio por venta para cada producto
SELECT product, AVG(price * quantity) AS avg_revenue
FROM sales
GROUP BY product;

-- 7. Top 3 productos por cantidad vendida
SELECT product, SUM(quantity) AS total_units
FROM sales
GROUP BY product
ORDER BY total_units DESC
LIMIT 3;

-- 8. Ventas posteriores al 12 de julio de 2023
SELECT * FROM sales
WHERE sale_date > '2023-07-12';

-- 9. Categorías con ingreso total mayor a 50
SELECT category, SUM(price * quantity) AS total_revenue
FROM sales
GROUP BY category
HAVING SUM(price * quantity) > 50;

-- 10. Productos que empiezan con H
SELECT * FROM sales
WHERE product LIKE 'H%';

-- 11. Cantidad promedio vendida por categoría
SELECT category, AVG(quantity) AS avg_quantity
FROM sales
GROUP BY category;

-- 12. Ingreso por fila, de mayor a menor
SELECT *, price * quantity AS revenue
FROM sales
ORDER BY revenue DESC;

-- 13. Electronics con cantidad > 2 y precio < 40
SELECT * FROM sales
WHERE category = 'Electronics'
  AND quantity > 2
  AND price < 40;
```

> 💡 En el ejercicio 3 la respuesta es **Electronics** (1855). En el 7, el top 3 es Paper Clips (50), Pen (25) y Binder (20).
