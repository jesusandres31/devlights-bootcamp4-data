# Semana 5 · Clase 9

## 🧩 Constraints

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

### ❌ 1. Probar constraint `NOT NULL`

Intentar insertar un cliente sin nombre:

```sql
INSERT INTO clients (email, birth_date)
VALUES ('noname@example.com', '1985-01-01');
```

👉 **Error esperado:** `ERROR: null value in column "name" violates not-null constraint`

### ❌ 2. Probar constraint `UNIQUE`

Intentar repetir un email existente:

```sql
INSERT INTO clients (name, email, birth_date)
VALUES ('Carlos', 'ana@example.com', '1992-07-15');
```

👉 **Error esperado:** `ERROR: duplicate key value violates unique constraint "clients_email_key"`

### ❌ 3. Probar constraint `CHECK`

Insertar un cliente con fecha de nacimiento futura:

```sql
INSERT INTO clients (name, email, birth_date)
VALUES ('Lucía', 'lucia@example.com', '2090-01-01');
```

👉 **Error esperado:** `ERROR: new row for relation "clients" violates check constraint "clients_birth_date_check"`

### 🧾 Verificar los datos válidos insertados

```sql
SELECT * FROM clients;
```

💬 **Conclusión:** las constraints **protegen la base de datos** de errores humanos o de aplicaciones.

---

## 🧩 Normalización

### 🧱 Punto de partida: tabla actual

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC,
    hire_date DATE
);
```

### 🧱 Separar en tablas

```sql
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

### 🧱 Alternativa: agregar la foreign key después

Borrar las tablas anteriores:

```sql
DROP TABLE employees;
DROP TABLE departments;
```

Crearlas de nuevo y agregar la constraint con `ALTER TABLE`:

```sql
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

-- 2️⃣ Luego agregar la foreign key constraint
ALTER TABLE employees
ADD CONSTRAINT fk_department
FOREIGN KEY (department_id)
REFERENCES departments(id);
```

### 🧱 Insertar datos coherentes

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

---

## 🧩 Relaciones

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
  person_id integer [unique, ref: > persons.id] // ensures 1:1 relation
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

---

## 🧩 Mini tarea — Práctica de relaciones en bases de datos

### 🧱 Ejemplo 1 — Relación Uno a Uno (1:1)

**Escenario:** Cada **conductor** tiene un solo **vehículo** asignado.

**Tablas y columnas mínimas que deben crear:**

- **conductores:** `id`, `nombre`, `licencia`, `fecha_ingreso`
- **vehiculos:** `id`, `patente`, `modelo`, `conductor_id`

Agreguen un comentario explicando que cada conductor solo puede tener un vehículo y cada vehículo solo puede estar asignado a un conductor.

### 🧱 Ejemplo 2 — Relación Uno a Muchos (1:N)

**Escenario:** Un **profesor** puede dictar muchas **clases**, pero cada clase pertenece a un solo profesor.

**Tablas y columnas mínimas que deben crear:**

- **profesores:** `id`, `nombre`, `especialidad`, `fecha_contratacion`
- **clases:** `id`, `nombre`, `horario`, `profesor_id`

Agreguen un comentario indicando que un profesor puede tener varias clases y cada clase pertenece a un solo profesor.

### 🧱 Ejemplo 3 — Relación Muchos a Muchos (N:N)

**Escenario:** Un **paciente** puede tener varias **enfermedades**, y una enfermedad puede afectar a muchos pacientes.

**Tablas y columnas mínimas que deben crear:**

- **pacientes:** `id`, `nombre`, `fecha_nacimiento`, `telefono`
- **enfermedades:** `id`, `nombre`, `descripcion`, `nivel_gravedad`
- **pacientes_enfermedades:** `paciente_id`, `enfermedad_id`, `fecha_diagnostico`

Agreguen un comentario explicando que la tabla intermedia conecta pacientes con enfermedades y evita duplicados.

### 🎯 Objetivo

Crear **un ejemplo de cada tipo de relación** (1:1, 1:N y N:N) usando **dbdiagram.io**, con entidades diferentes a las vistas en clase.

Cada tabla debe tener:

- Al menos **3 columnas** (además del `id`).
- Comentarios (`//`) explicando la relación.

### ✅ Solución

#### Ejemplo 1 — Relación Uno a Uno (1:1)

👉 *Cada conductor tiene un solo vehículo asignado.*

```dbml
// Relación 1:1 — Un conductor tiene un solo vehículo.

Table conductores {
  id integer [pk]
  nombre varchar
  licencia varchar
  fecha_ingreso date
}

Table vehiculos {
  id integer [pk]
  patente varchar
  modelo varchar
  conductor_id integer [unique, ref: > conductores.id] // asegura 1:1
}
```

#### Ejemplo 2 — Relación Uno a Muchos (1:N)

👉 *Un profesor puede dictar muchas clases, pero cada clase pertenece a un solo profesor.*

```dbml
// Relación 1:N — Un profesor dicta muchas clases.

Table profesores {
  id integer [pk]
  nombre varchar
  especialidad varchar
  fecha_contratacion date
}

Table clases {
  id integer [pk]
  nombre varchar
  horario varchar
  profesor_id integer [not null, ref: > profesores.id]
}
```

#### Ejemplo 3 — Relación Muchos a Muchos (N:N)

👉 *Un paciente puede tener varias enfermedades, y una enfermedad puede afectar a muchos pacientes.*

```dbml
// Relación N:N — Un paciente puede tener muchas enfermedades, y viceversa.

Table pacientes {
  id integer [pk]
  nombre varchar
  fecha_nacimiento date
  telefono varchar
}

Table enfermedades {
  id integer [pk]
  nombre varchar
  descripcion text
  nivel_gravedad varchar
}

Table pacientes_enfermedades {
  paciente_id integer [not null, ref: > pacientes.id]
  enfermedad_id integer [not null, ref: > enfermedades.id]
  fecha_diagnostico date

  indexes {
    (paciente_id, enfermedad_id) [unique] // evita duplicados
  }
}
```

---

## 🧩 Mini tarea — Versión detallada

### 🎯 Objetivo

Crear **un ejemplo de cada tipo de relación** (1:1, 1:N y N:N) usando **dbdiagram.io**. El objetivo es que practiquen cómo identificar relaciones y definir **foreign keys** correctamente.

### 📝 Instrucciones

1. Para cada tipo de relación, **crea un diagrama en dbdiagram.io**.
2. Cada tabla debe tener las columnas indicadas abajo.
3. Agrega **comentarios (`//`)** explicando la relación y qué asegura la constraint.
4. Para la relación N:N, asegúrate de **usar un índice único** para evitar duplicados.

### 1️⃣ Uno a Uno (1:1)

**Descripción:** Cada conductor tiene un solo vehículo asignado.

**Tabla `conductores`**

- `id` (PK)
- `nombre`
- `licencia`
- `fecha_ingreso`

**Tabla `vehiculos`**

- `id` (PK)
- `patente`
- `modelo`
- `conductor_id` (FK único, referencia `conductores.id`)

### 2️⃣ Uno a Muchos (1:N)

**Descripción:** Un profesor dicta muchas clases, pero cada clase pertenece a un solo profesor.

**Tabla `profesores`**

- `id` (PK)
- `nombre`
- `especialidad`
- `fecha_contratacion`

**Tabla `clases`**

- `id` (PK)
- `nombre`
- `horario`
- `profesor_id` (FK no nulo, referencia `profesores.id`)

### 3️⃣ Muchos a Muchos (N:N)

**Descripción:** Un paciente puede tener varias enfermedades, y una enfermedad puede afectar a muchos pacientes.

**Tabla `pacientes`**

- `id` (PK)
- `nombre`
- `fecha_nacimiento`
- `telefono`

**Tabla `enfermedades`**

- `id` (PK)
- `nombre`
- `descripcion`
- `nivel_gravedad`

**Tabla `pacientes_enfermedades`**

- `paciente_id` (FK no nulo, referencia `pacientes.id`)
- `enfermedad_id` (FK no nulo, referencia `enfermedades.id`)
- `fecha_diagnostico`
- Índice único: `(paciente_id, enfermedad_id)`
