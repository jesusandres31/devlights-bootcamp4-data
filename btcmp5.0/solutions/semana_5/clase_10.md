# Semana 5 · Clase 10 · Solución — Relaciones con foreign keys

> 📝 **Consigna:** [Tarea Clase 10](../../tasks/semana_5/clase_10.md)

---

## 🧱 Parte 1 — Diagramas en dbdiagram.io

### 1️⃣ Uno a Uno (1:1)

```dbml
// Relación 1:1 — Cada conductor tiene un solo vehículo
// y cada vehículo está asignado a un solo conductor.

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
  conductor_id integer [unique, ref: - conductores.id] // unique asegura 1:1
}
```

### 2️⃣ Uno a Muchos (1:N)

```dbml
// Relación 1:N — Un profesor dicta muchas clases,
// cada clase pertenece a un solo profesor.

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

### 3️⃣ Muchos a Muchos (N:N)

```dbml
// Relación N:N — Un paciente puede tener muchas enfermedades y viceversa.
// La tabla intermedia conecta ambas y el índice único evita duplicados.

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

## 🧱 Parte 2 — PostgreSQL

### `CREATE TABLE`

```sql
-- 1:1
CREATE TABLE conductores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    licencia VARCHAR(20) NOT NULL UNIQUE,
    fecha_ingreso DATE DEFAULT CURRENT_DATE
);

CREATE TABLE vehiculos (
    id SERIAL PRIMARY KEY,
    patente VARCHAR(10) NOT NULL UNIQUE,
    modelo VARCHAR(50),
    conductor_id INTEGER UNIQUE REFERENCES conductores(id)  -- UNIQUE = 1:1
);

-- 1:N
CREATE TABLE profesores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50),
    fecha_contratacion DATE
);

CREATE TABLE clases (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    horario VARCHAR(50),
    profesor_id INTEGER NOT NULL REFERENCES profesores(id)
);

-- N:N
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE CHECK (fecha_nacimiento < CURRENT_DATE),
    telefono VARCHAR(20)
);

CREATE TABLE enfermedades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    nivel_gravedad VARCHAR(10) CHECK (nivel_gravedad IN ('leve', 'moderada', 'grave'))
);

CREATE TABLE pacientes_enfermedades (
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    enfermedad_id INTEGER NOT NULL REFERENCES enfermedades(id),
    fecha_diagnostico DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (paciente_id, enfermedad_id)  -- evita duplicados
);
```

### `INSERT`

```sql
INSERT INTO conductores (nombre, licencia, fecha_ingreso) VALUES
('Juan Pérez', 'LIC-001', '2022-03-01'),
('María Gómez', 'LIC-002', '2023-07-15');

INSERT INTO vehiculos (patente, modelo, conductor_id) VALUES
('AB123CD', 'Toyota Etios', 1),
('AC456EF', 'Fiat Cronos', 2);

INSERT INTO profesores (nombre, especialidad, fecha_contratacion) VALUES
('Laura Díaz', 'Matemática', '2020-02-10'),
('Pablo Ruiz', 'Historia', '2021-08-01');

INSERT INTO clases (nombre, horario, profesor_id) VALUES
('Álgebra', 'Lunes 18:00', 1),
('Geometría', 'Miércoles 18:00', 1),
('Historia Argentina', 'Martes 19:00', 2);

INSERT INTO pacientes (nombre, fecha_nacimiento, telefono) VALUES
('Ana Torres', '1990-05-12', '3794-111111'),
('Carlos Medina', '1985-11-30', '3794-222222');

INSERT INTO enfermedades (nombre, descripcion, nivel_gravedad) VALUES
('Gripe', 'Infección viral respiratoria', 'leve'),
('Diabetes tipo 2', 'Trastorno metabólico crónico', 'moderada'),
('Neumonía', 'Infección pulmonar', 'grave');

INSERT INTO pacientes_enfermedades (paciente_id, enfermedad_id, fecha_diagnostico) VALUES
(1, 1, '2024-06-01'),
(1, 2, '2023-02-15'),
(2, 1, '2024-07-10'),
(2, 3, '2024-08-20');
```

### ❌ Probar las constraints

```sql
-- Segundo vehículo para el conductor 1 → falla por el UNIQUE de conductor_id
INSERT INTO vehiculos (patente, modelo, conductor_id)
VALUES ('AD789GH', 'Ford Ka', 1);
-- ERROR: duplicate key value violates unique constraint "vehiculos_conductor_id_key"

-- Gravedad inválida → falla por el CHECK
INSERT INTO enfermedades (nombre, nivel_gravedad)
VALUES ('Resfrío', 'muy leve');
-- ERROR: new row for relation "enfermedades" violates check constraint "enfermedades_nivel_gravedad_check"

-- Diagnóstico repetido → falla por la PRIMARY KEY compuesta
INSERT INTO pacientes_enfermedades (paciente_id, enfermedad_id)
VALUES (1, 1);
-- ERROR: duplicate key value violates unique constraint "pacientes_enfermedades_pkey"
```
