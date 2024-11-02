DROP TRIGGER IF EXISTS orders_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER `orders_BEFORE_UPDATE` BEFORE UPDATE ON `orders` FOR EACH ROW BEGIN
	DECLARE errormessage	VARCHAR(200);
    
    IF (new.ordernumber != old.ordernumber) THEN
		SET errormessage = CONCAT("Order Number  ", old.ordernumber, " cannot be updated to a new value of ", new.ordernumber);
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    -- Check if the updated orderdate is before the original orderdate
    IF (new.orderdate < old.orderdate) THEN
		SET errormessage = CONCAT("Updated orderdate cannot be less than the origianl date of ", old.orderdate);
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    IF (TIMESTAMPDIFF(DAY, new.orderdate, new.requireddate) < 3) THEN
		SET errormessage = CONCAT("Required Data cannot be less than 3 days from the Order Date of ", new.orderdate);
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
        -- Check for the precense of customer
    IF (new.customernumber IS NULL) THEN
		SET errormessage = CONCAT("Order number ", new.ordernumber, " cannot be updated without a customer");
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    

    
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS orderdetails_restrictions;
DELIMITER $$

CREATE TRIGGER orderdetails_restrictions
BEFORE UPDATE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE order_status VARCHAR(50);

    -- Retrieve the status from the orders table for the relevant orderNumber
    SELECT status INTO order_status
    FROM orders
    WHERE orders.orderNumber = NEW.orderNumber;

    -- No updates allowed once the order status is "shipped"
    IF order_status = 'shipped' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No updates are allowed on ordered products once the order has shipped.';
    END IF;

    -- Only allow updates on quantityOrdered and priceEach
    IF NEW.quantityOrdered != OLD.quantityOrdered OR NEW.priceEach != OLD.priceEach THEN
        -- Check for allowed fields (quantity and price)
        IF NEW.referenceNo != OLD.referenceNo THEN
            -- reference no should be updated only if shipped
            IF order_status != 'shipped' THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Reference number can only be updated when the order status is shipped';
            END IF;
        END IF;
    ELSE
        -- error if other fields are being updated
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only quantityOrdered and priceEach can be updated on ordered products';
    END IF;
END $$

DELIMITER ;

DROP TRIGGER IF EXISTS orderdetails_delete_restriction;
DELIMITER $$

CREATE TRIGGER orderdetails_delete_restriction
BEFORE DELETE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE order_status VARCHAR(50);

    SELECT status INTO order_status
    FROM orders
    WHERE orders.orderNumber = OLD.orderNumber;

    -- Once the status of the order reached “Shipped”, no activity on the ordered products should be allowed to happen."
    IF order_status = 'shipped' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordered products cannot be deleted once the order has shipped.';
    END IF;
END $$

DELIMITER ;
