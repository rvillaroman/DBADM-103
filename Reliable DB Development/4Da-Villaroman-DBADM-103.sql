-- Villaroman, Raphael Luis G.
-- DBADM-103

SET GLOBAL event_scheduler = ON;
DROP PROCEDURE IF EXISTS reassess_credit_limits_proc;

DELIMITER $$

-- Create the stored procedure to reassess credit limits
CREATE PROCEDURE reassess_credit_limits_proc()
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE customer_id INT;
    DECLARE order_total DECIMAL(10,2) DEFAULT 0.0;
    DECLARE order_count INT DEFAULT 0;
    DECLARE max_order DECIMAL(10,2) DEFAULT 0.0;

    -- Cursor to iterate over each customer
    DECLARE customer_cursor CURSOR FOR
    SELECT customerNumber
    FROM customers;

    -- Continue handler for cursor completion
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN customer_cursor;

    -- Read each customer in the loop
    read_loop: LOOP
        FETCH customer_cursor INTO customer_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate the total value of orders for the customer made during the current month
        SET order_total = (
            SELECT IFNULL(SUM(od.priceEach * od.quantityOrdered), 0)
            FROM orders o
            JOIN orderdetails od ON o.orderNumber = od.orderNumber
            WHERE o.customerNumber = customer_id
            AND MONTH(o.orderDate) = MONTH(CURRENT_DATE())
            AND YEAR(o.orderDate) = YEAR(CURRENT_DATE())
            AND o.status = 'Shipped'
        );

        -- Get the count of orders made by the customer this month
        SET order_count = (
            SELECT IFNULL(COUNT(*), 0)
            FROM orders
            WHERE customerNumber = customer_id
            AND MONTH(orderDate) = MONTH(CURRENT_DATE())
            AND YEAR(orderDate) = YEAR(CURRENT_DATE())
            AND status = 'Shipped'
        );

        -- If the customer made more than 15 orders, find the maximum order amount this month
        IF order_count > 15 THEN
            SET max_order = (
                SELECT IFNULL(MAX(od.priceEach * od.quantityOrdered), 0)
                FROM orders o
                JOIN orderdetails od ON o.orderNumber = od.orderNumber
                WHERE o.customerNumber = customer_id
                AND MONTH(o.orderDate) = MONTH(CURRENT_DATE())
                AND YEAR(o.orderDate) = YEAR(CURRENT_DATE())
                AND o.status = 'Shipped'
            );
        ELSE
            SET max_order = 0;
        END IF;

        -- Update the credit limit of the customer
        UPDATE customers
        SET creditLimit = (order_total * 2) + max_order
        WHERE customerNumber = customer_id;
    END LOOP;

    -- Close the cursor
    CLOSE customer_cursor;

END $$

DELIMITER ;

-- Call the procedure manually to test
CALL reassess_credit_limits_proc();

-- Drop existing event if it exists
DROP EVENT IF EXISTS reassess_credit_limits;

DELIMITER $$

-- Create the scheduled event to reassess credit limits every end of the month
CREATE EVENT reassess_credit_limits
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-11-30 23:59:59'
DO
BEGIN
    CALL reassess_credit_limits_proc();
END $$

DELIMITER ;
show events;


