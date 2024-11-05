-- need to add an isActive field to set a employee as resigned or is working remove comment to add it
-- ALTER TABLE employees
-- ADD COLUMN isActive BOOLEAN NOT NULL DEFAULT 1;


-- cannot delete the data. Make the isActive status 0
DELIMITER $$
DROP TRIGGER IF EXISTS prevent_employee_deletion;
CREATE TRIGGER prevent_employee_deletion
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Employee records cannot be deleted. Deactivate the record instead.';
END $$
DELIMITER ;

-- Do not allow modification on the isActive 0 status
DELIMITER $$
DROP TRIGGER IF EXISTS restrict_inactive_employee_update;
CREATE TRIGGER restrict_inactive_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    -- to allow only active members
  IF OLD.isActive = 0 AND NEW.isActive = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Modifications are not allowed on resigned employee records.';
    END IF;

END $$
DELIMITER ;



DELIMITER $$
DROP PROCEDURE IF EXISTS rehire_employee;
CREATE PROCEDURE rehire_employee (
    IN empNum INT,
    IN newExtension VARCHAR(10),
    IN newEmail VARCHAR(100),
    IN newJobTitle VARCHAR(50),
    IN newEmployeeType ENUM('S', 'N', 'SM', 'IM')
)
BEGIN
    DECLARE retrievedLastName VARCHAR(50);
    DECLARE retrievedFirstName VARCHAR(50);
    DECLARE newEmployeeNumber INT;

    -- Attempt to retrieve the lastName and firstName of the inactive employee
    SELECT lastName, firstName INTO retrievedLastName, retrievedFirstName
    FROM employees
    WHERE employeeNumber = empNum AND isActive = 0
    LIMIT 1;

    -- Check if the employee was found and is inactive
    IF retrievedLastName IS NOT NULL AND retrievedFirstName IS NOT NULL THEN
        -- Generate a new unique employee number
        SELECT IFNULL(MAX(employeeNumber), 0) + 1 INTO newEmployeeNumber FROM employees;

        -- make a new record using the lastname and firstname with the new data
        INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, jobTitle, employee_type, isActive)
        VALUES (newEmployeeNumber, retrievedLastName, retrievedFirstName, newExtension, newEmail, newJobTitle, newEmployeeType, 1);
    ELSE
        -- if the person is active or does not exist then it would not fall under this
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee not found or already active. Cannot rehire.';
    END IF;
END $$
DELIMITER ;

-- To test out the procedure above
-- SELECT * FROM employees;
-- CALL rehire_employee(1286, 'x1234', 'newemail@example.com', 'SalesRep', 'IM');
