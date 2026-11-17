# Semana 7 · Clase 13 · Tarea — SQL avanzado sobre el minimercado

> 📚 **Tema de la clase:** [Clase 13 — SQL avanzado: vistas, índices, procedimientos almacenados y triggers](../../notes/semana_7/clase_13.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 14.

## 🎯 Objetivo

Crear vistas, índices, funciones, procedimientos y triggers sobre la base del minimercado.

## 🧱 Preparación

Partir de la base `minimercado` limpia: volver a ejecutar [`datasets/minimercado.sql`](../../datasets/minimercado.sql). El script borra las tablas y las vuelve a crear con los datos originales; al borrarlas, también se eliminan las vistas, índices y triggers que hayas creado durante la [Clase 13](../../notes/semana_7/clase_13.md). Así, todo lo que pide esta tarea se crea desde cero.

> 💡 Después de cada ejercicio, hacer un `SELECT` que muestre que funciona.

## 📝 Ejercicios

### 👁️ Vistas

1. Crear `vista_ventas_por_cliente` con: nombre del cliente, cantidad de ventas y total gastado (sumando `cantidad * precio_unitario` de `venta_productos`). Deben aparecer **todos** los clientes, también los que nunca compraron (con 0). Usarla para mostrar los 5 clientes que más gastaron. (`LEFT JOIN`, `COUNT`, `SUM`, `COALESCE`)
2. Crear `vista_productos_proveedor` con: producto, precio, stock y nombre del proveedor. Usarla para listar los productos de "Lácteos del Valle".
3. ⭐ Crear la vista materializada `mv_ventas_por_metodo_pago` con: método de pago, cantidad de ventas y total vendido. Insertar una venta nueva, consultar la vista, hacer `REFRESH` y volver a consultarla.

### ⚡ Índices

4. Crear un índice para cada foreign key que no tenga uno: `ventas.cliente_id`, `ventas.metodo_pago_id`, `productos.proveedor_id` y `venta_productos.producto_id`. Listarlos con `pg_indexes`.
5. Repetir la prueba del millón de filas de la clase, pero filtrando por un **rango de fechas** (los últimos 7 días). Ejecutar `EXPLAIN ANALYZE` antes y después de crear un índice sobre `fecha`, y anotar en un comentario los dos tiempos.

### ⚙️ Funciones y procedimientos

6. Crear la función `fn_unidades_vendidas(p_producto_id INT)` que devuelva el total de unidades vendidas de un producto (0 si nunca se vendió). Usarla para listar todos los productos con sus unidades vendidas, de mayor a menor.
7. Crear el procedimiento `sp_reponer_stock(p_producto_id INT, p_cantidad INT)` que sume `p_cantidad` al stock del producto. Si `p_cantidad` es menor o igual a 0, debe cortar con un error (`RAISE EXCEPTION`). Probarlo con el Jamón Cocido (id 25), que tiene stock 0.

### 🔔 Triggers

8. Crear el trigger `trg_actualizar_total`: después de cada `INSERT` en `venta_productos`, recalcular el `total` de esa venta en `ventas` como la suma de sus líneas. Probarlo creando una venta nueva con 2 productos.
9. ⭐ Crear el trigger `trg_devolver_stock`: cuando se **borra** una línea de `venta_productos`, devolver esa cantidad al stock del producto. (`AFTER DELETE`, `OLD`)

## ✅ Entrega

Archivo `.sql` con todos los ejercicios, cada uno con un comentario indicando su número.
