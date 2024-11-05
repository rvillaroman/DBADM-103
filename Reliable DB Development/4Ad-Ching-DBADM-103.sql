DROP TRIGGER IF EXISTS orders_BEFORE_UPDATE;
DROP TRIGGER IF EXISTS orderdetails_restrictions;
DROP TRIGGER IF EXISTS orderdetails_delete_restriction;

-- Trigger for orders: Enforces restrictions on order fields
DELIMITER $$
CREATE TRIGGER `orders_BEFORE_UPDATE` BEFORE UPDATE ON `orders` FOR EACH ROW 
BEGIN
    DECLARE errormessage VARCHAR(200);
    
    -- Check if orderNumber is being updated
    IF (NEW.ordernumber != OLD.ordernumber) THEN
        SET errormessage = CONCAT("Order Number ", OLD.ordernumber, " cannot be updated to a new value of ", NEW.ordernumber);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    -- Check if updated orderDate is before the original orderDate
    IF (NEW.orderdate < OLD.orderdate) THEN
        SET errormessage = CONCAT("Updated orderdate cannot be less than the original date of ", OLD.orderdate);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    -- Check if requiredDate is at least 3 days after orderDate
    IF (TIMESTAMPDIFF(DAY, NEW.orderdate, NEW.requireddate) < 3) THEN
        SET errormessage = CONCAT("Required Date cannot be less than 3 days from the Order Date of ", NEW.orderdate);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    -- Ensure customerNumber is present
    IF (NEW.customernumber IS NULL) THEN
        SET errormessage = CONCAT("Order number ", NEW.ordernumber, " cannot be updated without a customer");
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
END $$
DELIMITER ;

-- Trigger for orderdetails: Enforces restrictions based on order status
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

    -- If the order status is "Shipped"
    IF order_status = 'Shipped' THEN
        -- Only allow updates to referenceNo
        IF NEW.referenceNo = OLD.referenceNo THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only referenceNo can be updated on shipped orders.';
        END IF;
        
        -- Disallow updates to any other fields besides referenceNo
        IF NEW.quantityOrdered != OLD.quantityOrdered OR 
           NEW.priceEach != OLD.priceEach OR
           NEW.orderLineNumber != OLD.orderLineNumber THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No updates are allowed on fields other than referenceNo once the order is shipped.';
        END IF;
    ELSE
        -- When status is not "Shipped", only allow updates to quantityOrdered and priceEach
        IF NEW.quantityOrdered = OLD.quantityOrdered AND NEW.priceEach = OLD.priceEach THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only quantityOrdered and priceEach can be updated on non-shipped orders.';
        END IF;

        -- Prevent any attempt to update referenceNo on non-shipped orders
        IF NEW.referenceNo != OLD.referenceNo THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'referenceNo can only be updated when the order status is shipped.';
        END IF;

        -- Disallow updates to orderLineNumber and other fields when the order status is not "Shipped"
        IF NEW.orderLineNumber != OLD.orderLineNumber THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only quantityOrdered and priceEach can be updated on non-shipped orders.';
        END IF;
    END IF;
END $$
DELIMITER ;

-- Trigger to restrict deletion in orderdetails when order status is shipped
DELIMITER $$
CREATE TRIGGER orderdetails_delete_restriction
BEFORE DELETE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE order_status VARCHAR(50);

    -- Retrieve the status from the orders table for the relevant orderNumber
    SELECT status INTO order_status
    FROM orders
    WHERE orders.orderNumber = OLD.orderNumber;

    -- Restrict deletion if the order status is "Shipped"
    IF order_status = 'Shipped' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordered products cannot be deleted once the order has shipped.';
    END IF;
END $$
DELIMITER ;

