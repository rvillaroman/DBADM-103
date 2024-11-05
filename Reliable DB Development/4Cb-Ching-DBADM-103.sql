
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
