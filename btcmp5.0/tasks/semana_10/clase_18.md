# Semana 9 · Clase 18 · Tarea — Análisis de Northwind en Colab

> 📚 **Tema de la clase:** [Clase 18 — Análisis y gráficos con pandas y matplotlib en Google Colab](../../notes/semana_9/clase_18.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 19.

## 🎯 Objetivo

Hacer en tu propio notebook lo que vimos en clase y sumar algunos análisis nuevos.

## 🧱 Preparación

La carpeta `northwind_csv` en tu Google Drive con los 7 CSV (ver [Tarea Clase 17](clase_17.md)).

## 📝 Ejercicios

### Parte 1: Replicar la clase

1. Crear un notebook en Colab, montar Drive y leer `ventas_flat.csv`.
2. Explorar el DataFrame con `head`, `shape`, `info` y `describe`.
3. Recrear los **6 gráficos** de la clase (top productos, países, empleados, mensual, top clientes, envíos).

### Parte 2: Análisis nuevos

4. Gráfico de barras con las **ventas por categoría**, de mayor a menor.
5. Gráfico de barras con la **cantidad de pedidos por año**. (`groupby`, `nunique`)
6. Tabla con el **ticket promedio** (ventas totales ÷ cantidad de pedidos) de los 10 países que más compran. (`agg`, columna calculada)
7. ⭐ Calcular las ventas por categoría usando el **esquema estrella** (`fact_sales` + `dim_product` con `merge`) y comprobar que da lo mismo que el ejercicio 4.
8. Agregar una **celda de texto** debajo de cada gráfico con una conclusión de una línea (por ejemplo: "Beverages es la categoría que más vende").

## ✅ Entrega

Link al notebook de Colab compartido con permiso de lectura (**Compartir → Cualquier persona con el enlace → Lector**), o el archivo `.ipynb` (**Archivo → Descargar → Descargar .ipynb**).
