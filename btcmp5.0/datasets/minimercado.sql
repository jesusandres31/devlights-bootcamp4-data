-- =====================================================================
-- Dataset: Minimercado
-- Uso: crear la base `minimercado`, abrir el Query Tool y ejecutar todo.
-- Borra las tablas si ya existen (por ejemplo, las creadas en la Clase 11).
-- =====================================================================

DROP TABLE IF EXISTS venta_productos, ventas, metodos_pago, productos, proveedores, clientes;

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

-- Insert into clientes (Clients)
INSERT INTO clientes (nombre, email, telefono) VALUES
('Juan Pérez', 'juan.perez@email.com', '555-0101'),
('María González', 'maria.gonzalez@email.com', '555-0102'),
('Carlos López', 'carlos.lopez@email.com', '555-0103'),
('Ana Martínez', 'ana.martinez@email.com', '555-0104'),
('Luis Rodríguez', 'luis.rodriguez@email.com', '555-0105'),
('Sofía Fernández', 'sofia.fernandez@email.com', '555-0106'),
('Diego García', 'diego.garcia@email.com', '555-0107'),
('Laura Sánchez', 'laura.sanchez@email.com', '555-0108'),
('Pedro Gómez', 'pedro.gomez@email.com', '555-0109'),
('Elena Torres', 'elena.torres@email.com', '555-0110'),
('Miguel Díaz', 'miguel.diaz@email.com', '555-0111'),
('Carmen Ruiz', 'carmen.ruiz@email.com', '555-0112'),
('Jorge Morales', 'jorge.morales@email.com', '555-0113'),
('Lucía Vargas', 'lucia.vargas@email.com', '555-0114'),
('Andrés Castro', 'andres.castro@email.com', '555-0115');

-- Insert into proveedores (Suppliers)
INSERT INTO proveedores (nombre, telefono, direccion) VALUES
('Distribuidora Norte', '555-0201', 'Calle Principal 123, Ciudad A'),
('Suministros Sur', '555-0202', 'Avenida Central 456, Ciudad B'),
('Comercial Este', '555-0203', 'Calle Secundaria 789, Ciudad C'),
('Proveedora Oeste', '555-0204', 'Boulevard 101, Ciudad D'),
('Importaciones Globales', '555-0205', 'Calle Comercio 202, Ciudad E'),
('Distribuidora Central', '555-0206', 'Avenida Norte 303, Ciudad F'),
('Suministros Rápidos', '555-0207', 'Calle Sur 404, Ciudad G');

-- Insert into productos (Products)
INSERT INTO productos (nombre, precio, stock, proveedor_id) VALUES
('Leche Entera 1L', 1.50, 100, 1), -- Distribuidora Norte
('Pan de Molde', 2.00, 80, 2), -- Suministros Sur
('Arroz 1kg', 1.20, 150, 3), -- Comercial Este
('Aceite de Girasol 1L', 2.50, 60, 1), -- Distribuidora Norte
('Pasta Spaghetti 500g', 1.00, 200, 4), -- Proveedora Oeste
('Azúcar 1kg', 1.10, 120, 3), -- Comercial Este
('Café Instantáneo 200g', 3.50, 50, 2), -- Suministros Sur
('Galletas de Chocolate 200g', 1.80, 90, 5),-- Importaciones Globales
('Jabón Líquido 500ml', 2.20, 70, 6), -- Distribuidora Central
('Detergente en Polvo 1kg', 3.00, 40, 6), -- Distribuidora Central
('Cerveza Lata 350ml', 1.50, 100, 7), -- Suministros Rápidos
('Agua Mineral 2L', 0.80, 150, 1), -- Distribuidora Norte
('Yogur Natural 1L', 2.00, 60, 2), -- Suministros Sur
('Queso Fresco 500g', 4.00, 30, 3), -- Comercial Este
('Mantequilla 250g', 2.50, 50, 1), -- Distribuidora Norte
('Harina de Trigo 1kg', 1.00, 100, 4), -- Proveedora Oeste
('Salsa de Tomate 500g', 1.30, 80, 5), -- Importaciones Globales
('Atún en Lata 170g', 1.60, 90, 7), -- Suministros Rápidos
('Papel Higiénico 4u', 2.00, 70, 6), -- Distribuidora Central
('Jugo de Naranja 1L', 1.70, 60, 2); -- Suministros Sur

