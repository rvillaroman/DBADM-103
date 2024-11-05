-- Villaroman, Raphael Luis G.
-- DBADM-103

-- 4A-E START

-- Trigger for order cancellation logic (BEFORE UPDATE)
DROP TRIGGER IF EXISTS orders_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER orders_BEFORE_UPDATE
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Handle cancellation status
    IF NEW.status = 'Cancelled' THEN
        -- Restore inventory for cancelled order
        UPDATE current_products p
        JOIN orderdetails od ON p.productCode = od.productCode
        SET p.quantityInStock = p.quantityInStock + od.quantityOrdered
        WHERE od.orderNumber = OLD.orderNumber;

        -- Log cancellation reason
        SET NEW.comments = CONCAT(OLD.comments, ' | System Cancelled Order');
    END IF;

    -- Prevent updates on cancelled orders
    IF OLD.status = 'Cancelled' THEN
        SET errormessage = 'No further changes are allowed for cancelled orders.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

END $$
DELIMITER ;

-- Trigger to prevent physical deletion of orders (BEFORE DELETE)
DROP TRIGGER IF EXISTS orders_BEFORE_DELETE;
DELIMITER $$
CREATE TRIGGER orders_BEFORE_DELETE
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    -- Disallow deletion of orders
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Orders cannot be deleted, only cancelled.';
END $$
DELIMITER ;

-- 4A-E END
