# Semana 7 · Clase 14 — OLTP vs OLAP: desnormalización y creación de data warehouse

> 🎯 **Objetivo:** entender la diferencia entre una base transaccional y una analítica (contenido teórico en las filminas) y dejar restaurada **Northwind**, la base sobre la que vamos a construir nuestro data warehouse.
>
> 📝 **Tarea:** [Tarea Clase 14 — Restaurar Northwind](../../tasks/semana_7/clase_14.md)

---

## 🧩 1. Teoría (filminas)

- OLTP vs OLAP
- Desnormalización
- Creación de un data warehouse

---

## 🧩 2. Práctica: restaurar Northwind con Docker

Vamos a cargar [`datasets/northwind.sql`](../../datasets/northwind.sql) en el Postgres que levantamos en la [Clase 8](../../tasks/semana_4/clase_8.md) (contenedor `my_postgres_bootcamp`).

Los pasos son los mismos en cualquier sistema:

1. Crear una base **vacía** llamada `northwind`.
2. Copiar el archivo `.sql` **adentro** del contenedor.
3. Ejecutar el archivo sobre la base nueva con `psql`.
4. Verificar que estén las tablas.

> 💡 Abrir la terminal **en la carpeta donde está `northwind.sql`** (o ajustar la ruta en el paso 2).

### 🪟 Windows (PowerShell)

```powershell
# 0. El contenedor tiene que estar corriendo
docker ps

# 1. Crear la base vacía
docker exec my_postgres_bootcamp createdb -U myuser northwind

# 2. Copiar el archivo al contenedor
docker cp .\northwind.sql my_postgres_bootcamp:/tmp/northwind.sql

# 3. Ejecutar el .sql sobre la base northwind (-q = sin mostrar cada INSERT)
docker exec my_postgres_bootcamp psql -U myuser -d northwind -q -f /tmp/northwind.sql

# 4. Verificar
docker exec my_postgres_bootcamp psql -U myuser -d northwind -c "\dt"
```

> ⚠️ En PowerShell **no funciona** el típico `psql ... < northwind.sql`: el operador `<` no existe. Por eso copiamos el archivo con `docker cp` y lo ejecutamos con `-f`.
>
> ⚠️ Si usás **Git Bash** en Windows, convierte `/tmp/...` en una ruta de Windows y `psql` no encuentra el archivo. Usá PowerShell, o ejecutá antes `export MSYS_NO_PATHCONV=1`.

### 🐧 Linux / macOS (bash)

```bash
# 0. El contenedor tiene que estar corriendo
docker ps

# 1. Crear la base vacía
docker exec my_postgres_bootcamp createdb -U myuser northwind

# 2. Copiar el archivo al contenedor
docker cp ./northwind.sql my_postgres_bootcamp:/tmp/northwind.sql

# 3. Ejecutar el .sql sobre la base northwind (-q = sin mostrar cada INSERT)
docker exec my_postgres_bootcamp psql -U myuser -d northwind -q -f /tmp/northwind.sql

# 4. Verificar
docker exec my_postgres_bootcamp psql -U myuser -d northwind -c "\dt"
```

En bash también se pueden juntar los pasos 2 y 3 mandando el archivo por la entrada estándar (`-i` + `<`):

```bash
docker exec -i my_postgres_bootcamp psql -U myuser -d northwind -q < northwind.sql
```

> 💡 En Linux, si aparece `permission denied` al usar Docker, anteponer `sudo` a cada comando.

### ✅ Verificación

Desde la terminal o desde pgAdmin (Query Tool sobre `northwind`):

```sql
SELECT
    (SELECT COUNT(*) FROM customers)     AS customers,
    (SELECT COUNT(*) FROM orders)        AS orders,
    (SELECT COUNT(*) FROM order_details) AS order_details,
    (SELECT COUNT(*) FROM products)      AS products,
    (SELECT COUNT(*) FROM employees)     AS employees;
```

Resultado esperado:

| customers | orders | order_details | products | employees |
| --------- | ------ | ------------- | -------- | --------- |
| 91        | 830    | 2155          | 77       | 9         |

### 🔁 Empezar de cero

Si algo salió mal, borrar la base y repetir desde el paso 1 (igual en PowerShell y bash):

```bash
docker exec my_postgres_bootcamp dropdb -U myuser northwind
```

> 💡 **Alternativa sin terminal:** en pgAdmin, crear la base `northwind`, abrir el **Query Tool** sobre ella, abrir el archivo `northwind.sql` (ícono de carpeta) y ejecutarlo con ▶️.