-- Insert into metodos_pago (Payment Methods)
INSERT INTO metodos_pago (nombre) VALUES
('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('Efectivo'),
('Transferencia Bancaria'),
('PayPal');

-- Insert into ventas (Sales)
INSERT INTO ventas (cliente_id, metodo_pago_id, fecha, total) VALUES
(1, 1, '2025-11-09 09:00:00', 7.80),
(3, 2, '2025-11-09 11:15:00', 4.50),
(5, 3, '2025-11-10 14:30:00', 10.30),
(7, 4, '2025-11-10 16:45:00', 3.60),
(9, 5, '2025-11-11 10:00:00', 8.50),
(11, 1, '2025-11-11 12:20:00', 5.40),
(13, 2, '2025-11-12 15:10:00', 12.00),
(15, 3, '2025-11-12 08:30:00', 2.80),
(2, 4, '2025-11-13 13:50:00', 6.70),
(4, 5, '2025-11-13 17:00:00', 9.10),
(6, 1, '2025-11-14 09:25:00', 4.20),
(8, 2, '2025-11-14 11:40:00', 7.50),
(10, 3, '2025-11-15 14:55:00', 5.00),
(12, 4, '2025-11-15 10:10:00', 11.60),
(14, 5, '2025-11-16 12:25:00', 3.30),
(1, 1, '2025-11-16 15:40:00', 8.90),
(5, 3, '2025-11-17 11:00:00', 4.80),
(7, 4, '2025-11-18 14:15:00', 9.50),
(9, 5, '2025-11-18 16:30:00', 7.20),
(2, 1, '2025-11-19 09:00:00', 6.10),
(4, 2, '2025-11-19 11:30:00', 4.80),
(6, 3, '2025-11-20 14:00:00', 8.90),
(8, 4, '2025-11-20 16:15:00', 3.40),
(10, 5, '2025-11-21 10:30:00', 7.50),
(12, 1, '2025-11-21 12:45:00', 5.60),
(14, 2, '2025-11-22 15:00:00', 9.20),
(1, 3, '2025-11-22 08:20:00', 2.60),
(3, 4, '2025-11-23 13:40:00', 6.30),
(5, 5, '2025-11-23 17:10:00', 10.50),
(7, 1, '2025-11-24 09:25:00', 4.90),
(9, 2, '2025-11-24 11:50:00', 7.80),
(11, 3, '2025-11-25 14:05:00', 5.10),
(13, 4, '2025-11-25 10:15:00', 8.40),
(15, 5, '2025-11-26 12:30:00', 3.70),
(2, 1, '2025-11-26 15:45:00', 6.80),
(4, 2, '2025-11-27 08:55:00', 4.00),
(6, 3, '2025-11-27 11:10:00', 9.60),
(8, 4, '2025-11-28 14:25:00', 5.50),
(10, 5, '2025-11-28 16:40:00', 7.00);

-- Insert into venta_productos (Sale items)
INSERT INTO venta_productos (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 2, 1.50),
(1, 8, 2, 1.80),
(1, 12, 1, 0.80),
(2, 11, 3, 1.50),
(3, 14, 1, 4.00),
(3, 3, 2, 1.20),
(3, 17, 2, 1.30),
(4, 6, 2, 1.10),
(4, 12, 2, 0.80),
(5, 13, 2, 2.00),
(5, 7, 1, 3.50),
(6, 9, 1, 2.20),
(6, 18, 2, 1.60),
(7, 15, 2, 2.50),
(7, 4, 2, 2.50),
(8, 12, 1, 0.80),
(8, 19, 1, 2.00),
(9, 20, 2, 1.70),
(9, 8, 1, 1.80),
(10, 10, 1, 3.00),
(10, 1, 2, 1.50),
(11, 5, 2, 1.00),
(11, 17, 1, 1.30),
(12, 11, 2, 1.50),
(12, 7, 1, 3.50),
(13, 16, 3, 1.00),
(13, 6, 1, 1.10),
(14, 14, 1, 4.00),
(14, 3, 2, 1.20),
(14, 12, 2, 0.80),
(15, 18, 1, 1.60),
(15, 5, 1, 1.00),
(16, 1, 2, 1.50),
(16, 8, 2, 1.80),
(17, 2, 1, 2.00),
(17, 13, 2, 2.00),
(18, 11, 2, 1.50),
(18, 12, 2, 0.80),
(19, 4, 1, 2.50),
(19, 7, 1, 3.50),
(19, 15, 1, 2.50),
(20, 9, 1, 2.20),
(20, 19, 2, 2.00);
