# Semana 4 · Clase 8 · Tarea — Docker + PostgreSQL + pgAdmin

> 📚 **Tema de la clase:** [Clase 8 — Modelado de datos: relaciones](../../notes/semana_4/clase_8.md)
>
> 📅 **Entrega:** traer el entorno funcionando para la Clase 9 (la usamos para las primeras consultas SQL).

## 🎯 Objetivo

Dejar instalado el entorno con el que vamos a trabajar todo el módulo de SQL: un **PostgreSQL** corriendo en Docker y **pgAdmin** para administrarlo desde el navegador.

## 📝 Pasos

### 1️⃣ Instalar Docker 🐳

Instalar [Docker Desktop](https://www.docker.com/products/docker-desktop/) y verificar desde la terminal:

```bash
docker --version
docker compose version
```

### 2️⃣ Levantar PostgreSQL 🐘 + pgAdmin

Crear una carpeta para el bootcamp y, dentro, un archivo `docker-compose.yml`:

```yaml
services:
  postgres-db:
    image: postgres:16
    container_name: my_postgres_bootcamp
    restart: unless-stopped
    environment:
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: postgres
    ports:
      - "5433:5432"
    volumes:
      - ./pgdata:/var/lib/postgresql/data

  pg_admin:
    image: dpage/pgadmin4:latest
    container_name: my_pgadmin_bootcamp
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: adminpassword
    ports:
      - "8080:80"
```

Levantar los contenedores:

```bash
docker compose up -d
docker ps   # deberían aparecer my_postgres_bootcamp y my_pgadmin_bootcamp
```

### 3️⃣ Conectar pgAdmin a la base

1. Entrar a <http://localhost:8080> con `admin@example.com` / `adminpassword`.
2. **Register → Server** con estos datos:

| Campo    | Valor         |
| -------- | ------------- |
| Host     | `postgres-db` |
| Port     | `5432`        |
| Username | `myuser`      |
| Password | `mypassword`  |

> 💡 pgAdmin corre dentro de Docker, por eso usa el nombre del servicio (`postgres-db`) y el puerto interno `5432`. Desde una herramienta instalada en tu máquina (DBeaver, VS Code, etc.) se usa `localhost` y el puerto `5433`.

## ✅ Entrega

Captura de pantalla de pgAdmin conectado al servidor, mostrando la base `postgres`.
