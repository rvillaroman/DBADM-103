-- Part 4C-F
-- Ridz Rigat

ALTER TABLE employees
MODIFY employee_type ENUM('S', 'SM', 'N', 'IM') NULL;

DROP TRIGGER IF EXISTS 4CF_update_sales_rep_assignment_end_date;
DELIMITER $$
CREATE TRIGGER 4CF_update_sales_rep_assignment_end_date
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF (OLD.employee_type = 'S') AND (NEW.employee_type = 'N' OR NEW.employee_type = 'SM' OR NEW.employee_type = 'IM') THEN
        UPDATE salesRepAssignments
        SET endDate = CURDATE()
        WHERE employeeNumber = NEW.employeeNumber
          AND endDate IS NULL; -- Ensures only active assignments are affected
    END IF;
END $$
DELIMITER ;

SHOW TRIGGERS;
