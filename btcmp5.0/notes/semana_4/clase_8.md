# Semana 4 · Clase 8

## 🧩 dbdiagram.io

```dbml
//// 1:1 — One-to-One

Table users {
  id integer [primary key]
  name varchar
}

Table user_profiles {
  id integer [primary key]
  user_id integer [unique, ref: - users.id]
  bio text
}

//// 1:N — One-to-Many

Table customers {
  id integer [primary key]
  name varchar
}

Table orders {
  id integer [primary key]
  customer_id integer [not null, ref: > customers.id]
  total decimal
}

//// N:N — Many-to-Many

Table students {
  id integer [primary key]
  name varchar
}

Table courses {
  id integer [primary key]
  name varchar
}

Table student_courses {
  student_id integer [not null, ref: > students.id]
  course_id integer [not null, ref: > courses.id]

  indexes {
    (student_id, course_id) [pk]
  }
}
```

---

## 🧩 Docker: consola

Conectarse a Postgres desde la terminal:

```bash
docker exec -it my_postgres_bootcamp psql -U myuser -d postgres
```

Comandos útiles de `psql`:

```
\l                 -- listar bases de datos
\c nombre_db       -- conectarse a una base
\dt                -- listar tablas
CREATE TABLE ...   -- crear una tabla
```

---

## 🧩 pgAdmin

### 💬 1. Repaso + conexión a la DB

Crear una base `bootcamp`.

Crear la tabla:

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
('Fernanda', 'IT', 5800, '2022-05-30');
```

### 🧠 2. Primeras consultas SQL

Estructura general:

```sql
SELECT columnas
FROM tabla
[WHERE condición]
[ORDER BY columna]
[LIMIT número];
```

Ejemplos básicos:

```sql
-- Ver toda la tabla
SELECT * FROM employees;

-- Ver solo nombre y salario
SELECT name, salary FROM employees;

-- Cambiar el alias de columna
SELECT name AS "Empleado", salary AS "Sueldo" FROM employees;

-- Cambiar el salario de un empleado específico
UPDATE employees
SET salary = 6000
WHERE name = 'Laura';

-- Eliminar una tabla temporal de ejemplo
DROP TABLE IF EXISTS temp_table;

-- Eliminar un empleado específico
DELETE FROM employees
WHERE id = 3;  -- Por ejemplo, Laura

-- Eliminar todos los registros de la tabla (¡peligroso!)
DELETE FROM employees;
```

### ⚙️ 3. Filtros y operadores

Operadores básicos de `WHERE`:

- Comparación: `=`, `>`, `<`, `>=`, `<=`, `!=`
- Lógicos: `AND`, `OR`, `NOT`
- Otros: `IN`, `BETWEEN`, `LIKE`

Ejemplos:

```sql
-- Empleados del área IT
SELECT * FROM employees WHERE department = 'IT';

-- Salario mayor a 4800
SELECT * FROM employees WHERE salary > 4800;

-- Empleados contratados después de 2022
SELECT * FROM employees WHERE hire_date > '2022-01-01';

-- Empleados con salario entre 4500 y 5500
SELECT * FROM employees WHERE salary BETWEEN 4500 AND 5500;

-- Nombre empieza con 'L'
SELECT * FROM employees WHERE name LIKE 'L%';
```

### 📊 4. Funciones agregadas y agrupamientos

- `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- `GROUP BY` y `HAVING`

Ejemplos:

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
