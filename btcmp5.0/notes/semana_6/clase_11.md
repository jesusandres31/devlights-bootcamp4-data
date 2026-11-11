# Semana 6 · Clase 11 — Diseño de una base de datos transaccional

> 🎯 **Objetivo:** diseñar una base real de punta a punta: `CREATE TABLE` con constraints → DER en pgAdmin → datos de ejemplo → una **transacción** que registra una venta.
>
> 📝 **Tarea:** [Tarea Clase 11 — Diseñar una base de datos transaccional](../../tasks/semana_6/clase_11.md)

---

## 🧩 1. Consigna — Base de datos de un minimercado

Crear una base de datos para un **minimercado** donde se puedan gestionar:

- Clientes
- Productos y su stock
- Proveedores
- Ventas y los productos vendidos en cada venta
- Métodos de pago

La base debe aplicar **constraints** (`PK`, `FK`, `UNIQUE`, `CHECK`, `NOT NULL`, `DEFAULT`) y representar las relaciones entre entidades.

### Tablas sugeridas y relaciones

1. **Clientes** — 1:N con ventas (un cliente puede tener muchas ventas).
2. **Proveedores** — 1:N con productos (un proveedor puede vender muchos productos).
3. **Métodos de pago** — 1:N con ventas.
4. **Ventas** — N:N con productos a través de una tabla intermedia (`venta_productos`).

### Actividad

1. Crear la base `minimercado` en **PostgreSQL** con `CREATE TABLE` y constraints.
2. Verificar el diseño con el **DER de pgAdmin**.
3. Insertar algunos registros de ejemplo.
4. Registrar una venta con una **transacción**: crear la venta, insertar el detalle y actualizar el stock.

---

## 🧩 2. Tablas en PostgreSQL

```sql
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20)
);

CREATE TABLE proveedores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(150)
);

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    proveedor_id INTEGER NOT NULL REFERENCES proveedores(id)
);

CREATE TABLE metodos_pago (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id),
    metodo_pago_id INTEGER NOT NULL REFERENCES metodos_pago(id),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total NUMERIC(10,2)
);

-- Tabla intermedia N:N
CREATE TABLE venta_productos (
    venta_id INTEGER NOT NULL REFERENCES ventas(id),
    producto_id INTEGER NOT NULL REFERENCES productos(id),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
    PRIMARY KEY (venta_id, producto_id)
);
```

### Ver el DER

Clic derecho sobre la base `minimercado` → **ERD For Database**. Revisar que aparezcan:

- `clientes` → `ventas` (1:N)
- `metodos_pago` → `ventas` (1:N)
- `proveedores` → `productos` (1:N)
- `ventas` ↔ `productos` a través de `venta_productos` (N:N)

---

## 🧩 3. Datos de ejemplo

```sql
INSERT INTO clientes (nombre, email, telefono) VALUES
('Ana Perez', 'ana@example.com', '1111-2222'),
('Carlos Lopez', 'carlos@example.com', '3333-4444');

INSERT INTO proveedores (nombre, telefono, direccion) VALUES
('Proveedor 1', '5555-6666', 'Calle Falsa 123'),
('Proveedor 2', '7777-8888', 'Av Siempre Viva 456');

INSERT INTO productos (nombre, precio, stock, proveedor_id) VALUES
('Leche', 100, 50, 1),
('Pan', 50, 100, 1),
('Queso', 200, 30, 2);

INSERT INTO metodos_pago (nombre) VALUES
('Efectivo'),
('Tarjeta'),
('Transferencia');

INSERT INTO ventas (cliente_id, metodo_pago_id, total) VALUES
(1, 1, 450),  -- Ana, Efectivo (2 Leches + 5 Panes)
(2, 2, 0);    -- Carlos, Tarjeta (sin productos todavía)

INSERT INTO venta_productos (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 2, 100),
(1, 2, 5, 50);
```

---

## 🧩 4. Transacción: registrar una venta

Una venta toca **3 tablas**. Si algún paso falla, no queremos que quede la venta a medias: por eso va dentro de `BEGIN` / `COMMIT`.

```sql
BEGIN;

-- 1️⃣ Crear la venta (Carlos, Tarjeta)
INSERT INTO ventas (cliente_id, metodo_pago_id, total)
VALUES (2, 2, 0);

-- 2️⃣ Insertar los productos de esa venta
--    currval() devuelve el último id generado para ventas en esta sesión
INSERT INTO venta_productos (venta_id, producto_id, cantidad, precio_unitario) VALUES
(currval('ventas_id_seq'), 1, 1, 100),   -- 1 Leche
(currval('ventas_id_seq'), 3, 2, 200);   -- 2 Quesos

-- 3️⃣ Descontar stock
UPDATE productos SET stock = stock - 1 WHERE id = 1;
UPDATE productos SET stock = stock - 2 WHERE id = 3;

-- 4️⃣ Calcular el total de la venta
UPDATE ventas
SET total = (
    SELECT SUM(cantidad * precio_unitario)
    FROM venta_productos
    WHERE venta_id = ventas.id
)
WHERE id = currval('ventas_id_seq');

COMMIT;
```

Verificar:

```sql
SELECT * FROM ventas;
SELECT * FROM productos;
```

### ❌ `ROLLBACK`: cuando algo sale mal

Intentar vender más Queso del que hay en stock:

```sql
BEGIN;

INSERT INTO ventas (cliente_id, metodo_pago_id, total) VALUES (1, 1, 0);
UPDATE productos SET stock = stock - 1000 WHERE id = 3;
-- ERROR: new row for relation "productos" violates check constraint "productos_stock_check"

ROLLBACK;
```

👉 La venta del primer `INSERT` **no queda guardada**: la transacción se deshace completa.

---

## 🧩 5. Práctica grupal en clase — Cine 🎬

Diseñar en grupo una base de datos para un **cine** que permita registrar:

- Las películas que se proyectan.
- Las funciones (día y hora en que se proyectan).
- Las salas del cine.
- Los clientes y las entradas vendidas.

### Requisitos

- Representar las **relaciones entre entidades** (1:N y al menos una N:N).
- Usar **constraints**: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`.
- Escribir las sentencias `CREATE TABLE` en PostgreSQL y mostrar el **DER de pgAdmin**.

### 💡 Pistas

- Una **sala** tiene **muchas funciones** (1:N).
- Una **película** tiene **muchas funciones** (1:N).
- Un **cliente** compra **muchas entradas** y una **función** tiene **muchos clientes** (N:N mediante la tabla `entradas`).

### ⚡ Desafío extra

Agregar una tabla opcional: `empleados`, `categorias` de películas o `formas_de_pago`.
