# Semana 7 · Clase 13 · Solución — SQL avanzado sobre el minimercado

> 📝 **Consigna:** [Tarea Clase 13](../../tasks/semana_7/clase_13.md)

---

## 👁️ Vistas

```sql
-- 1. Ventas por cliente (incluye clientes sin compras)
CREATE OR REPLACE VIEW vista_ventas_por_cliente AS
SELECT
    c.id                                               AS cliente_id,
    c.nombre                                           AS cliente,
    COUNT(DISTINCT v.id)                               AS cantidad_ventas,
    COALESCE(SUM(vp.cantidad * vp.precio_unitario), 0) AS total_gastado
FROM clientes c
LEFT JOIN ventas v           ON v.cliente_id = c.id
LEFT JOIN venta_productos vp ON vp.venta_id = v.id
GROUP BY c.id, c.nombre;

SELECT cliente, cantidad_ventas, total_gastado
FROM vista_ventas_por_cliente
ORDER BY total_gastado DESC
LIMIT 5;

-- 2. Productos con su proveedor
CREATE OR REPLACE VIEW vista_productos_proveedor AS
SELECT
    p.nombre  AS producto,
    p.precio,
    p.stock,
    pr.nombre AS proveedor
FROM productos p
JOIN proveedores pr ON pr.id = p.proveedor_id;

SELECT producto, precio, stock
FROM vista_productos_proveedor
WHERE proveedor = 'Lácteos del Valle'
ORDER BY producto;

-- 3. ⭐ Vista materializada por método de pago
CREATE MATERIALIZED VIEW mv_ventas_por_metodo_pago AS
SELECT
    mp.nombre            AS metodo_pago,
    COUNT(v.id)          AS cantidad_ventas,
    COALESCE(SUM(v.total), 0) AS total_vendido
FROM metodos_pago mp
LEFT JOIN ventas v ON v.metodo_pago_id = mp.id
GROUP BY mp.nombre;

SELECT * FROM mv_ventas_por_metodo_pago ORDER BY total_vendido DESC;

INSERT INTO ventas (cliente_id, metodo_pago_id, total) VALUES (1, 7, 50.00);  -- Cheque

SELECT * FROM mv_ventas_por_metodo_pago WHERE metodo_pago = 'Cheque';  -- sigue en 0
REFRESH MATERIALIZED VIEW mv_ventas_por_metodo_pago;
SELECT * FROM mv_ventas_por_metodo_pago WHERE metodo_pago = 'Cheque';  -- ahora 1 venta, 50.00
```

## ⚡ Índices

```sql
-- 4. Índices sobre las foreign keys
CREATE INDEX idx_ventas_cliente_id        ON ventas (cliente_id);
CREATE INDEX idx_ventas_metodo_pago_id    ON ventas (metodo_pago_id);
CREATE INDEX idx_productos_proveedor_id   ON productos (proveedor_id);
CREATE INDEX idx_venta_productos_producto ON venta_productos (producto_id);

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- 5. Prueba con rango de fechas
CREATE TABLE prueba_indices AS
SELECT g                                      AS id,
       (random() * 1000)::int                 AS cliente_id,
       NOW() - random() * INTERVAL '365 days' AS fecha,
       ROUND((random() * 100)::numeric, 2)    AS total
FROM generate_series(1, 1000000) AS g;

EXPLAIN ANALYZE
SELECT * FROM prueba_indices
WHERE fecha >= NOW() - INTERVAL '7 days';   -- Seq Scan

CREATE INDEX idx_prueba_fecha ON prueba_indices (fecha);

EXPLAIN ANALYZE
SELECT * FROM prueba_indices
WHERE fecha >= NOW() - INTERVAL '7 days';   -- Bitmap Index Scan

-- Tiempos de referencia (varían según la máquina): ~130 ms sin índice → ~30 ms con índice

DROP TABLE prueba_indices;
```

> 💡 El índice sobre `venta_productos.venta_id` no hace falta: ya está cubierto por la PK `(venta_id, producto_id)`, porque `venta_id` es la primera columna.

## ⚙️ Funciones y procedimientos

```sql
-- 6. Unidades vendidas de un producto
CREATE OR REPLACE FUNCTION fn_unidades_vendidas(p_producto_id INT)
RETURNS INT
LANGUAGE sql
AS $$
    SELECT COALESCE(SUM(cantidad), 0)::int
    FROM venta_productos
    WHERE producto_id = p_producto_id;
$$;

SELECT nombre, fn_unidades_vendidas(id) AS unidades_vendidas
FROM productos
ORDER BY unidades_vendidas DESC, nombre;

-- 7. Reponer stock con validación
CREATE OR REPLACE PROCEDURE sp_reponer_stock(p_producto_id INT, p_cantidad INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad a reponer debe ser mayor a 0 (se recibió %)', p_cantidad;
    END IF;

    UPDATE productos
    SET stock = stock + p_cantidad
    WHERE id = p_producto_id;
END;
$$;

SELECT nombre, stock FROM productos WHERE id = 25;  -- Jamón Cocido: 0
CALL sp_reponer_stock(25, 40);
SELECT nombre, stock FROM productos WHERE id = 25;  -- 40
CALL sp_reponer_stock(25, -5);                      -- ERROR: La cantidad a reponer debe ser mayor a 0
```

## 🔔 Triggers

```sql
-- 8. Recalcular el total de la venta
CREATE OR REPLACE FUNCTION fn_actualizar_total()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE ventas
    SET total = (
        SELECT SUM(cantidad * precio_unitario)
        FROM venta_productos
        WHERE venta_id = NEW.venta_id
    )
    WHERE id = NEW.venta_id;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_actualizar_total
AFTER INSERT ON venta_productos
FOR EACH ROW
EXECUTE FUNCTION fn_actualizar_total();

-- Prueba: venta nueva con 2 productos
INSERT INTO ventas (cliente_id, metodo_pago_id)
VALUES (2, 3)
RETURNING id;   -- usar este id abajo (152 si antes se hizo el ejercicio 3)

INSERT INTO venta_productos (venta_id, producto_id, cantidad, precio_unitario) VALUES
(152, 1, 2, 1.50),   -- 3.00
(152, 2, 1, 2.00);   -- 2.00

SELECT id, total FROM ventas WHERE id = 152;  -- 5.00

-- 9. ⭐ Devolver stock al borrar una línea
CREATE OR REPLACE FUNCTION fn_devolver_stock()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos
    SET stock = stock + OLD.cantidad
    WHERE id = OLD.producto_id;

    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_devolver_stock
AFTER DELETE ON venta_productos
FOR EACH ROW
EXECUTE FUNCTION fn_devolver_stock();

SELECT stock FROM productos WHERE id = 2;   -- Pan de Molde: 80
DELETE FROM venta_productos WHERE venta_id = 152 AND producto_id = 2;
SELECT stock FROM productos WHERE id = 2;   -- 81
```

> 💡 En el ejercicio 9, al borrar la línea el `total` de la venta queda desactualizado. Para cubrirlo, `trg_actualizar_total` se puede extender a `AFTER INSERT OR UPDATE OR DELETE` usando `COALESCE(NEW.venta_id, OLD.venta_id)`.
