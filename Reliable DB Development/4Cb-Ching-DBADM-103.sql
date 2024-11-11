-- ITDBADM-103
-- Ching, Bryan Nicholas 

-- 4C.b
-- Logically, not all the details about the employee can be modified. Only the extension and email, Job Title and Employee Type can be changed.

-- Test Case 1
-- Check if Extensio and email, job title and eployee can be changed
-- Test Case 2
-- Check if Lastname and Firstname cannot be changed


DELIMITER $$
DROP TRIGGER IF EXISTS restrict_employee_update;
CREATE TRIGGER restrict_employee_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
-- Lastname and firstname should not be allowed to change
    IF NEW.lastName != OLD.lastName THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Modification of last name is not allowed.';
    END IF;

    IF NEW.firstName != OLD.firstName THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Modification of first name is not allowed.';
    END IF;

-- every other field aside from the ones above can be changed

END $$
DELIMITER ;
