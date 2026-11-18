# Semana 9 · Clase 17 · Tarea — Desnormalizar Northwind con PySpark

> 📚 **Tema de la clase:** [Clase 17 — PySpark: desnormalizar Northwind con Python](../../notes/semana_9/clase_17.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 18 (en esa clase usamos los CSV en Google Colab).

## 🎯 Objetivo

Hacer en tu máquina lo que vimos en clase: generar el esquema estrella de Northwind en CSV con PySpark, y hacerle algunos cambios al script.

## 🧱 Preparación

Tener la carpeta [`pyspark/`](../../pyspark/) del repo junto con [`datasets/northwind.sql`](../../datasets/northwind.sql), respetando la estructura (ver [Clase 17 → Un docker-compose propio](../../notes/semana_9/clase_17.md#-3-un-docker-compose-propio-para-esta-clase)).

## 📝 Ejercicios

1. Desde la carpeta `pyspark/`, ejecutar `docker compose up --exit-code-from pyspark`. Verificar que aparezcan los 7 CSV en `pyspark/output/` y después limpiar con `docker compose down -v`.
2. Subir los 7 CSV a una carpeta **`northwind_csv`** en tu Google Drive (los usamos en la Clase 18).
3. Modificar el script para que `fact_sales` tenga dos columnas más:
   - `shipped_date`: fecha de envío del pedido (está en `orders`).
   - `days_to_ship`: días entre `order_date` y `shipped_date`. (`F.datediff`)

   Volver a ejecutar `docker compose up --exit-code-from pyspark` y abrir `fact_sales.csv` para comprobar las columnas nuevas.
4. ⭐ Agregar al script un CSV nuevo, `ventas_por_categoria.csv`, con una fila por categoría: `category_name`, total vendido y cantidad de pedidos distintos, ordenado de mayor a menor venta. (`groupBy`, `agg`, `F.sum`, `F.countDistinct`)

## ✅ Entrega

- Captura de la consola con los mensajes `OK ...` del script.
- Captura de la carpeta `northwind_csv` en Google Drive.
- El script `desnormalizar_northwind.py` modificado.
