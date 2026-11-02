# Semana 8 · Clase 15 · Tarea — Esquema estrella + gráficos en Metabase

> 📚 **Tema de la clase:** [Clase 15 — Modelo estrella (OLAP) a partir de Northwind](../../notes/semana_8/clase_15.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 16 (el dashboard de la próxima clase se arma sobre este esquema).

## 🎯 Objetivo

Construir el esquema estrella de Northwind en tu propia base y visualizarlo en Metabase.

## 📝 Pasos

1. Crear un **schema nuevo** en tu base `northwind` (distinto de `public`).
2. Usando **CTAS** (`CREATE TABLE ... AS SELECT`), generar la tabla de hechos y las tablas de dimensiones del esquema estrella.
3. Compartir una imagen del **DER** de ese schema (pgAdmin → clic derecho sobre el schema → _ERD For Schema_, o dbdiagram.io).
4. Levantar **Metabase**, conectar la base y crear estos gráficos usando el esquema analítico:

| #  | Gráfico                         | Tipo recomendado                                      |
| -- | ------------------------------- | ----------------------------------------------------- |
| a) | Ventas totales por producto     | Barras horizontales                                   |
| b) | Ventas por país del cliente     | Mapa (geográfico) o barras                            |
| c) | Ventas por empleado (vendedor)  | Barras verticales                                     |
| d) | Ventas mensuales                | Línea temporal                                        |
| e) | Top 10 clientes por ventas      | Barras horizontales                                   |
| f) | Ventas por empresa de envío     | Barras o torta (son pocos shippers)                   |

## ✅ Entrega

- Archivo `.sql` con el `CREATE SCHEMA` y todos los CTAS.
- Imagen del DER.
- Capturas de los 6 gráficos en Metabase.
