-- Part 4A-F
-- Ridz Rigat

DROP EVENT IF EXISTS cancel_unshipped_orders_event;
DELIMITER $$
CREATE EVENT cancel_unshipped_orders_event
ON SCHEDULE 
EVERY 5 SECOND 
DO
BEGIN
    UPDATE orders
    SET 
        status = 'Cancelled',
        comments = 'Automatically cancelled by system due to non-shipping within one week.'
    WHERE 
        status != 'Shipped' 
        AND shippedDate IS NULL 
        AND orderDate <= DATE_SUB(CURDATE(), INTERVAL 7 DAY);
END $$
DELIMITER ;

SHOW PROCESSLIST;
SHOW EVENTS;

SET GLOBAL EVENT_SCHEDULER = ON;
SET GLOBAL EVENT_SCHEDULER = OFF;

SHOW VARIABLES LIKE 'event_scheduler';
																
ALTER EVENT cancel_unshipped_orders_event DISABLE;
ALTER EVENT cancel_unshipped_orders_event ENABLE;

-- FOR CHECKING OF THE ORDERS THAT ARE NOT SHIPPED
SELECT * FROM orders
WHERE 
    status != 'Shipped' 
    AND shippedDate IS NULL 
    AND orderDate <= DATE_SUB(CURDATE(), INTERVAL 7 DAY);



-- working since requiredDate data is more than 3 days of the order date and the orderdate is automaticall set to  CURDATE due to 4AA
-- status will be set to 'Cancelled' and comments will be set to 'Automatically cancelled by system due to non-shipping within one week.'
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (1001, '2024-10-11', CURDATE() + INTERVAL 4 DAY, NULL, 'Processing', NULL, 119);

-- working since requiredDate data is more than 3 days of the order date
-- status will be set to 'Cancelled' and comments will be set to 'Automatically cancelled by system due to non-shipping within one week.'
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (1002, CURDATE(), CURDATE() + INTERVAL 5 DAY, NULL, 'Processing', NULL, 119);

-- working since requiredDate data is more than 3 days of the order date
-- status will be set to 'Cancelled' and comments will be set to 'Automatically cancelled by system due to non-shipping within one week.'
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (1002, CURDATE(), CURDATE() + INTERVAL 4 DAY, NULL, 'Processing', NULL, 119);

-- working since requiredDate data is more than 3 days of the order date, status will be set to In Process due to 4AA. 
-- status will be set to 'Cancelled' and comments will be set to 'Automatically cancelled by system due to non-shipping within one week.'
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (1002, CURDATE(), CURDATE() + INTERVAL 4 DAY, NULL, 'Cancelled', 'cancelled by the user', 119);

-- will not work due to 4AA before insert restriction with the 3 day rule.
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (1002, CURDATE(), CURDATE() + INTERVAL 3 DAY, NULL, 'Processing', NULL, 119);

-- will not work due to 4AA before insert restriction with the 3 day rule.
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (1002, CURDATE(), CURDATE() + INTERVAL 2 DAY, NULL, 'Processing', NULL, 119);

-- will not work due to 4AA before insert restriction with the 3 day rule.
INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
VALUES (1002, CURDATE(), CURDATE() + INTERVAL 1 DAY, NULL, 'Processing', NULL, 119);

