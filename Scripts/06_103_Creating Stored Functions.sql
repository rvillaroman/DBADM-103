
-- Stored Function Implementation Script
-- Extended DB Sales
-- This script will create stored functions in the Database to be used in the
-- implementation of business rules

-- Getting a specific MSRP for a product

-- For discontinued products
-- products		     - to determine if the product is Current or Discontinued. And if its discontinued, we return an ERROR

-- For wholesale products
-- products		     - to determine if the product is Current or Discontinued
-- current_products  - to determine if the product is retail or wholesale
-- product_wholesale - to get the MSRP of the wholesale product

-- For retail products
-- products			- to determine if the product is Current of Discontinued
-- current_products	- to determine if the product is retail or wholesale
-- product_retail	- to read the retail product
-- product_pricing	- to get the MSRP applicable depending on the date, if the price is not available, we return an ERROR

-- To create a function instead that will accept one  value PRODUCT CODE and returns the MSRP

DROP FUNCTION IF EXISTS getMSRP;
DELIMITER $$
CREATE FUNCTION getMSRP (param_productCode VARCHAR(15)) 
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
	DECLARE	var_productcategory	ENUM('C', 'D');
    DECLARE var_producttype		ENUM('R', 'W');
    DECLARE var_MSRP			DECIMAL(9,2);
    DECLARE errormessage		VARCHAR(200);
    
	SELECT	product_category
    INTO	var_productcategory
    FROM	products
    WHERE	productCode = param_productCode;
    
    -- Check if the product exists
    IF (var_productcategory IS NULL) THEN
		SET errormessage := "Product does not exist";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

	-- Check if the product is discontinued
	IF (var_productcategory = 'D') THEN
		SET errormessage := "Product is discontinued. No MSRP available";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
	
    -- Check the current products table to determine if wholesale or retail
    
    SELECT	product_type
    INTO	var_producttype
    FROM	current_products
    WHERE	productCode = param_productCode;
    
    -- Check if the product is retail
    
    IF (var_producttype = 'R') THEN
		-- the product is retail
        SELECT  MSRP
        INTO	var_MSRP
        FROM	product_pricing
        WHERE	NOW() BETWEEN startdate AND enddate
        AND		productCode = param_productCode;
        
        -- Check if the price was available
        IF (var_MSRP IS NULL) THEN
			SET errormessage := CONCAT("MSRP of the product does not exist yet given the date of ", NOW());
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        END IF;
        RETURN var_MSRP;
    ELSE
		-- the product is wholesale
        SELECT 	MSRP
        INTO	var_MSRP
        FROM	product_wholesale
		WHERE	productCode = param_productCode;
	
		RETURN var_MSRP;
    END IF;
    
END $$
DELIMITER ;

-- Create a function that checks for the valid values of status
-- 4A.C start

DROP FUNCTION IF EXISTS isStatusValid;
DELIMITER $$
CREATE FUNCTION isStatusValid (param_status VARCHAR(15))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	IF (param_status IN ("In Process","Shipped","Disputed","Resolved","Completed","Cancelled")) THEN
		RETURN TRUE;
	ELSE 
		RETURN FALSE;
    END IF;
END $$
DELIMITER ;

-- Create a Function that checks if the old status to the new status is VALID
-- based on the rules in 4A.C

DELIMITER $$
DROP FUNCTION IF EXISTS isValidStatus;
CREATE FUNCTION isValidStatus(param_oldstatus VARCHAR(15), param_newstatus VARCHAR(15)) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE errormessage VARCHAR(200);
    
    IF (param_oldstatus = param_newstatus) THEN RETURN TRUE;
    END IF;
    
    IF (NOT isStatusValid(param_oldstatus) OR NOT isStatusValid(param_newstatus)) THEN
		SET errormessage := CONCAT("Either ", param_oldstatus, " or ", param_newstatus, " is not a valid status");
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;	
    END IF;

    -- ONLY In-Process to Shipped, Shipped to Disputed, Disputed to Resolved,
    -- Shipped to Completed, & Resolved to Completed are ALLOWED
    
    IF (param_oldstatus = "In Process" AND param_newstatus != "Shipped") THEN
        SET errormessage := "Transition from In Process to any status other than Shipped is not allowed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    IF (param_oldstatus = "Shipped" AND param_newstatus NOT IN ("Disputed", "Completed")) THEN
        SET errormessage := "Transition from Shipped is only allowed to Disputed or Completed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    IF (param_oldstatus = "Disputed" AND param_newstatus != "Resolved") THEN
        SET errormessage := "Transition from Disputed is only allowed to Resolved";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    IF (param_oldstatus = "Resolved" AND param_newstatus != "Completed") THEN
        SET errormessage := "Transition from Resolved is only allowed to Completed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    -- Ensure no backward transitions are allowed
    IF (param_newstatus IN ("In Process") AND param_oldstatus IN ("Shipped", "Disputed", "Resolved", "Completed")) THEN
        SET errormessage := "Reverting status backward is not allowed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    RETURN TRUE;
