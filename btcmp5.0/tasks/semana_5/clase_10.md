# Semana 5 · Clase 10 · Tarea — Relaciones con foreign keys

> 📚 **Tema de la clase:** [Clase 10 — Constraints, normalización y relaciones](../../notes/semana_5/clase_10.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 11.

## 🎯 Objetivo

Crear **un ejemplo de cada tipo de relación** (1:1, 1:N y N:N), primero como diagrama en **dbdiagram.io** y después como tablas reales en **PostgreSQL** con sus constraints.

---

## 🧱 Parte 1 — Diagramas en dbdiagram.io

Para cada caso:

- Crear las tablas con las columnas indicadas.
- Definir la **foreign key** que corresponda.
- Agregar un **comentario (`//`)** explicando la relación.

### 1️⃣ Uno a Uno (1:1)

**Escenario:** cada **conductor** tiene un solo **vehículo** asignado, y cada vehículo está asignado a un solo conductor.

- **`conductores`:** `id` (PK), `nombre`, `licencia`, `fecha_ingreso`
- **`vehiculos`:** `id` (PK), `patente`, `modelo`, `conductor_id` (FK **única**, referencia `conductores.id`)

### 2️⃣ Uno a Muchos (1:N)

**Escenario:** un **profesor** puede dictar muchas **clases**, pero cada clase pertenece a un solo profesor.

- **`profesores`:** `id` (PK), `nombre`, `especialidad`, `fecha_contratacion`
- **`clases`:** `id` (PK), `nombre`, `horario`, `profesor_id` (FK **no nula**, referencia `profesores.id`)

### 3️⃣ Muchos a Muchos (N:N)

**Escenario:** un **paciente** puede tener varias **enfermedades**, y una enfermedad puede afectar a muchos pacientes.

- **`pacientes`:** `id` (PK), `nombre`, `fecha_nacimiento`, `telefono`
- **`enfermedades`:** `id` (PK), `nombre`, `descripcion`, `nivel_gravedad`
- **`pacientes_enfermedades`:** `paciente_id` (FK), `enfermedad_id` (FK), `fecha_diagnostico`
  - Índice único `(paciente_id, enfermedad_id)` para evitar duplicados.

---

## 🧱 Parte 2 — Pasarlo a PostgreSQL

En una base nueva (`relaciones_db`):

1. Escribir los `CREATE TABLE` de las 7 tablas con sus `PRIMARY KEY` y `REFERENCES`.
2. Agregar al menos estas constraints:
   - `NOT NULL` en los nombres.
   - `UNIQUE` en `licencia` y `patente`.
   - `CHECK` en `nivel_gravedad` para que solo acepte `'leve'`, `'moderada'` o `'grave'`.
3. Insertar 2–3 filas en cada tabla.
4. Probar que las constraints funcionan: intentar asignar **dos vehículos al mismo conductor** y anotar el error que devuelve Postgres.

## ✅ Entrega

- Link (o captura) de los 3 diagramas de dbdiagram.io.
- Archivo `.sql` con los `CREATE TABLE`, los `INSERT` y el `INSERT` que falla (comentado, con el error).
