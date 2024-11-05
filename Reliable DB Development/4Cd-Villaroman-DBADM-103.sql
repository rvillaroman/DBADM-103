-- Villaroman, Raphael Luis G.
-- DBADM-103

SET GLOBAL event_scheduler = ON;

-- Drop the event if it already exists to avoid duplication
DROP EVENT IF EXISTS auto_reassign_sales_rep;

DELIMITER $$

-- Create the event
CREATE EVENT auto_reassign_sales_rep
ON SCHEDULE EVERY 1 DAY
STARTS '2024-11-05 18:00:00'  -- Starts at 6:00 PM daily
DO
BEGIN
    DECLARE current_sales DECIMAL(9,2);
    DECLARE new_end_date DATE;
    DECLARE done BOOLEAN DEFAULT FALSE;

    DECLARE emp_num INT;
    DECLARE office INT;
    DECLARE prev_quota DECIMAL(9,2);
    DECLARE prev_start DATE;
    DECLARE prev_end DATE;

    -- Define a cursor for expired assignments without a new assignment
    DECLARE expired_cursor CURSOR FOR
        SELECT employeeNumber, officeCode, quota, startDate, endDate
        FROM salesrepassignments
        WHERE endDate = CURRENT_DATE
        AND TIME(NOW()) >= '18:00:00'
        AND salesManagerNumber IS NULL;

    -- Handler for when there are no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor to process each expired assignment
    OPEN expired_cursor;

    read_loop: LOOP
        FETCH expired_cursor INTO emp_num, office, prev_quota, prev_start, prev_end;
        
        -- Exit the loop if there are no more rows
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calculate sales made during the previous assignment period
        SELECT SUM(amountpaid) INTO current_sales
        FROM payment_orders
        WHERE orderNumber IN (
            SELECT orderNumber 
            FROM orders 
            WHERE customerNumber IN (
                SELECT customerNumber 
                FROM customers 
                WHERE salesRepEmployeeNumber = emp_num
            )
        )
        AND paymentTimestamp BETWEEN prev_start AND prev_end;
        
        -- If no sales were made, set current_sales to 0
        IF current_sales IS NULL THEN
            SET current_sales = 0.0;
        END IF;

        -- Compute the new quota by deducting the sales already facilitated
        SET new_end_date = DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY);

        -- Insert the new reassignment record
        INSERT INTO salesrepassignments (employeeNumber, officeCode, startDate, endDate, reason, quota, salesManagerNumber)
        VALUES (emp_num, office, CURRENT_DATE, new_end_date, 'Automatic Reassignment by System', 
                prev_quota - current_sales, NULL);
    END LOOP;

    -- Close the cursor
    CLOSE expired_cursor;

END $$

DELIMITER ;

-- Test Case 1:

-- show events;

-- UPDATE salesrepassignments
-- SET endDate = '2024-11-05'
-- WHERE employeeNumber = 1166 AND officeCode = 1;

-- SELECT * FROM salesrepassignments WHERE employeeNumber = 1166;





