
CREATE DATABASE salon;


\c salon;


CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL
);


CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);


CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    service_id INT REFERENCES services(service_id),
    time VARCHAR(50) NOT NULL
);


INSERT INTO services (name)
VALUES
('Corte de cabello'),
('Tinte de cabello'),
('Manicura');
