USE PracticalTest;

DELIMITER //
CREATE FUNCTION AuthenticateUser(
    in_email VARCHAR(255),
    in_password VARCHAR(255),
    in_role ENUM('admin', 'employee')
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE userCount INT;

    -- Verificar si las credenciales son correctas
    SELECT COUNT(*) INTO userCount
    FROM Users
    WHERE email = in_email
        AND password = in_password
        AND role = in_role
        AND status = 'active';

    IF userCount = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END //

DELIMITER ;

