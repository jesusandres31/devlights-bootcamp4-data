# Semana 4 · Clase 8 · Tarea

## 🧩 Mini desafío

Crear la base de datos `test_db`.

Crear la tabla:

```sql
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    product VARCHAR(50),
    category VARCHAR(30),
    price NUMERIC,
    quantity INT,
    sale_date DATE
);
```

Insertar los datos:

```sql
INSERT INTO sales (product, category, price, quantity, sale_date) VALUES
('Mouse', 'Electronics', 15, 4, '2023-07-10'),
('Keyboard', 'Electronics', 30, 2, '2023-07-11'),
('Notebook', 'Stationery', 8, 10, '2023-07-12'),
('Pen', 'Stationery', 2, 25, '2023-07-13'),
('Headphones', 'Electronics', 40, 3, '2023-07-14'),
('Monitor', 'Electronics', 120, 1, '2023-07-15'),
('Desk Chair', 'Furniture', 85, 2, '2023-07-16'),
('Notebook Case', 'Accessories', 25, 3, '2023-07-17'),
('Printer Paper', 'Stationery', 6, 15, '2023-07-18'),
('USB Drive', 'Electronics', 12, 5, '2023-07-19'),
('Desk Lamp', 'Furniture', 35, 4, '2023-07-20'),
('Stapler', 'Stationery', 7, 6, '2023-07-21'),
('Calculator', 'Electronics', 20, 3, '2023-07-22'),
('Water Bottle', 'Accessories', 10, 8, '2023-07-23'),
('Laptop Stand', 'Accessories', 45, 2, '2023-07-24'),
('Office Desk', 'Furniture', 150, 1, '2023-07-25'),
('Whiteboard', 'Furniture', 60, 1, '2023-07-26'),
('Marker Set', 'Stationery', 5, 12, '2023-07-27'),
('Mouse Pad', 'Accessories', 8, 7, '2023-07-28'),
('Webcam', 'Electronics', 50, 2, '2023-07-29'),
('Smartphone', 'Electronics', 300, 1, '2023-07-30'),
('Notebook Pro', 'Electronics', 900, 1, '2023-07-31'),
('File Cabinet', 'Furniture', 120, 1, '2023-08-01'),
('Backpack', 'Accessories', 40, 3, '2023-08-02'),
('Binder', 'Stationery', 4, 20, '2023-08-03'),
('Headset Stand', 'Accessories', 15, 5, '2023-08-04'),
('Desk Organizer', 'Accessories', 12, 6, '2023-08-05'),
('Laptop Sleeve', 'Accessories', 30, 2, '2023-08-06'),
('Paper Clips', 'Stationery', 1, 50, '2023-08-07'),
('Surge Protector', 'Electronics', 25, 3, '2023-08-08'),
('Pen Holder', 'Accessories', 5, 10, '2023-08-09');
```

### 📝 Ejercicios

1. Mostrar todas las ventas de la categoría `'Electronics'`.
2. Calcular el total de ingresos por categoría (`price * quantity`).
3. Obtener la categoría con mayor ingreso total.
4. Mostrar todas las ventas donde el precio del producto sea mayor a 20.
5. Calcular el total de unidades vendidas (`SUM(quantity)`) por cada producto.
6. Calcular el ingreso promedio por venta (`AVG(price * quantity)`) para cada producto.
7. Mostrar los 3 productos con mayor cantidad total vendida (`SUM(quantity)`) usando `ORDER BY` y `LIMIT`.
8. Mostrar todas las ventas realizadas después del 12 de julio de 2023.
9. Mostrar la categoría y el ingreso total, pero solo para categorías cuyo ingreso sea mayor a 50 (`HAVING SUM(price * quantity) > 50`).
10. Mostrar todas las ventas donde el nombre del producto comience con la letra H (`LIKE 'H%'`).
11. Calcular la cantidad promedio de productos vendidos (`AVG(quantity)`) agrupados por categoría.
12. Mostrar todas las ventas y calcular el ingreso por fila (`price * quantity`), ordenadas de mayor a menor ingreso.
13. Mostrar todas las ventas de la categoría `'Electronics'` donde la cantidad sea mayor a 2 y el precio menor a 40.
