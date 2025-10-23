CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC,
    hire_date DATE
);


INSERT INTO employees (name, department, salary, hire_date) VALUES
('Ana', 'IT', 5000, '2021-03-15'),
('Carlos', 'HR', 4200, '2022-06-10'),
('Laura', 'IT', 5600, '2020-11-05'),
('Mateo', 'Finance', 4800, '2023-01-12'),
('Lucía', 'Finance', 4700, '2022-09-25');


SELECT columnas
FROM tabla
[WHERE condición]
[ORDER BY columna]
[LIMIT número];


-- Ver toda la tabla
    SELECT * FROM employees;

-- Ver solo nombre y salario
SELECT name, salary FROM employees;

-- Cambiar el alias de columna
SELECT name AS "Empleado", salary AS "Sueldo" FROM employees;
