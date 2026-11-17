# Bootcamp 5.0 · Data — Módulo SQL

| Carpeta                    | Contenido                                                  |
| -------------------------- | ---------------------------------------------------------- |
| [`notes/`](notes/)         | Lo que se da en clase (teoría + ejercicios en vivo)        |
| [`tasks/`](tasks/)         | Tarea que queda para la clase siguiente, sobre el mismo tema |
| [`solutions/`](solutions/) | Solución de cada tarea                                     |
| [`datasets/`](datasets/)   | Scripts `.sql` para cargar las bases de práctica           |
| [`pyspark/`](pyspark/)     | `docker-compose` + script de PySpark de la Clase 17        |

## Cronograma

| Semana | Clase | Tema                                           | Notes                                   | Tarea                                                   | Solución                                     |
| ------ | ----- | ---------------------------------------------- | --------------------------------------- | ------------------------------------------------------- | -------------------------------------------- |
| 4      | 8     | Modelado de datos: relaciones                  | [notes](notes/semana_4/clase_8.md)      | [Docker + PostgreSQL + pgAdmin](tasks/semana_4/clase_8.md) | —                                         |
| 5      | 9     | SQL básico: primeras consultas                 | [notes](notes/semana_5/clase_9.md)      | [Crear tablas y consultar ventas](tasks/semana_5/clase_9.md) | [solución](solutions/semana_5/clase_9.md) |
| 5      | 10    | Constraints, normalización y relaciones        | [notes](notes/semana_5/clase_10.md)     | [Relaciones con foreign keys](tasks/semana_5/clase_10.md) | [solución](solutions/semana_5/clase_10.md) |
| 6      | 11    | Diseño de una base completa: minimercado       | [notes](notes/semana_6/clase_11.md)     | [Diseñar una base de datos](tasks/semana_6/clase_11.md)  | [solución](solutions/semana_6/clase_11.md) |
| 6      | 12    | JOINs                                          | [notes](notes/semana_6/clase_12.md)     | [JOINs sobre el minimercado](tasks/semana_6/clase_12.md) | [solución](solutions/semana_6/clase_12.md) |
| 7      | 13    | SQL avanzado: vistas, índices, procedimientos almacenados y triggers | [notes](notes/semana_7/clase_13.md) | [SQL avanzado sobre el minimercado](tasks/semana_7/clase_13.md) | [solución](solutions/semana_7/clase_13.md) |
| 7      | 14    | OLTP vs OLAP: desnormalización y data warehouse | [notes](notes/semana_7/clase_14.md)    | [Restaurar Northwind](tasks/semana_7/clase_14.md)        | —                                            |
| 8      | 15    | Explorar Northwind y armar el modelo estrella  | [notes](notes/semana_8/clase_15.md)     | [Consultas + esquema estrella](tasks/semana_8/clase_15.md) | [solución](solutions/semana_8/clase_15.md) |
| 8      | 16    | Metabase: gráficos y dashboard                 | [notes](notes/semana_8/clase_16.md)     | [Gráficos y dashboard](tasks/semana_8/clase_16.md)       | [solución](solutions/semana_8/clase_16.md) |
| 9      | 17    | PySpark: desnormalizar Northwind con Python    | [notes](notes/semana_9/clase_17.md)     | [Desnormalizar con PySpark](tasks/semana_9/clase_17.md)  | [solución](solutions/semana_9/clase_17.md) |
| 9      | 18    | pandas y matplotlib en Google Colab            | [notes](notes/semana_9/clase_18.md)     | [Análisis en Colab](tasks/semana_9/clase_18.md)          | [solución](solutions/semana_9/clase_18.md) |
| 10–11  | 19–22 | Trabajo práctico final                         | —                                       | _(próximamente)_                                         | —                                            |

## Formato de los archivos

Todos siguen la misma estructura:

- **notes:** `# Semana N · Clase M — Tema` → bloque con 🎯 objetivo y 📝 link a la tarea → secciones `## 🧩 1. ...`
- **tasks:** `# Semana N · Clase M · Tarea — Título` → 📚 link a la clase + 📅 entrega → `🎯 Objetivo` / `🧱 Preparación` / `📝 Ejercicios` / `✅ Entrega`
- **solutions:** `# Semana N · Clase M · Solución — Título` → 📝 link a la consigna → mismas secciones que la tarea
