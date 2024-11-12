-- ITDBADM-103
-- Ching, Bryan Nicholas 

-- 4C.c
-- Employee Records are not deleted. When employees resign that their records get deactivated, and no changes should be allowed on the record. If the
-- resigned employee reapplied to the company, a new employee record is created for the individual.

-- Instructions
-- need to add an isActive field to set a employee as resigned or is working remove comment to add it
-- cannot delete the data. Make the isActive status 0
-- ALTER TABLE employees
-- ADD COLUMN isActive BOOLEAN NOT NULL DEFAULT 1;

-- =============================================================
-- 4CC TEST CASE 1: Verify deleting a row is allowed
-- =============================================================

-- DELETE FROM employees
-- WHERE employeeNumber = 1165


-- =============================================================
-- 4CC TEST CASE 2: Verify if modification of records that are inactive is not allowed
-- =============================================================
-- UPDATE employees
-- SET isActive = 0
-- WHERE employeeNumber = 1076;
-- UPDATE employees
-- SET extension = "x9277" 
-- WHERE employeeNumber = 1076;

-- =============================================================
-- 4CC TEST CASE 3: Verify if rehiring of employee is allowed retaining name
-- =============================================================
-- SELECT * FROM employees;
-- CALL 4CC_rehire_employee(1286, 'x1234', 'newemail@example.com', 'SalesRep', 'IM');




DELIMITER $$
DROP TRIGGER IF EXISTS 4CC_prevent_employee_deletion;
CREATE TRIGGER 4CC_prevent_employee_deletion
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Employee records cannot be deleted. Deactivate the record instead.';
END $$
DELIMITER ;

-- Do not allow modification on the isActive 0 status
DELIMITER $$
DROP TRIGGER IF EXISTS 4CC_restrict_inactive_employee_update;
CREATE TRIGGER 4CC_restrict_inactive_employee_update
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
DROP PROCEDURE IF EXISTS 4CC_rehire_employee;
CREATE PROCEDURE 4CC_rehire_employee (
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

