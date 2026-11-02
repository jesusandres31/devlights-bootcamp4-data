# Semana 6 · Clase 11 · Solución — Diseñar una base de datos

> 📝 **Consigna:** [Tarea Clase 11](../../tasks/semana_6/clase_11.md)
>
> Se muestra el diagrama de los tres casos y el SQL completo de la **Biblioteca** como referencia; los otros dos siguen exactamente el mismo patrón.

---

## 1️⃣ Biblioteca

### Diagrama

```dbml
Table autores {
  id integer [pk]
  nombre varchar
  nacionalidad varchar
}

Table libros {
  id integer [pk]
  titulo varchar
  isbn varchar [unique]
  anio_publicacion integer
  autor_id integer [not null, ref: > autores.id] // 1:N un autor escribe muchos libros
}

Table socios {
  id integer [pk]
  nombre varchar
  email varchar [unique]
  fecha_alta date
}

Table carnets {
  id integer [pk]
  numero varchar [unique]
  fecha_vencimiento date
  socio_id integer [unique, ref: - socios.id] // 1:1 un carnet por socio
}

Table prestamos {
  id integer [pk]
  fecha_prestamo date
  fecha_devolucion date
  socio_id integer [not null, ref: > socios.id] // 1:N un socio tiene muchos préstamos
}

Table prestamo_libros {
  prestamo_id integer [not null, ref: > prestamos.id]
  libro_id integer [not null, ref: > libros.id]

  indexes {
    (prestamo_id, libro_id) [pk] // N:N préstamos ↔ libros
  }
}
```

### SQL

```sql
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

CREATE TABLE prestamos (
    id SERIAL PRIMARY KEY,
    fecha_prestamo DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_devolucion DATE,
    socio_id INTEGER NOT NULL REFERENCES socios(id),
    CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo)
);

CREATE TABLE prestamo_libros (
    prestamo_id INTEGER NOT NULL REFERENCES prestamos(id),
    libro_id INTEGER NOT NULL REFERENCES libros(id),
    PRIMARY KEY (prestamo_id, libro_id)
);

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

```dbml
Table medicos {
  id integer [pk]
  nombre varchar
  especialidad varchar
  matricula varchar [unique]
}

Table consultorios {
  id integer [pk]
  numero varchar [unique]
  piso integer
  medico_id integer [unique, ref: - medicos.id] // 1:1 un consultorio por médico
}

Table pacientes {
  id integer [pk]
  nombre varchar
  dni varchar [unique]
  fecha_nacimiento date
}

Table citas {
  id integer [pk]
  fecha timestamp
  motivo varchar
  paciente_id integer [not null, ref: > pacientes.id] // 1:N un paciente tiene muchas citas
  medico_id integer [not null, ref: > medicos.id]     // 1:N un médico atiende muchas citas
}

Table enfermedades {
  id integer [pk]
  nombre varchar
  nivel_gravedad varchar
}

Table paciente_enfermedad {
  paciente_id integer [not null, ref: > pacientes.id]
  enfermedad_id integer [not null, ref: > enfermedades.id]
  fecha_diagnostico date

  indexes {
    (paciente_id, enfermedad_id) [pk] // N:N pacientes ↔ enfermedades
  }
}
```

> 💡 Constraints sugeridas: `CHECK (nivel_gravedad IN ('leve','moderada','grave'))`, `UNIQUE` en `dni` y `matricula`, `DEFAULT CURRENT_DATE` en `fecha_diagnostico`.

---

## 3️⃣ Veterinaria

```dbml
Table duenos {
  id integer [pk]
  nombre varchar
  telefono varchar
  email varchar [unique]
}

Table mascotas {
  id integer [pk]
  nombre varchar
  especie varchar
  fecha_nacimiento date
  dueno_id integer [not null, ref: > duenos.id] // 1:N un dueño tiene muchas mascotas
}

Table historias_clinicas {
  id integer [pk]
  fecha_apertura date
  observaciones text
  mascota_id integer [unique, ref: - mascotas.id] // 1:1 una historia por mascota
}

Table citas {
  id integer [pk]
  fecha timestamp
  motivo varchar
  mascota_id integer [not null, ref: > mascotas.id] // 1:N una mascota tiene muchas citas
}

Table tratamientos {
  id integer [pk]
  nombre varchar
  costo numeric
}

Table cita_tratamiento {
  cita_id integer [not null, ref: > citas.id]
  tratamiento_id integer [not null, ref: > tratamientos.id]

  indexes {
    (cita_id, tratamiento_id) [pk] // N:N citas ↔ tratamientos
  }
}
```

> 💡 Constraints sugeridas: `CHECK (especie IN ('perro','gato','otro'))`, `CHECK (costo >= 0)`, `DEFAULT CURRENT_DATE` en `fecha_apertura`.
