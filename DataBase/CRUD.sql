USE PracticalTest;
-- ----------------------------------
DELIMITER //
CREATE PROCEDURE CreateUser(
    IN p_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255),
    IN p_role VARCHAR(255)
)
BEGIN
    DECLARE duplicate_email INT DEFAULT 0;
    DECLARE last_user_id INT;

    -- Verificar si el correo electrónico ya existe
    SELECT COUNT(*) INTO duplicate_email FROM Users WHERE email = p_email;

    -- Si el correo electrónico ya existe, lanzar un error
    IF duplicate_email > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate email. Please choose another.', MYSQL_ERRNO = 409;
    END IF;

    -- Obtener el último ID antes de realizar la inserción
    SELECT MAX(id) INTO last_user_id FROM Users;

    -- Si no hay usuarios (por ejemplo, después de borrar todos), establecer el último ID en 0
    IF last_user_id IS NULL THEN
        SET last_user_id = 0;
    END IF;

    -- Proceder a la inserción con el nuevo ID
    INSERT INTO Users (id, name, email, password, role)
    VALUES (last_user_id + 1, p_name, p_email, p_password, p_role);

    SELECT 'User created successfully.' AS message;
END //

DELIMITER ;
-- ----------------------------------
DELIMITER //
CREATE PROCEDURE ReadUsers()
BEGIN
    SELECT * FROM Users;
END //

DELIMITER ;
-- ----------------------------------
DELIMITER //
CREATE PROCEDURE UpdateUser(
    IN in_id INT,
    IN in_name VARCHAR(255),
    IN in_email VARCHAR(255),
    IN in_password VARCHAR(255),
    IN in_role ENUM('admin', 'employee')
)
BEGIN
    UPDATE Users
    SET name = in_name, email = in_email, password = in_password, role = in_role
    WHERE id = in_id;
END //
DELIMITER ;
-- ----------------------------------
DELIMITER //
CREATE PROCEDURE DeleteUser(
    IN in_id INT
)
BEGIN
    DELETE FROM Users WHERE id = in_id;
END //
DELIMITER ;
-- ---------------------------------
CALL CreateUser('Admin User', 'admin@email.com', 'password', 'admin');
CALL UpdateUser(2, 'User Employee', 'employee@email.com', 'password', 'employee');
CALL ReadUsers();
CALL DeleteUser(2);


-- -----------------------------------------------------------------------------

-- ------------------
DELIMITER //

CREATE PROCEDURE InsertProduct(
    IN productName VARCHAR(255),
    IN productStack INT,
    IN productCategory VARCHAR(255)
)
BEGIN
    DECLARE last_product_id INT;

    -- Obtener el último ID antes de realizar la inserción
    SELECT COALESCE(MAX(id), 0) INTO last_product_id FROM Products;

    -- Proceder a la inserción con el nuevo ID
    INSERT INTO Products (id, name_product, stack, category)
    VALUES (last_product_id + 1, productName, productStack, productCategory);

    SELECT 'Product inserted successfully.' AS message;
END //

DELIMITER ;
-- ----------------------------------
DELIMITER //
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;



CALL InsertProduct('Rollitos de canela', 35, 'Dulces');
CALL GetAllProducts();



