# Semana 8 · Clase 15 · Tarea — Consultas sobre Northwind + esquema estrella

> 📚 **Tema de la clase:** [Clase 15 — Explorar Northwind y armar el modelo estrella (OLAP)](../../notes/semana_8/clase_15.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 16 (en esa clase conectamos Metabase a este esquema).

## 🎯 Objetivo

Hacer en tu máquina lo que vimos en clase: practicar consultas sobre Northwind y construir su esquema estrella.

## 🧱 Preparación

Tener restaurada la base `northwind` (ver [Tarea Clase 14](../semana_7/clase_14.md)).

> 💡 Usar `ORDER BY` siempre que se pueda.

## 📝 Parte 1: Consultas sobre Northwind

### 🟢 Nivel 1: Consultas básicas

1. Mostrar el nombre y teléfono de todos los proveedores. (`SELECT`, `ORDER BY`)
2. Listar los productos cuyo precio unitario sea menor a 20, ordenados de menor a mayor precio. (`WHERE`, `ORDER BY`)
3. Mostrar el nombre completo de los empleados (nombre y apellido concatenados) y su país. (`||`, `ORDER BY`)
4. Contar la cantidad de productos por categoría. (`COUNT`, `GROUP BY`, `ORDER BY`)
5. Mostrar los 10 pedidos más antiguos. (`ORDER BY`, `LIMIT`)

### 🟡 Nivel 2: Filtros y condiciones

1. Mostrar los clientes de Francia o Alemania. (`WHERE`, `IN`, `ORDER BY`)
2. Listar los productos descontinuados y contar cuántos hay por proveedor. (`WHERE`, `COUNT`, `GROUP BY`, `ORDER BY`)
3. Contar cuántos pedidos se enviaron por mes durante 1997. (`WHERE`, `EXTRACT`, `COUNT`, `GROUP BY`, `ORDER BY`)

### 🔵 Nivel 3: Joins simples y múltiples

1. Mostrar los productos junto con el nombre de su categoría y el nombre del proveedor. (`INNER JOIN`, `ORDER BY`)
2. Mostrar los pedidos con el nombre del cliente, el nombre del empleado y la empresa de envío. (`INNER JOIN`, `ORDER BY`)
3. Mostrar **todos** los clientes y la cantidad de pedidos de cada uno (incluyendo los que no tienen pedidos). (`LEFT JOIN`, `COUNT`, `GROUP BY`, `ORDER BY`)
4. ⭐ Extra: mostrar el precio promedio de los productos de cada proveedor, con el nombre del proveedor. (`JOIN`, `AVG`, `GROUP BY`, `ORDER BY`)

## 📝 Parte 2: Esquema estrella

1. Crear un **schema nuevo** en tu base `northwind` (distinto de `public`).
2. Usando **CTAS** (`CREATE TABLE ... AS SELECT`), generar la tabla de hechos y las tablas de dimensiones del esquema estrella.
3. Las tablas creadas con CTAS no tienen PK ni FK: agregarlas con `ALTER TABLE` (PK en cada dimensión y FK desde `fact_sales` hacia cada una) y compartir una imagen del **DER** de ese schema con la herramienta de pgAdmin (clic derecho sobre la base → **ERD For Database**).
4. Ejecutar las [consultas analíticas](../../notes/semana_8/clase_15.md#-6-consultas-analíticas) de la clase sobre tu schema.

## ✅ Entrega

- Archivo `.sql` con las 12 consultas de la Parte 1, cada una con un comentario indicando nivel y número.
- Archivo `.sql` con el `CREATE SCHEMA`, todos los CTAS y los `ALTER TABLE`.
- Imagen del DER.
