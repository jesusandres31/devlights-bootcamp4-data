# Semana 6 · Clase 11 · Solución — Diseñar una base de datos

> 📝 **Consigna:** [Tarea Clase 11](../../tasks/semana_6/clase_11.md)
>
> Se muestran los `CREATE TABLE` de los tres casos y los `INSERT` de la **Biblioteca** como referencia; los otros dos siguen el mismo patrón.

---

## 1️⃣ Biblioteca

### SQL

```sql
-- 1:N — Un autor escribe muchos libros
CREATE TABLE autores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

CREATE TABLE libros (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    anio_publicacion INTEGER CHECK (anio_publicacion > 0),
    autor_id INTEGER NOT NULL REFERENCES autores(id)
);

-- 1:1 — Cada socio tiene un solo carnet
CREATE TABLE socios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_alta DATE DEFAULT CURRENT_DATE
);

CREATE TABLE carnets (
    id SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    fecha_vencimiento DATE NOT NULL,
    socio_id INTEGER NOT NULL UNIQUE REFERENCES socios(id)  -- 1:1
);

-- 1:N — Un socio tiene muchos préstamos
CREATE TABLE prestamos (
    id SERIAL PRIMARY KEY,
    fecha_prestamo DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_devolucion DATE,
    socio_id INTEGER NOT NULL REFERENCES socios(id),
    CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo)
);

-- N:N — Un préstamo incluye varios libros y un libro está en varios préstamos
CREATE TABLE prestamo_libros (
    prestamo_id INTEGER NOT NULL REFERENCES prestamos(id),
    libro_id INTEGER NOT NULL REFERENCES libros(id),
    PRIMARY KEY (prestamo_id, libro_id)
);
```

**DER esperado:** `socios` — `carnets` (1:1), `autores` → `libros` (1:N), `socios` → `prestamos` (1:N), `prestamos` ↔ `libros` a través de `prestamo_libros` (N:N).

### Datos

```sql

INSERT INTO autores (nombre, nacionalidad) VALUES
('Jorge Luis Borges', 'Argentina'),
('Julio Cortázar', 'Argentina'),
('Gabriel García Márquez', 'Colombia');

INSERT INTO libros (titulo, isbn, anio_publicacion, autor_id) VALUES
('Ficciones', '978-0001', 1944, 1),
('El Aleph', '978-0002', 1949, 1),
('Rayuela', '978-0003', 1963, 2),
('Cien años de soledad', '978-0004', 1967, 3);

INSERT INTO socios (nombre, email) VALUES
('Ana Torres', 'ana@mail.com'),
('Luis Benítez', 'luis@mail.com'),
('Sofía Romero', 'sofia@mail.com');

INSERT INTO carnets (numero, fecha_vencimiento, socio_id) VALUES
('C-0001', '2027-12-31', 1),
('C-0002', '2027-12-31', 2),
('C-0003', '2027-12-31', 3);

INSERT INTO prestamos (fecha_prestamo, fecha_devolucion, socio_id) VALUES
('2025-10-01', '2025-10-15', 1),
('2025-10-05', NULL, 2),
('2025-10-10', NULL, 1);

INSERT INTO prestamo_libros (prestamo_id, libro_id) VALUES
(1, 1),
(1, 3),
(2, 4),
(3, 2);
```

---

## 2️⃣ Hospital

```sql
-- 1:1 — Cada médico tiene un solo consultorio
CREATE TABLE medicos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50),
    matricula VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE consultorios (
    id SERIAL PRIMARY KEY,
    numero VARCHAR(10) NOT NULL UNIQUE,
    piso INTEGER CHECK (piso >= 0),
    medico_id INTEGER UNIQUE REFERENCES medicos(id)  -- UNIQUE = 1:1
);

-- 1:N — Un paciente tiene muchas citas y un médico atiende muchas citas
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dni VARCHAR(15) NOT NULL UNIQUE,
    fecha_nacimiento DATE
);

CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(200),
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    medico_id INTEGER NOT NULL REFERENCES medicos(id)
);

-- N:N — Un paciente puede tener varias enfermedades y viceversa
CREATE TABLE enfermedades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nivel_gravedad VARCHAR(10) CHECK (nivel_gravedad IN ('leve', 'moderada', 'grave'))
);

CREATE TABLE paciente_enfermedad (
    paciente_id INTEGER NOT NULL REFERENCES pacientes(id),
    enfermedad_id INTEGER NOT NULL REFERENCES enfermedades(id),
    fecha_diagnostico DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (paciente_id, enfermedad_id)
);
```

**DER esperado:** `medicos` — `consultorios` (1:1), `pacientes` → `citas` ← `medicos` (1:N), `pacientes` ↔ `enfermedades` a través de `paciente_enfermedad` (N:N).

---

## 3️⃣ Veterinaria

```sql
-- 1:N — Un dueño tiene muchas mascotas
CREATE TABLE duenos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE mascotas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(10) CHECK (especie IN ('perro', 'gato', 'otro')),
    fecha_nacimiento DATE,
    dueno_id INTEGER NOT NULL REFERENCES duenos(id)
);

-- 1:1 — Cada mascota tiene una sola historia clínica
CREATE TABLE historias_clinicas (
    id SERIAL PRIMARY KEY,
    fecha_apertura DATE DEFAULT CURRENT_DATE,
    observaciones TEXT,
    mascota_id INTEGER NOT NULL UNIQUE REFERENCES mascotas(id)  -- UNIQUE = 1:1
);

-- 1:N — Una mascota tiene muchas citas
CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(200),
    mascota_id INTEGER NOT NULL REFERENCES mascotas(id)
);

-- N:N — Una cita incluye varios tratamientos y un tratamiento está en varias citas
CREATE TABLE tratamientos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    costo NUMERIC(10,2) CHECK (costo >= 0)
);

CREATE TABLE cita_tratamiento (
    cita_id INTEGER NOT NULL REFERENCES citas(id),
    tratamiento_id INTEGER NOT NULL REFERENCES tratamientos(id),
    PRIMARY KEY (cita_id, tratamiento_id)
);
```

**DER esperado:** `mascotas` — `historias_clinicas` (1:1), `duenos` → `mascotas` → `citas` (1:N), `citas` ↔ `tratamientos` a través de `cita_tratamiento` (N:N).
