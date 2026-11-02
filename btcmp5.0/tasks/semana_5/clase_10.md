# Semana 5 · Clase 10 · Tarea — Relaciones con foreign keys

> 📚 **Tema de la clase:** [Clase 10 — Constraints, normalización y relaciones](../../notes/semana_5/clase_10.md)
>
> 📅 **Entrega:** traer resuelto para la Clase 11.

## 🎯 Objetivo

Crear **un ejemplo de cada tipo de relación** (1:1, 1:N y N:N) como tablas reales en **PostgreSQL**, con sus foreign keys y constraints, y verificar el resultado con el **DER de pgAdmin**.

Trabajar en una base nueva llamada `relaciones_db`.

---

## 🧱 Tablas a crear

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
  - Clave primaria compuesta `(paciente_id, enfermedad_id)` para evitar duplicados.

---

## 📝 Pasos

1. Escribir los `CREATE TABLE` de las 7 tablas con sus `PRIMARY KEY` y `REFERENCES`, con un comentario (`--`) arriba de cada par explicando la relación.
2. Agregar al menos estas constraints:
   - `NOT NULL` en los nombres.
   - `UNIQUE` en `licencia` y `patente`.
   - `CHECK` en `nivel_gravedad` para que solo acepte `'leve'`, `'moderada'` o `'grave'`.
3. Generar el **DER** en pgAdmin (clic derecho sobre `relaciones_db` → **ERD For Database**) y verificar que se vean las tres relaciones.
4. Insertar 2–3 filas en cada tabla.
5. Probar que las constraints funcionan: intentar asignar **dos vehículos al mismo conductor** y anotar el error que devuelve Postgres.

## ✅ Entrega

- Captura del DER de pgAdmin.
- Archivo `.sql` con los `CREATE TABLE`, los `INSERT` y el `INSERT` que falla (comentado, con el error).
