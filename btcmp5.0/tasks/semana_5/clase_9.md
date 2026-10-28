# Semana 5 · Clase 9 · Tarea

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
