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
--    COUNT(p.id) cuenta solo los no NULL → "Bebidas del Litoral" y
--    "Panificadora San Juan" quedan en 0
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
-- → ventas 37, 70, 75, 86, 94, 121, 123 y 130

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
-- → Aceite de Oliva, Caramelos Surtidos, Leche Deslactosada, Salmón Ahumado
--   y Vela Aromática
-- Nota: como venta_productos tiene FK a productos, nunca hay detalle sin producto,
-- así que acá el FULL OUTER JOIN devuelve lo mismo que un LEFT JOIN.

-- 6. CROSS JOIN: productos × métodos de pago
SELECT p.nombre AS producto, p.precio, mp.nombre AS metodo_pago
FROM productos p
CROSS JOIN metodos_pago mp
ORDER BY p.nombre, mp.nombre;
-- → 42 productos × 8 métodos = 336 filas

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

-- 9. INNER + LEFT: todos los productos, su proveedor y unidades vendidas
--    INNER con proveedores (todo producto tiene proveedor) y LEFT con
--    venta_productos para no perder los que nunca se vendieron.
--    COALESCE convierte el NULL del SUM en 0.
SELECT p.nombre AS producto, pr.nombre AS proveedor,
       COALESCE(SUM(vp.cantidad), 0) AS unidades_vendidas
FROM productos p
INNER JOIN proveedores pr    ON p.proveedor_id = pr.id
LEFT JOIN venta_productos vp ON vp.producto_id = p.id
GROUP BY p.id, p.nombre, pr.nombre
ORDER BY unidades_vendidas DESC, p.nombre;
-- → los productos que nunca se vendieron aparecen al final con 0

-- 10. INNER + INNER + LEFT: ventas con cliente, método de pago y productos distintos
--     COUNT(vp.producto_id) no cuenta los NULL → las ventas sin detalle quedan en 0
SELECT v.id AS venta, v.fecha, c.nombre AS cliente, mp.nombre AS metodo_pago,
       COUNT(vp.producto_id) AS productos_distintos
FROM ventas v
INNER JOIN clientes c        ON v.cliente_id = c.id
INNER JOIN metodos_pago mp   ON v.metodo_pago_id = mp.id
LEFT JOIN venta_productos vp ON vp.venta_id = v.id
GROUP BY v.id, v.fecha, c.nombre, mp.nombre
ORDER BY v.id;
-- → ventas 37, 70, 75, 86, 94, 121, 123 y 130 con 0

-- 11. LEFT + LEFT: proveedores y en cuántas ventas distintas se vendió algo suyo
--     COUNT(DISTINCT ...) porque una misma venta puede tener varios productos
--     del mismo proveedor.
SELECT pr.nombre AS proveedor, COUNT(DISTINCT vp.venta_id) AS ventas
FROM proveedores pr
LEFT JOIN productos p        ON p.proveedor_id = pr.id
LEFT JOIN venta_productos vp ON vp.producto_id = p.id
GROUP BY pr.nombre
ORDER BY ventas DESC, pr.nombre;
-- → "Bebidas del Litoral" y "Panificadora San Juan" con 0
-- Si el segundo LEFT JOIN se cambia por INNER JOIN, esos proveedores desaparecen:
-- el INNER descarta las filas donde p.id es NULL (no tienen productos), así que
-- se pierde lo que había conservado el primer LEFT. Una vez que usás LEFT, los
-- JOIN siguientes que dependen de esa tabla también tienen que ser LEFT.
```