END $$
DELIMITER ;

-- Ensure the order update rules and status transitions for the "orders" table
-- Sequence must be strictly forward, and not backward

DELIMITER $$
DROP TRIGGER IF EXISTS before_order_update;
CREATE TRIGGER before_order_update
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN

    -- Check if the status is being updated correctly
    IF (NEW.status IS NOT NULL AND OLD.status != NEW.status) THEN
        IF (NOT isValidStatus(OLD.status, NEW.status)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid status transition';
        END IF;
        
        -- Prevent changes if status is "Completed"
        IF (OLD.status = "Completed") THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No updates allowed for orders with Completed status';
        END IF;
    END IF;
    
    -- Ensure shippedDate can only be set if status is "Shipped"
    IF (NEW.status = "Shipped" AND OLD.status = "Shipped" AND NEW.shippedDate IS NULL) THEN
        SET NEW.shippedDate = NOW();
    END IF;
    
    -- Prevent shippedDate changes unless the status is "Shipped"
    IF (NEW.shippedDate IS NOT NULL AND OLD.shippedDate != NEW.shippedDate) THEN
        IF (OLD.status != "Shipped") THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot set shippedDate unless status is Shipped';
        END IF;
        
        -- Prevent directly modifying shippedDate if the status is already "Shipped"
        IF (NEW.status = "Shipped" AND OLD.shippedDate IS NOT NULL AND NEW.shippedDate != OLD.shippedDate) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot modify shippedDate directly for a shipped order';
        END IF;
    END IF;
    
    -- Append to comments instead of overwriting
    IF (NEW.comments IS NOT NULL AND NEW.comments != OLD.comments) THEN
        SET NEW.comments = CONCAT(OLD.comments, ' ', NEW.comments);
    END IF;
    
    -- Restrict allowed updates to only requiredDate, status, and comments
    IF (OLD.orderDate != NEW.orderDate 
        OR OLD.customerNumber != NEW.customerNumber) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only requiredDate, status, and comments can be updated';
    END IF;
    
    -- Allow updating requiredDate if it's the only field being changed
    IF (NEW.requiredDate != OLD.requiredDate AND OLD.status != "Completed") THEN
        SET NEW.requiredDate = NEW.requiredDate;  -- Ensures the update is acknowledged
    END IF;
END $$
DELIMITER ;


-- Order Cancellation Script (4A.E)
-- This script will create mechanisms to handle order cancellations,
-- Automatically restore inventory, log cancellation reason, and prevent further modifications on cancelled orders.

-- TRIGGER FOR ORDER CANCELLATION (BEFORE UPDATE)

DROP TRIGGER IF EXISTS orders_BEFORE_UPDATE;
DELIMITER $$

CREATE TRIGGER `orders_BEFORE_UPDATE` 
BEFORE UPDATE ON `orders` 
FOR EACH ROW 
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Check if the order status is being changed to 'Cancelled'
    IF NEW.status = 'Cancelled' THEN
        --  Restore products to inventory when the order is cancelled
        UPDATE Products p
        JOIN OrderDetails od ON p.productCode = od.productCode
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

-- TRIGGER TO PREVENT ORDER DELETION (BEFORE DELETE)

DROP TRIGGER IF EXISTS orders_BEFORE_DELETE;
DELIMITER $$

CREATE TRIGGER `orders_BEFORE_DELETE` 
BEFORE DELETE ON `orders` 
FOR EACH ROW 
BEGIN
    -- Prevent deletion of orders by raising an error
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Orders cannot be deleted, only cancelled.';
END $$ 
DELIMITER ;






