# Semana 6 · Clase 12 · Tarea — JOINs sobre el minimercado

> 📚 **Tema de la clase:** [Clase 12 — JOINs](../../notes/semana_6/clase_12.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 13.

## 🎯 Objetivo

Practicar cada tipo de `JOIN` sobre la base del minimercado.

## 🧱 Preparación

Tener cargada la base `minimercado` con [`datasets/minimercado.sql`](../../datasets/minimercado.sql).

## 📝 Ejercicios

Usar `ORDER BY` en todas las consultas.

### INNER JOIN

1. Mostrar el nombre de cada proveedor y los nombres de sus productos (solo proveedores que tienen productos).

### LEFT JOIN

2. Mostrar **todos** los proveedores y cuántos productos tiene cada uno (incluyendo los que tienen 0).
3. Mostrar las ventas que **no tienen ningún producto** cargado en `venta_productos`.

### RIGHT JOIN

4. Escribiendo la consulta con `RIGHT JOIN`, mostrar **todos** los métodos de pago y cuántas ventas tiene cada uno.

### FULL OUTER JOIN

5. Hacer un `FULL OUTER JOIN` entre `productos` y `venta_productos` y mostrar los productos que **nunca se vendieron**.

### CROSS JOIN

6. Generar todas las combinaciones de productos y métodos de pago (producto, precio, método de pago). ¿Cuántas filas devuelve y por qué?

### JOIN múltiple

7. Mostrar cliente, fecha de venta y **cantidad total de unidades** de cada venta, combinando `ventas`, `venta_productos` y `clientes`.
8. Mostrar el **total facturado** (`cantidad * precio_unitario`) por proveedor, de mayor a menor.

### JOIN múltiple combinando INNER y LEFT

9. Mostrar **todos** los productos con el nombre de su proveedor y cuántas unidades se vendieron de cada uno. Los productos que nunca se vendieron también tienen que aparecer.
10. Mostrar **todas** las ventas con el nombre del cliente, el método de pago y cuántos productos distintos tiene cada una. Las ventas sin productos cargados tienen que aparecer con 0.
11. Mostrar **todos** los proveedores y en cuántas ventas distintas se vendió algún producto suyo (0 si nunca). Después probar cambiar el segundo `LEFT JOIN` por `INNER JOIN`: ¿qué proveedores desaparecen y por qué?

## ✅ Entrega

Archivo `.sql` con las 11 consultas, cada una con un comentario indicando el número de ejercicio.
