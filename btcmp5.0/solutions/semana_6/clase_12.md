# Semana 6 · Clase 12 · Solución — JOINs sobre el minimercado

> 📝 **Consigna:** [Tarea Clase 12](../../tasks/semana_6/clase_12.md)

---

```sql
-- 1. INNER JOIN: proveedores y sus productos
SELECT pr.nombre AS proveedor, p.nombre AS producto
FROM proveedores pr
INNER JOIN productos p ON p.proveedor_id = pr.id
ORDER BY pr.nombre, p.nombre;

-- 2. LEFT JOIN: todos los proveedores y cuántos productos tienen
--    COUNT(p.id) cuenta solo los no NULL → "Proveedor Nuevo" queda en 0
SELECT pr.nombre AS proveedor, COUNT(p.id) AS cantidad_productos
FROM proveedores pr
LEFT JOIN productos p ON p.proveedor_id = pr.id
GROUP BY pr.nombre
ORDER BY cantidad_productos DESC, pr.nombre;

-- 3. LEFT JOIN + IS NULL: ventas sin productos cargados
SELECT v.id, v.fecha, v.total
FROM ventas v
LEFT JOIN venta_productos vp ON vp.venta_id = v.id
WHERE vp.venta_id IS NULL
ORDER BY v.id;
-- → ventas 21 a 40

-- 4. RIGHT JOIN: todos los métodos de pago y cuántas ventas tiene cada uno
SELECT mp.nombre AS metodo_pago, COUNT(v.id) AS cantidad_ventas
FROM ventas v
RIGHT JOIN metodos_pago mp ON v.metodo_pago_id = mp.id
GROUP BY mp.nombre
ORDER BY cantidad_ventas DESC;

-- 5. FULL OUTER JOIN: productos que nunca se vendieron
SELECT p.nombre AS producto
FROM productos p
FULL OUTER JOIN venta_productos vp ON vp.producto_id = p.id
WHERE vp.producto_id IS NULL
ORDER BY p.nombre;
-- → "Producto Sin Ventas"
-- Nota: como venta_productos tiene FK a productos, nunca hay detalle sin producto,
-- así que acá el FULL OUTER JOIN devuelve lo mismo que un LEFT JOIN.

-- 6. CROSS JOIN: productos × métodos de pago
SELECT p.nombre AS producto, p.precio, mp.nombre AS metodo_pago
FROM productos p
CROSS JOIN metodos_pago mp
ORDER BY p.nombre, mp.nombre;
-- → 21 productos × 5 métodos = 105 filas

-- 7. JOIN múltiple: cliente, fecha y unidades por venta
SELECT c.nombre AS cliente, v.fecha, SUM(vp.cantidad) AS unidades
FROM ventas v
JOIN clientes c         ON v.cliente_id = c.id
JOIN venta_productos vp ON vp.venta_id = v.id
GROUP BY v.id, c.nombre, v.fecha
ORDER BY v.fecha;

-- 8. JOIN múltiple: total facturado por proveedor
SELECT pr.nombre AS proveedor,
       SUM(vp.cantidad * vp.precio_unitario) AS total_facturado
FROM venta_productos vp
JOIN productos p    ON vp.producto_id = p.id
JOIN proveedores pr ON p.proveedor_id = pr.id
GROUP BY pr.nombre
ORDER BY total_facturado DESC;
```
