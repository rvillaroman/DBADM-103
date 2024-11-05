-- Villaroman, Raphael Luis G.
-- DBADM-103

DROP TRIGGER IF EXISTS before_insert_salesrepassignments;

DELIMITER $$

CREATE TRIGGER before_insert_salesrepassignments
BEFORE INSERT ON salesrepassignments
FOR EACH ROW
BEGIN
    DECLARE last_end_date DATE;

    -- Check if startDate is NULL
    IF NEW.startDate IS NULL THEN
        -- Retrieve the endDate of the employee's last assignment
        SELECT MAX(endDate) INTO last_end_date
        FROM salesrepassignments
        WHERE employeeNumber = NEW.employeeNumber;

        -- If a last_end_date exists, set startDate to the day after the last endDate
        IF last_end_date IS NOT NULL THEN
            SET NEW.startDate = DATE_ADD(last_end_date, INTERVAL 1 DAY);
        ELSE
            -- If no prior assignment, set startDate to the current date
            SET NEW.startDate = CURRENT_DATE;
        END IF;
    END IF;

    -- Ensure endDate is no more than one month after startDate
    IF NEW.endDate > DATE_ADD(NEW.startDate, INTERVAL 1 MONTH) THEN
        SET NEW.endDate = DATE_ADD(NEW.startDate, INTERVAL 1 MONTH);
    END IF;

    -- Check if quota is provided by the Sales Manager; if not, default it to 0
    IF NEW.quota IS NULL THEN
        SET NEW.quota = 0.0;
    END IF;

    -- Set reason to indicate it's a new assignment if reason is not provided
    IF NEW.reason IS NULL THEN
        SET NEW.reason = 'New Assignment';
    END IF;
END $$

DELIMITER ;

-- Test Case:
-- INSERT INTO salesrepassignments (employeeNumber, officeCode, startDate, endDate, reason, quota, salesManagerNumber)
-- VALUES (1166, 1, NULL, '2025-01-01', 'New Assignment', 8000.00, 1143);
