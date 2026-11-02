# Semana 4 · Clase 8 — Modelado de datos: relaciones

> 🎯 **Objetivo:** entender los tres tipos de relaciones entre tablas (1:1, 1:N y N:N) y dibujarlas en dbdiagram.io.
>
> 📝 **Tarea:** [Tarea Clase 8 — Docker + PostgreSQL + pgAdmin](../../tasks/semana_4/clase_8.md)

---

## 🧩 1. Tipos de relaciones en dbdiagram.io

Abrir [dbdiagram.io](https://dbdiagram.io), pegar el código y ver cómo se dibuja cada relación.

- **1:1** — una fila de A se relaciona con una sola fila de B (FK con `unique`).
- **1:N** — una fila de A se relaciona con muchas filas de B (FK en la tabla "muchos").
- **N:N** — muchas filas de A con muchas de B (necesita una **tabla intermedia**).

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
