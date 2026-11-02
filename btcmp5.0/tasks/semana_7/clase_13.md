# Semana 7 · Clase 13 · Tarea — Consultas sobre Northwind

> 📚 **Tema de la clase:** [Clase 13 — Práctica SQL con Northwind](../../notes/semana_7/clase_13.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 15.

## 🎯 Objetivo

Resolver consultas de dificultad creciente sobre Northwind, combinando filtros, agregaciones y joins.

## 🧱 Preparación

Tener restaurada la base `northwind` (ver [Clase 13 → Restaurar Northwind](../../notes/semana_7/clase_13.md#-1-restaurar-northwind)).

> 💡 Usar `ORDER BY` siempre que se pueda.

## 📝 Ejercicios

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

## ✅ Entrega

Archivo `.sql` con las 12 consultas, cada una con un comentario indicando nivel y número.
