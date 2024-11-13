-- Part 4C-F
-- Ridz Rigat


DROP TRIGGER IF EXISTS 4CF_update_sales_rep_assignment_end_date;
DELIMITER $$
CREATE TRIGGER 4CF_update_sales_rep_assignment_end_date
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF (OLD.employee_type = 'S') AND (NEW.employee_type = 'N') THEN
        UPDATE salesRepAssignments
        SET endDate = CURDATE()
        WHERE employeeNumber = NEW.employeeNumber;
    END IF;
END $$
DELIMITER ;

SHOW TRIGGERS;

-- test1
-- should update the endDate to CURDATE if the endDate is null, it means assignment is still active
-- UPDATE employees
-- SET employee_type = 'N'
-- WHERE employeeNumber = 1188;

-- test2
-- should not work since 1056 is not a salesRep
-- UPDATE employees
-- SET employee_type = 'S'
-- WHERE employeeNumber = 1056;
