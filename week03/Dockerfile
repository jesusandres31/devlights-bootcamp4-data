# Usar la imagen oficial de PostgreSQL 16
FROM postgres:16

# Variables de entorno para configurar PostgreSQL
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=bootcamp_db

# Exponer el puerto por defecto de PostgreSQL
EXPOSE 5432

# Crear un volumen para persistir los datos de PostgreSQL
VOLUME ["/var/lib/postgresql/data"]

# El comando por defecto ya está definido en la imagen base
# pero se puede personalizar si es necesario
# CMD ["postgres"]

