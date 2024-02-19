DROP USER 'william'@'localhost';
CREATE USER 'william'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'wesc';
GRANT ALL PRIVILEGES ON PracticalTest.* TO 'william'@'localhost';
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'wesc';

drop database if exists PracticalTest;
create database PracticalTest;

USE PracticalTest;

DROP TABLE IF EXISTS Users;
CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'employee') NOT NULL,
    status ENUM('active', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS Products;
CREATE TABLE IF NOT EXISTS Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name_product VARCHAR(255) NOT NULL,
    stack INT NOT NULL,
    category VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


INSERT INTO Products (name_product, stack, category) VALUES
('Pan integral', 20, 'Pan'),
('Baguette tradicional', 15, 'Pan'),
('Croissant de mantequilla', 30, 'Pastelería'),
('Donas glaseadas', 25, 'Dulces'),
('Rosquillas de canela', 18, 'Dulces'),
('Pastel de chocolate', 22, 'Pasteles'),
('Pan de ajo y hierbas', 28, 'Pan'),
('Tarta de frutas frescas', 12, 'Pasteles'),
('Rollitos de canela', 35, 'Dulces'),
('Pan de centeno', 17, 'Pan');



SELECT * FROM Users;
SELECT * FROM Products;

