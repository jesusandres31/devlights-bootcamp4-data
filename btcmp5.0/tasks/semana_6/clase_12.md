# Semana 6 · Clase 12 · Tarea — JOINs sobre el minimercado

> 📚 **Tema de la clase:** [Clase 12 — JOINs](../../notes/semana_6/clase_12.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 13.

## 🎯 Objetivo

Practicar cada tipo de `JOIN` sobre la base del minimercado.

## 🧱 Preparación

1. Tener cargada la base `minimercado` con [`datasets/minimercado.sql`](../../datasets/minimercado.sql).
2. Agregar un proveedor y un producto que todavía no tienen movimiento:

```sql
INSERT INTO proveedores (nombre, telefono, direccion)
VALUES ('Proveedor Nuevo', '555-0299', 'Calle Nueva 1, Ciudad H');

INSERT INTO productos (nombre, precio, stock, proveedor_id)
VALUES ('Producto Sin Ventas', 5.00, 10, 1);
```

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

## ✅ Entrega

Archivo `.sql` con las 8 consultas, cada una con un comentario indicando el número de ejercicio.
