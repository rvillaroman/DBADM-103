-- Villaroman, Raphael Luis G.
-- DBADM-103

-- 4A-E START

-- Prevent Physical Deletion of Orders (Cancelling Instead)
DROP TRIGGER IF EXISTS orders_BEFORE_DELETE;
DELIMITER $$
CREATE TRIGGER orders_BEFORE_DELETE
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Orders cannot be deleted, only cancelled.';
END $$
DELIMITER ;

-- Trigger for Cancelling Orders (BEFORE UPDATE)
DROP TRIGGER IF EXISTS orders_BEFORE_UPDATE;
DELIMITER $$

CREATE TRIGGER orders_BEFORE_UPDATE
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Check if the order status is being changed to 'Cancelled'
    IF NEW.status = 'Cancelled' THEN
        -- Restore products to inventory when the order is cancelled
        UPDATE products p
        JOIN orderdetails od ON p.productCode = od.productCode
        SET p.quantityInStock = p.quantityInStock + od.quantityOrdered
        WHERE od.orderNumber = OLD.orderNumber;

        -- Log the reason for cancellation as "Cancelled by System"
        SET NEW.comments = CONCAT(OLD.comments, ' | System Cancelled Order');
    
    END IF;

    -- Prevent further modifications on cancelled orders
    IF OLD.status = 'Cancelled' THEN
        SET errormessage = 'No further changes are allowed for cancelled orders.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

END $$ 
DELIMITER ;

-- Trigger to Prevent Order Deletion (BEFORE DELETE)
DROP TRIGGER IF EXISTS orders_BEFORE_DELETE;
DELIMITER $$

CREATE TRIGGER orders_BEFORE_DELETE
BEFORE DELETE ON orders
FOR EACH ROW 
BEGIN
    -- Prevent deletion of orders by raising an error
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Orders cannot be deleted, only cancelled.';
END $$ 
DELIMITER ;

-- 4A-E END
