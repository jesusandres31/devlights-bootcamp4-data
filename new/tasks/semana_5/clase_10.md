# Semana 5 · Clase 10 · Tarea

## 🧩 Consigna — Base de datos de un minimercado

### 🎯 Objetivo

Crear una base de datos para un **negocio/minimercado** donde se puedan gestionar:

- Clientes
- Productos
- Proveedores
- Ventas y los productos vendidos por cada venta
- Control de stock
- Métodos de pago

La base debe permitir manejar **las relaciones entre las entidades**, aplicando **constraints** (`PK`, `FK`, `UNIQUE`, `CHECK`, `NOT NULL`, `DEFAULT`) y representar **los tres tipos de relaciones** (1:1, 1:N y N:N).

### 📝 Tablas sugeridas y relaciones

1. **Clientes** — 1:N con ventas (un cliente puede tener muchas ventas).
2. **Productos** — N:N con ventas (una venta puede tener varios productos, un producto puede estar en varias ventas).
3. **Proveedores** — 1:N con productos (un proveedor puede vender muchos productos).
4. **Ventas** — 1:N con clientes y N:N con productos a través de tabla intermedia.
5. **Otras** — stock, categorías, métodos de pago, etc.

### 💡 Actividad

- Crear el diagrama en **dbdiagram.io** y representar las relaciones.
- Crear la base en **PostgreSQL** con `CREATE TABLE` y constraints.
- Insertar algunos registros de ejemplo.
- Hacer un ejemplo de **transaction** donde se registre una venta, se actualice stock y se inserten los detalles de venta.

---

## 🧩 Solución

### 🧱 dbdiagram.io

```dbml
// Minimercado

Table clientes {
  id integer [pk]
  nombre varchar
  email varchar [unique]
  telefono varchar
}

Table proveedores {
  id integer [pk]
  nombre varchar
  telefono varchar
  direccion varchar
}

Table productos {
  id integer [pk]
  nombre varchar
  precio numeric
  stock integer
  proveedor_id integer [not null, ref: > proveedores.id] // 1:N
}

Table metodos_pago {
  id integer [pk]
  nombre varchar // Ej: Efectivo, Tarjeta, Transferencia
}

Table ventas {
  id integer [pk]
  cliente_id integer [not null, ref: > clientes.id] // 1:N
  metodo_pago_id integer [not null, ref: > metodos_pago.id] // FK obligatoria
  fecha timestamp [default: `current_timestamp`]
  total numeric
}

Table venta_productos {
  venta_id integer [not null, ref: > ventas.id]
  producto_id integer [not null, ref: > productos.id]
  cantidad integer [not null]
  precio_unitario numeric [not null]

  indexes {
    (venta_id, producto_id) [unique] // N:N composite
  }
}
```

### 🧱 PostgreSQL

```sql
-- Clientes
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20)
);

-- Proveedores
CREATE TABLE proveedores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(150)
);

-- Productos
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    proveedor_id INTEGER NOT NULL REFERENCES proveedores(id)
);

-- Métodos de pago
CREATE TABLE metodos_pago (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Ventas
CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    metodo_pago_id INTEGER NOT NULL REFERENCES metodos_pago(id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total NUMERIC(10,2)
);

-- Venta_Productos (N:N)
CREATE TABLE venta_productos (
    venta_id INTEGER NOT NULL REFERENCES ventas(id),
    producto_id INTEGER NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
    PRIMARY KEY (venta_id, producto_id)
);
```

### 🧱 Inserción de datos

```sql
-- Clientes
INSERT INTO clientes (nombre, email, telefono) VALUES
('Ana Perez','ana@example.com','1111-2222'),
('Carlos Lopez','carlos@example.com','3333-4444');

-- Proveedores
INSERT INTO proveedores (nombre, telefono, direccion) VALUES
('Proveedor 1','5555-6666','Calle Falsa 123'),
('Proveedor 2','7777-8888','Av Siempre Viva 456');

-- Productos
INSERT INTO productos (nombre, precio, stock, proveedor_id) VALUES
('Leche', 100, 50, 1),
('Pan', 50, 100, 1),
('Queso', 200, 30, 2);

-- Métodos de pago
INSERT INTO metodos_pago (nombre) VALUES
('Efectivo'),
('Tarjeta'),
('Transferencia');

-- Ventas con método de pago obligatorio
INSERT INTO ventas (cliente_id, metodo_pago_id, total) VALUES
(1, 1, 0), -- Ana, Efectivo
(2, 2, 0); -- Carlos, Tarjeta

-- Venta_Productos
INSERT INTO venta_productos (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 2, 100),
(1, 2, 5, 50);
```

### 🧱 Transaction de una venta

Se usa una CTE (`WITH ...`) para encadenar todos los pasos dentro de la misma transacción.

```sql
BEGIN;

-- 1️⃣ Crear la venta y capturar su id
WITH nueva_venta AS (
  INSERT INTO ventas (cliente_id, metodo_pago_id, total)
  VALUES (2, 2, 0)
  RETURNING id
),

-- 2️⃣ Insertar los productos de esa venta
productos_insertados AS (
  INSERT INTO venta_productos (venta_id, producto_id, cantidad, precio_unitario)
  SELECT id, 1, 1, 100 FROM nueva_venta
  UNION ALL
  SELECT id, 3, 2, 200 FROM nueva_venta
  RETURNING venta_id
),

-- 3️⃣ Actualizar el stock de los productos
stock_actualizado AS (
  UPDATE productos
  SET stock = stock - CASE id
    WHEN 1 THEN 1
    WHEN 3 THEN 2
    ELSE 0
  END
  WHERE id IN (1, 3)
  RETURNING 1
)

-- 4️⃣ Calcular y actualizar el total de la venta
UPDATE ventas
SET total = (
  SELECT SUM(cantidad * precio_unitario)
  FROM venta_productos
  WHERE venta_id = ventas.id
)
WHERE id IN (SELECT venta_id FROM productos_insertados);

COMMIT;
```
