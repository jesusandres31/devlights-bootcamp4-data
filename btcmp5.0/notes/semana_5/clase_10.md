# Semana 5 · Clase 10 — Constraints, normalización y relaciones

> 🎯 **Objetivo:** proteger los datos con constraints (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`), separar una tabla en dos (normalización) y unirlas con una **foreign key**. Repasar los tipos de relaciones.
>
> 📝 **Tarea:** [Tarea Clase 10 — Relaciones con foreign keys](../../tasks/semana_5/clase_10.md)

---

## 🧩 1. Constraints

### Ejemplo práctico

```sql
CREATE TABLE clients (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  birth_date DATE CHECK (birth_date < CURRENT_DATE),
  created_at DATE DEFAULT CURRENT_DATE
);
```

### ✅ Inserción válida

```sql
INSERT INTO clients (name, email, birth_date)
VALUES ('Ana', 'ana@example.com', '1990-05-12');
```

### ❌ Probar `NOT NULL`

Insertar un cliente sin nombre:

```sql
INSERT INTO clients (email, birth_date)
VALUES ('noname@example.com', '1985-01-01');
```

👉 **Error esperado:** `ERROR: null value in column "name" violates not-null constraint`

### ❌ Probar `UNIQUE`

Repetir un email existente:

```sql
INSERT INTO clients (name, email, birth_date)
VALUES ('Carlos', 'ana@example.com', '1992-07-15');
```

👉 **Error esperado:** `ERROR: duplicate key value violates unique constraint "clients_email_key"`

### ❌ Probar `CHECK`

Insertar un cliente con fecha de nacimiento futura:

```sql
INSERT INTO clients (name, email, birth_date)
VALUES ('Lucía', 'lucia@example.com', '2090-01-01');
```

👉 **Error esperado:** `ERROR: new row for relation "clients" violates check constraint "clients_birth_date_check"`

### 🧾 Verificar los datos válidos

```sql
SELECT * FROM clients;  -- solo está Ana, con created_at = hoy (DEFAULT)
```

💬 **Conclusión:** las constraints **protegen la base de datos** de errores humanos o de aplicaciones.

---

## 🧩 2. Normalización

### Punto de partida: la tabla de la Clase 9

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),   -- 'IT', 'HR', ... se repite en muchas filas
    salary NUMERIC,
    hire_date DATE
);
```

El nombre del departamento se repite en cada empleado: si cambia, hay que actualizar muchas filas.

### Separar en dos tablas

```sql
DROP TABLE IF EXISTS employees;

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary NUMERIC,
    hire_date DATE,
    department_id INTEGER REFERENCES departments(id)
);
```

### Alternativa: agregar la foreign key después

```sql
DROP TABLE employees;
DROP TABLE departments;

-- 1️⃣ Crear las tablas sin la constraint
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary NUMERIC,
    hire_date DATE,
    department_id INTEGER
);

-- 2️⃣ Agregar la foreign key constraint
ALTER TABLE employees
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id)
REFERENCES departments(id);
```

### Insertar datos coherentes

```sql
INSERT INTO departments (name) VALUES
('IT'),
('HR'),
('Finance'),
('Marketing');

INSERT INTO employees (name, salary, hire_date, department_id) VALUES
('Ana', 5000, '2021-03-15', 1),
('Carlos', 4200, '2022-06-10', 2),
('Laura', 6000, '2020-11-05', 1),
('Mateo', 4800, '2023-01-12', 3),
('Lucía', 4700, '2022-09-25', 3);
```

### ❌ Probar la foreign key

```sql
INSERT INTO employees (name, salary, hire_date, department_id)
VALUES ('Pedro', 4000, '2023-05-01', 99);
```

👉 **Error esperado:** `ERROR: insert or update on table "employees" violates foreign key constraint "fk_department"`

---

## 🧩 3. Repaso de relaciones (dbdiagram.io)

```dbml
//////////////////////////////////////////////////////////
// One-to-One (1:1)
//////////////////////////////////////////////////////////

// Each person has exactly one passport,
// and each passport belongs to exactly one person.

Table persons {
  id integer [pk]
  full_name varchar
}

Table passports {
  id integer [pk]
  passport_number varchar
  person_id integer [unique, ref: - persons.id] // unique ensures 1:1
}

//////////////////////////////////////////////////////////
// One-to-Many (1:N)
//////////////////////////////////////////////////////////

// One user can create many posts,
// but each post belongs to only one user.

Table users {
  id integer [pk]
  username varchar
}

Table posts {
  id integer [pk]
  title varchar
  content text
  user_id integer [not null, ref: > users.id]
}

//////////////////////////////////////////////////////////
// Many-to-Many (N:N)
//////////////////////////////////////////////////////////

// A student can enroll in many courses,
// and a course can have many students.
// We need a junction table to link them.

Table students {
  id integer [pk]
  name varchar
  email varchar
  created_at timestamp
}

Table courses {
  id integer [pk]
  title varchar
  description text
  created_at timestamp
}

Table student_courses {
  student_id integer [not null, ref: > students.id]
  course_id integer [not null, ref: > courses.id]
  enrollment_date timestamp

  indexes {
    (student_id, course_id) [unique] // composite key to avoid duplicates
  }
}
```

### Cómo se traduce cada relación a SQL

| Relación | En SQL                                                                 |
| -------- | ---------------------------------------------------------------------- |
| 1:1      | FK + `UNIQUE` (`person_id INTEGER UNIQUE REFERENCES persons(id)`)      |
| 1:N      | FK en la tabla "muchos" (`user_id INTEGER NOT NULL REFERENCES users(id)`) |
| N:N      | Tabla intermedia con dos FK + `PRIMARY KEY (a_id, b_id)`               |
