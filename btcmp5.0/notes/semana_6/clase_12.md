# Semana 6 · Clase 12 — JOINs

> 🎯 **Objetivo:** combinar datos de varias tablas con `JOIN` (INNER, LEFT, RIGHT, FULL, CROSS, SELF), encadenar joins y agregar resultados con `GROUP BY`.
>
> 📝 **Tarea:** [Tarea Clase 12 — JOINs sobre el minimercado](../../tasks/semana_6/clase_12.md)

---

## 🧩 1. Cargar el dataset del minimercado

Usamos la misma estructura de la Clase 11, pero con muchos más datos (15 clientes, 20 productos, 40 ventas).

1. En pgAdmin, sobre la base `minimercado`, abrir el **Query Tool**.
2. Abrir y ejecutar [`datasets/minimercado.sql`](../../datasets/minimercado.sql) (borra las tablas de la clase anterior y las vuelve a crear con datos).

Para tener casos "sin coincidencia" en los ejemplos, agregar un cliente que nunca compró:

```sql
INSERT INTO clientes (nombre, email, telefono)
VALUES ('Cliente Sin Compras', 'sin.compras@email.com', '555-0199');
```

> 💡 Las ventas 21 a 40 tampoco tienen productos cargados en `venta_productos`: también sirven para ver `NULL` en los LEFT JOIN.

---

## 🧩 2. ¿Qué es un JOIN?

Un `JOIN` combina filas de dos tablas usando una condición, normalmente **FK = PK**.

```sql
-- Nombre del cliente junto al total de cada venta
SELECT c.nombre, v.total
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id;
```

---

## 🧩 3. Tipos de JOIN

### 🔍 INNER JOIN — solo coincidencias

Devuelve solo las filas que tienen coincidencia en **ambas** tablas. Es el más usado (`JOIN` a secas es un `INNER JOIN`).

```sql
SELECT c.nombre, v.id, v.total
FROM ventas v
INNER JOIN clientes c ON v.cliente_id = c.id;
```

👉 Clientes con al menos una venta. "Cliente Sin Compras" **no** aparece.

### ⬅️ LEFT JOIN — todo lo de la izquierda + coincidencias

Devuelve **todas** las filas de la tabla izquierda; si no hay coincidencia, las columnas de la derecha quedan en `NULL`.

```sql
SELECT c.nombre, v.id, v.total
FROM clientes c
LEFT JOIN ventas v ON v.cliente_id = c.id;
```

👉 Todos los clientes, incluso "Cliente Sin Compras" (con `id` y `total` en `NULL`).

Truco: filtrar los `NULL` para encontrar **lo que no tiene coincidencia**:

```sql
SELECT c.nombre
FROM clientes c
LEFT JOIN ventas v ON v.cliente_id = c.id
WHERE v.id IS NULL;
```

### ➡️ RIGHT JOIN — todo lo de la derecha + coincidencias

Igual que el LEFT JOIN pero conserva todas las filas de la tabla **derecha**.

```sql
SELECT c.nombre, v.id, v.total
FROM ventas v
RIGHT JOIN clientes c ON v.cliente_id = c.id;
```

👉 Mismo resultado que el LEFT JOIN anterior: solo cambió el orden de las tablas. En la práctica casi siempre se escribe como LEFT JOIN.

### 🔄 FULL OUTER JOIN — todo de ambas tablas

Devuelve todas las filas de ambas tablas; donde no hay coincidencia, `NULL`.

```sql
SELECT v.id AS venta_id, vp.producto_id, vp.cantidad
FROM ventas v
FULL OUTER JOIN venta_productos vp ON vp.venta_id = v.id
ORDER BY v.id;
```

👉 Incluye las ventas sin detalle (21–40) y, si existiera, detalle sin venta.

### ✖️ CROSS JOIN — todas las combinaciones

Une **cada** fila de una tabla con **todas** las de la otra. Sirve para generar combinaciones. ⚠️ Puede generar muchísimas filas.

```sql
SELECT c.nombre AS cliente, p.nombre AS producto
FROM clientes c
CROSS JOIN productos p;
```

👉 16 clientes × 20 productos = 320 filas.

### 🔁 SELF JOIN — una tabla consigo misma

Se usa en relaciones jerárquicas (ej.: empleado → jefe). La misma tabla se usa dos veces con alias distintos.

```sql
-- Solo ilustrativo: el minimercado no tiene tabla empleados
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleados e
JOIN empleados j ON e.jefe_id = j.id;
```

> Lo vamos a usar con la tabla `employees` de Northwind en la Clase 13.

---

## 🧩 4. Joins múltiples

Se pueden encadenar varios `JOIN`. Usar alias cortos mantiene la consulta legible.

```sql
SELECT c.nombre AS cliente, p.nombre AS producto, vp.cantidad, v.total
FROM ventas v
JOIN clientes c         ON v.cliente_id = c.id
JOIN venta_productos vp ON vp.venta_id = v.id
JOIN productos p        ON p.id = vp.producto_id;
```

👉 Cliente, producto, cantidad y total de cada línea de venta.

---

## 🧩 5. JOIN + `GROUP BY`

```sql
-- Total comprado por cliente
SELECT c.nombre AS cliente, SUM(v.total) AS total_compras
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
GROUP BY c.nombre
ORDER BY total_compras DESC;

-- Cantidad total vendida por producto
SELECT p.nombre AS producto, SUM(vp.cantidad) AS total_vendido
FROM venta_productos vp
JOIN productos p ON vp.producto_id = p.id
GROUP BY p.nombre
ORDER BY total_vendido DESC;

-- Promedio de venta por método de pago
SELECT mp.nombre AS metodo_pago, AVG(v.total) AS promedio_ventas
FROM ventas v
JOIN metodos_pago mp ON v.metodo_pago_id = mp.id
GROUP BY mp.nombre
ORDER BY promedio_ventas DESC;
```
