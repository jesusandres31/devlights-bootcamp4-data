# Semana 8 · Clase 16 · Tarea — Gráficos y dashboard en Metabase

> 📚 **Tema de la clase:** [Clase 16 — Metabase: gráficos y dashboard sobre Northwind analítico](../../notes/semana_8/clase_16.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 17.

## 🎯 Objetivo

Hacer en tu máquina lo que vimos en clase: conectar Metabase al esquema estrella, crear los gráficos y armar el dashboard completo, **incluyendo las questions que no llegamos a ver** en la clase.

## 🧱 Preparación

Tener el esquema estrella de Northwind (ver [Tarea Clase 15](clase_15.md)).

## 📝 Parte 1: Metabase y primeros gráficos

1. Agregar el servicio `metabase` al `docker-compose.yml` y levantarlo (ver [Clase 16 → Levantar Metabase](../../notes/semana_8/clase_16.md#-1-levantar-metabase)).
2. Conectar la base `northwind`.
3. Crear estos gráficos usando el esquema analítico:

| #  | Gráfico                         | Tipo recomendado                                      |
| -- | ------------------------------- | ----------------------------------------------------- |
| a) | Ventas totales por producto     | Barras horizontales                                   |
| b) | Ventas por país del cliente     | Mapa (geográfico) o barras                            |
| c) | Ventas por empleado (vendedor)  | Barras verticales                                     |
| d) | Ventas mensuales                | Línea temporal                                        |
| e) | Top 10 clientes por ventas      | Barras horizontales                                   |
| f) | Ventas por empresa de envío     | Barras o torta (son pocos shippers)                   |

## 📝 Parte 2: Dashboard

1. Crear las mismas pestañas (tabs) que usamos en clase: **KPIs**, **Tendencias**, **Ranking** y **Segmentación**.
2. Recrear todas las questions de ejemplo de cada pestaña (ver la [Clase 16](../../notes/semana_8/clase_16.md)).
3. Conectar las variables (`start_date`, `end_date`, `category`, `year`) como **filtros del dashboard**.
4. Elegir la visualización adecuada para cada question (número, líneas, barras, mapa, tabla).
5. Organizar el dashboard de forma clara y prolija: KPIs arriba, títulos descriptivos, ejes con nombre.
6. ⭐ Extra (opcional): agregar gráficos o questions nuevas que consideren interesantes.

📄 Material de apoyo (a partir de la página 3): <https://docs.google.com/document/d/15xfSbMD8VVUX55ls-S7V2g-ODRMfwy1OcObAVkyCDpE>

## ✅ Entrega

- Capturas de los 6 gráficos de la Parte 1.
- Capturas de cada pestaña del dashboard (o link si está publicado).
