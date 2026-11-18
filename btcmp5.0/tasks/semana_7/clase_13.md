# Semana 7 · Clase 13 · Tarea — SQL avanzado sobre el minimercado

> 📚 **Tema de la clase:** [Clase 13 — SQL avanzado: vistas, índices, procedimientos almacenados y triggers](../../notes/semana_7/clase_13.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 14.

## 🎯 Objetivo

Crear vistas, índices, funciones, procedimientos y triggers sobre la base del minimercado.

## 🧱 Preparación

Recrear la base `minimercado` desde cero ejecutando [`datasets/minimercado.sql`](../../datasets/minimercado.sql). El script borra las tablas y las vuelve a crear con los datos originales.

> 💡 Después de cada ejercicio, hacer un `SELECT` que muestre que funciona.

## 📝 Ejercicios

### 👁️ Vistas

1. Crear la vista `vista_detalle_ventas` con una fila por cada producto vendido: id de la venta, fecha, nombre del cliente, método de pago, producto, proveedor, cantidad, precio unitario y subtotal (`cantidad * precio_unitario`).
2. Usando `vista_detalle_ventas`:
   - Mostrar el total gastado por cada cliente, de mayor a menor.
   - Mostrar los productos más vendidos (unidades), de mayor a menor.
3. Crear la vista `vista_stock_bajo` con los productos que tienen menos de 10 unidades en stock: id, nombre, stock, nombre del proveedor y teléfono del proveedor. Consultarla ordenada por stock.
4. ⭐ Crear la vista materializada `mv_ventas_por_mes` con: mes, cantidad de ventas y total vendido. Consultarla, insertar una venta nueva, volver a consultarla (¿cambió?), hacer `REFRESH` y consultarla otra vez.

### ⚡ Índices

5. Listar los índices que tiene la base consultando `pg_indexes`. ¿Qué columnas ya tienen índice y por qué?
6. Crear una tabla `prueba_indices` con **1 millón de filas** (`id`, `cliente_id`, `fecha`, `total`) usando `generate_series` y `random()`. Ejecutar `EXPLAIN ANALYZE` de una búsqueda por `cliente_id`, crear un índice sobre esa columna y volver a ejecutarlo. Anotar en un comentario los dos **Execution Time** y el tipo de scan de cada uno. Al terminar, borrar la tabla.
7. Crear índices en el minimercado para `ventas.cliente_id`, `venta_productos.producto_id` y `ventas.fecha`. Verificar con `pg_indexes` que se hayan creado.

### ⚙️ Funciones y procedimientos

8. Crear la función `fn_total_gastado(p_cliente_id INT)` que devuelva el total gastado por un cliente (sumando `cantidad * precio_unitario` de sus ventas), o 0 si nunca compró. Usarla para listar todos los clientes con su total gastado, de mayor a menor.
9. Crear el procedimiento `sp_aumentar_precios(p_proveedor_id INT, p_porcentaje NUMERIC)` que aumente en ese porcentaje el precio de todos los productos del proveedor y muestre con `RAISE NOTICE` cuántos productos se actualizaron. Probarlo aumentando 10 % los productos de "Lácteos del Valle" (mostrar los precios antes y después).

### 🔔 Triggers

10. Crear el trigger `trg_descontar_stock`: después de cada `INSERT` en `venta_productos`, descontar la cantidad vendida del stock del producto. Probarlo creando una venta nueva (usar `RETURNING id` para saber su id) y agregándole la Leche Entera; mostrar el stock antes y después.
11. Intentar agregar a esa venta el Jamón Cocido, que tiene stock 0. ¿Qué pasa? ¿Se guardó la línea en `venta_productos`? Explicarlo en un comentario.

## ✅ Entrega

Archivo `.sql` con todos los ejercicios, cada uno con un comentario indicando su número.
