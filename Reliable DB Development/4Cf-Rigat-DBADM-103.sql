-- Part 4C-F
-- Ridz Rigat

DROP TRIGGER IF EXISTS update_sales_rep_assignment_end_date;
DELIMITER $$
CREATE TRIGGER update_sales_rep_assignment_end_date
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.employee_type = 'N' OR NEW.employee_type = 'SM' OR NEW.employee_type = 'IM' AND OLD.employee_type = 'S' THEN
        UPDATE salesRepAssignments
        SET endDate = CURDATE()
        WHERE employeeNumber = NEW.employeeNumber;
    END IF;
END $$

DELIMITER ;

SHOW TRIGGERS;