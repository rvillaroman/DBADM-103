-- Villaroman, Raphael Luis G.
-- DBADM-103

-- Getting a specific MSRP for a product
-- Function to retrieve the MSRP based on product type and status

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

-- Trigger on Order Details for 4A-B business rule compliance

DROP TRIGGER IF EXISTS orderdetails_BEFORE_INSERT;
DELIMITER $$
CREATE TRIGGER `orderdetails_BEFORE_INSERT` BEFORE INSERT ON `orderdetails` FOR EACH ROW 
BEGIN
    DECLARE errormessage VARCHAR(200);
    
    SET new.referenceno = NULL;
    
    -- Check if the quantity ordered will make the inventory go below 0
    IF ((SELECT quantityInStock - new.quantityOrdered FROM current_products WHERE productCode = new.productCode) < 0) THEN
        SET errormessage = CONCAT("The quantity being ordered for ", new.productCode, " will make the inventory quantity go below zero");
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    -- Auto generation of orderline numbers
    SET new.orderLineNumber = IFNULL(
        (SELECT MAX(orderLineNumber) + 1 FROM orderdetails WHERE orderNumber = new.orderNumber),
        1
    );
    
    -- Check for consistency of price with MSRP: 20% discount and at most 100% beyond MSRP
    IF (NEW.priceEach < getMSRP(NEW.productCode) * 0.8) OR (NEW.priceEach > getMSRP(NEW.productCode) * 2) THEN
        SET errormessage = CONCAT("The price for this ", new.productCode, " should not be below 80% and above 100% of its MSRP: ", getMSRP(NEW.productCode));
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage; 
    END IF;
END $$
DELIMITER ;


DROP TRIGGER IF EXISTS orderdetails_AFTER_INSERT;
DELIMITER $$
CREATE TRIGGER `orderdetails_AFTER_INSERT` AFTER INSERT ON `orderdetails` FOR EACH ROW BEGIN
    -- Remove from the inventory the qty of the product ordered
	UPDATE current_products SET quantityInStock = quantityInStock - new.quantityOrdered WHERE productCode = new.productCode;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS orderdetails_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER `orderdetails_BEFORE_UPDATE` BEFORE UPDATE ON `orderdetails` FOR EACH ROW BEGIN
	DECLARE errormessage	VARCHAR(200);
    
    -- Check if the new quantity will cause the inventory to go below 0
    IF ((SELECT quantityInStock + old.quantityOrdered - new.quantityOrdered FROM current_products WHERE productCode = new.productCode) < 0) THEN
		SET errormessage = CONCAT("The quantity being ordered for ", new.productCode, " will make the inventory quantity go below zero");
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    -- Check if line number is being updated
    IF (new.orderlinenumber != old.orderlinenumber) THEN
		SET errormessage = "The line number cannot be updated";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

END $$
DELIMITER ;

DROP TRIGGER IF EXISTS orderdetails_AFTER_UPDATE;
DELIMITER $$
CREATE TRIGGER `orderdetails_AFTER_UPDATE` AFTER UPDATE ON `orderdetails` FOR EACH ROW BEGIN
    -- Adjust inventory based on the difference in quantity ordered
	UPDATE current_products SET quantityInStock = quantityInStock + old.quantityOrdered - new.quantityOrdered WHERE productCode = new.productCode;
END $$
DELIMITER ;

-- Test Case 1: Valid Insert (Within Stock and MSRP Limits)
-- The quantityOrdered is less than or equal to the quantityInStock.
-- The priceEach is within the allowed range of MSRP (not less than 80% and not more than 200%).
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach)
-- VALUES (11011, 'S10_1678', 50, 95.70);

-- SELECT * FROM orderdetails
-- WHERE orderNumber = 11011
-- AND productCode = 'S10_1678';

-- Test Case 2: Validate Maximum and Minimum Price Constraints
-- Attempt to insert an order with price below 80% of MSRP
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach)
-- VALUES (11012, 'S10_1678', 10, 70.00); -- Assuming MSRP is 95.70, 80% of MSRP is 76.56

-- -- Attempt to insert an order with price above 200% of MSRP
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach)
-- VALUES (11013, 'S10_1678', 5, 220.00); -- Assuming MSRP is 95.70, 200% of MSRP is 191.40

-- Test Case 3: Validate Quantity Constraints
-- Attempt to insert an order with a quantity exceeding available stock
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach)
-- VALUES (11014, 'S10_1678', 8000, 90.00); -- Assuming quantityInStock for 'S10_1678' is 7933

