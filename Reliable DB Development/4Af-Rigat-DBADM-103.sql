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
        comments = CONCAT(IFNULL(comments, ''), ' | Automatically cancelled by system due to non-shipping within one week.')
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


