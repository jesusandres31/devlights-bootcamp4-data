# Semana 6 · Clase 11 · Tarea — Diseñar una base de datos

> 📚 **Tema de la clase:** [Clase 11 — Diseño de una base completa: minimercado](../../notes/semana_6/clase_11.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 12.

## 🎯 Objetivo

Repetir lo que hicimos con el minimercado, pero con otro negocio: crear las tablas con constraints en PostgreSQL, verificar el DER en pgAdmin y cargar datos.

**Elegir UNO** de los tres casos.

---

## 1️⃣ Biblioteca

- **Tablas:** `autores`, `libros`, `socios`, `carnets`, `prestamos`, `prestamo_libros`.
- **Relaciones:**
  - Cada socio tiene un solo carnet y cada carnet es de un solo socio (**1:1** `socios` ↔ `carnets`).
  - Un autor escribe muchos libros; cada libro tiene un solo autor (**1:N** `autores` → `libros`).
  - Un socio puede tener muchos préstamos (**1:N** `socios` → `prestamos`).
  - Un préstamo puede incluir varios libros y un libro puede estar en varios préstamos (**N:N** mediante `prestamo_libros`).

## 2️⃣ Hospital

- **Tablas:** `medicos`, `consultorios`, `pacientes`, `citas`, `enfermedades`, `paciente_enfermedad`.
- **Relaciones:**
  - Cada médico tiene un solo consultorio asignado (**1:1** `medicos` ↔ `consultorios`).
  - Un paciente puede tener muchas citas (**1:N** `pacientes` → `citas`).
  - Un médico puede atender muchas citas (**1:N** `medicos` → `citas`).
  - Un paciente puede tener varias enfermedades y una enfermedad puede afectar a muchos pacientes (**N:N** mediante `paciente_enfermedad`).

## 3️⃣ Veterinaria

- **Tablas:** `duenos`, `mascotas`, `historias_clinicas`, `citas`, `tratamientos`, `cita_tratamiento`.
- **Relaciones:**
  - Cada mascota tiene una sola historia clínica (**1:1** `mascotas` ↔ `historias_clinicas`).
  - Un dueño puede tener varias mascotas (**1:N** `duenos` → `mascotas`).
  - Cada cita es de una mascota (**1:N** `mascotas` → `citas`).
  - Una cita puede incluir varios tratamientos y un tratamiento puede estar en varias citas (**N:N** mediante `cita_tratamiento`).

---

## 📝 Pasos

1. `CREATE TABLE` en **PostgreSQL** con PKs, FKs y un comentario (`--`) en cada relación, usando al menos una vez cada constraint: `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`.
2. Generar el **DER** en pgAdmin (clic derecho sobre la base → **ERD For Database**) y verificar que se vean las relaciones 1:1, 1:N y N:N.
3. Insertar al menos 3 filas por tabla.

## ✅ Entrega

- Captura del DER de pgAdmin.
- Archivo `.sql` con los `CREATE TABLE` y los `INSERT`.
