-- Villaroman, Raphael Luis G.
-- DBADM-103

DROP TRIGGER IF EXISTS orders_BEFORE_INSERT;
DROP TRIGGER IF EXISTS orderdetails_BEFORE_INSERT;
DROP TRIGGER IF EXISTS orderdetails_BEFORE_UPDATE;

-- Trigger to handle automatic order date, status, and required date validation for new orders
DELIMITER $$
CREATE TRIGGER orders_BEFORE_INSERT
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Automatically set orderDate to the current date
    SET NEW.orderDate = CURRENT_DATE();

    -- Set default status to 'In Process'
    SET NEW.status = 'In Process';

    -- Validate that requiredDate is at least 3 days after orderDate
    IF (TIMESTAMPDIFF(DAY, NEW.orderDate, NEW.requiredDate) < 3) THEN
        SET errormessage = CONCAT("Required Date cannot be less than 3 days from the Order Date of ", NEW.orderDate);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Set shipment reference (shippedDate) to NULL by default on order creation
    SET NEW.shippedDate = NULL;
END $$
DELIMITER ;

-- Trigger to deduct products from inventory when orderdetails are created
DELIMITER $$
CREATE TRIGGER orderdetails_BEFORE_INSERT
BEFORE INSERT ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    DECLARE errormessage VARCHAR(255);

    -- Fetch current stock for the product
    SELECT quantityInStock INTO current_stock
    FROM current_products
    WHERE productCode = NEW.productCode;

    -- Check if there is enough stock available
    IF current_stock < NEW.quantityOrdered THEN
        SET errormessage = CONCAT('Insufficient stock for the ordered product ', NEW.productCode, '. Available stock: ', current_stock, ', Requested: ', NEW.quantityOrdered);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    ELSE
        -- Deduct ordered quantity from the stock
        UPDATE current_products
        SET quantityInStock = quantityInStock - NEW.quantityOrdered
        WHERE productCode = NEW.productCode;
    END IF;
END $$
DELIMITER ;

-- Trigger to adjust inventory when quantityOrdered is updated in orderdetails
DELIMITER $$
CREATE TRIGGER orderdetails_BEFORE_UPDATE
BEFORE UPDATE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    DECLARE errormessage VARCHAR(255);
    DECLARE quantity_difference INT;

    -- Calculate the difference between the new and old quantityOrdered
    SET quantity_difference = NEW.quantityOrdered - OLD.quantityOrdered;

    -- Fetch current stock for the product
    SELECT quantityInStock INTO current_stock
    FROM current_products
    WHERE productCode = NEW.productCode;

    -- Adjust inventory based on the quantity difference
    IF quantity_difference > 0 THEN
        -- Check if there is enough stock available to cover the increase
        IF current_stock < quantity_difference THEN
            SET errormessage = CONCAT('Insufficient stock for the ordered product ', NEW.productCode, '. Available stock: ', current_stock, ', Additional requested: ', quantity_difference);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        ELSE
            -- Deduct the additional quantity from stock
            UPDATE current_products
            SET quantityInStock = quantityInStock - quantity_difference
            WHERE productCode = NEW.productCode;
        END IF;
    ELSEIF quantity_difference < 0 THEN
        -- If quantity has been reduced, add the difference back to stock
        UPDATE current_products
        SET quantityInStock = quantityInStock - quantity_difference
        WHERE productCode = NEW.productCode;
    END IF;
END $$
DELIMITER ;