# Semana 5 · Clase 9 — SQL básico: primeras consultas

> 🎯 **Objetivo:** conectarse a PostgreSQL (consola y pgAdmin), crear una tabla, cargar datos y hacer las primeras consultas: `SELECT`, `WHERE`, funciones agregadas y `GROUP BY`.
>
> 📝 **Tarea:** [Tarea Clase 9 — Crear tablas y consultar ventas](../../tasks/semana_5/clase_9.md)

---

## 🧩 1. Docker: consola `psql`

Conectarse a Postgres desde la terminal:

```bash
docker exec -it my_postgres_bootcamp psql -U myuser -d postgres
```

Comandos útiles de `psql`:

```
\l                 -- listar bases de datos
\c nombre_db       -- conectarse a una base
\dt                -- listar tablas
\q                 -- salir
```

---

## 🧩 2. pgAdmin: crear la base y la tabla

Crear una base `bootcamp`

```sql
CREATE DATABASE bootcamp;
```

Y, dentro, la tabla:

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC,
    hire_date DATE
);
```

Insertar algunos registros:

```sql
INSERT INTO employees (name, department, salary, hire_date) VALUES
('Ana', 'IT', 5000, '2021-03-15'),
('Carlos', 'HR', 4200, '2022-06-10'),
('Laura', 'IT', 5600, '2020-11-05'),
('Mateo', 'Finance', 4800, '2023-01-12'),
('Lucía', 'Finance', 4700, '2022-09-25'),
('Sofía', 'Marketing', 4500, '2021-08-03'),
('Diego', 'IT', 6000, '2019-12-17'),
('Valentina', 'HR', 4300, '2023-04-22'),
('Andrés', 'Finance', 5100, '2020-05-09'),
('Camila', 'Marketing', 4600, '2022-02-28'),
('Marcos', 'IT', 5500, '2021-07-19'),
('Isabella', 'HR', 4400, '2020-10-12'),
('Juliana', 'Finance', 4950, '2023-03-08'),
('Nicolás', 'Marketing', 4700, '2021-12-15'),
('Fernanda', 'IT', 5800, '2022-05-30'),
('Gabriel', 'IT', 6200, '2020-04-18'),
('Martina', 'HR', 4600, '2021-09-12'),
('Tomás', 'Finance', 5300, '2019-06-21'),
('Florencia', 'Marketing', 4900, '2022-07-14'),
('Pablo', 'IT', 5700, '2023-02-05'),
('Daniela', 'HR', 4500, '2020-12-03'),
('Ricardo', 'Finance', 5200, '2021-05-27'),
('Agustina', 'Marketing', 4800, '2023-06-19'),
('Federico', 'IT', 6100, '2018-11-22'),
('Carolina', 'HR', 4700, '2022-03-16'),
('Emiliano', 'Finance', 4900, '2020-08-11'),
('Micaela', 'Marketing', 5100, '2019-10-29'),
('Sebastián', 'IT', 5900, '2022-12-07'),
('Paula', 'HR', 4400, '2021-04-25'),
('Joaquín', 'Finance', 5500, '2023-05-13'),
('Natalia', 'Marketing', 4650, '2020-02-17'),
('Bruno', 'IT', 5400, '2021-11-08'),
('Victoria', 'HR', 4800, '2019-07-30'),
('Esteban', 'Finance', 5600, '2022-10-04'),
('Rocío', 'Marketing', 4950, '2023-08-21');
```

---

## 🧩 3. Primeras consultas: `SELECT`

Estructura general:

```sql
SELECT columnas
FROM tabla
[WHERE condición]
[ORDER BY columna]
[LIMIT número];
```

Ejemplos:

```sql
-- Ver toda la tabla
SELECT * FROM employees;

-- Ver solo nombre y salario
SELECT name, salary FROM employees;

-- Cambiar el alias de columna
SELECT name AS "Empleado", salary AS "Sueldo" FROM employees;

-- Ordenar por salario (mayor a menor) y quedarse con los 5 primeros
SELECT name, salary FROM employees ORDER BY salary DESC LIMIT 5;
```

---

## 🧩 4. Filtros y operadores: `WHERE`

- Comparación: `=`, `>`, `<`, `>=`, `<=`, `!=`
- Lógicos: `AND`, `OR`, `NOT`
- Otros: `IN`, `BETWEEN`, `LIKE`

```sql
-- Empleados del área IT
SELECT * FROM employees WHERE department = 'IT';

-- Salario mayor a 4800
SELECT * FROM employees WHERE salary > 4800;

-- Empleados contratados después de 2022
SELECT * FROM employees WHERE hire_date > '2022-01-01';

-- Empleados con salario entre 4500 y 5500
SELECT * FROM employees WHERE salary BETWEEN 4500 AND 5500;

-- Empleados de HR o Marketing
SELECT * FROM employees WHERE department IN ('HR', 'Marketing');

-- Nombre empieza con 'L'
SELECT * FROM employees WHERE name LIKE 'L%';
```

---

## 🧩 5. Funciones agregadas y `GROUP BY`

- `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY` agrupa filas; `HAVING` filtra **grupos** (`WHERE` filtra **filas**).

```sql
-- Cuántos empleados hay
SELECT COUNT(*) FROM employees;

-- Promedio salarial
SELECT AVG(salary) FROM employees;

-- Salario máximo por departamento
SELECT department, MAX(salary)
FROM employees
GROUP BY department;

-- Departamentos con salario promedio > 4500
SELECT department, AVG(salary)
FROM employees
GROUP BY department
HAVING AVG(salary) > 4500;
```

---

## 🧩 6. Modificar y borrar datos

```sql
-- Cambiar el salario de un empleado específico
UPDATE employees
SET salary = 6000
WHERE name = 'Laura';

-- Eliminar un empleado específico
DELETE FROM employees
WHERE id = 3;  -- Por ejemplo, Laura

-- Eliminar una tabla (si existe)
DROP TABLE IF EXISTS temp_table;

-- ⚠️ Eliminar TODOS los registros de la tabla (sin WHERE borra todo)
DELETE FROM employees;
```

> ⚠️ `UPDATE` y `DELETE` sin `WHERE` afectan a **todas** las filas.
