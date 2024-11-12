
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

DROP FUNCTION IF EXISTS isValidStatus;
DELIMITER $$
CREATE FUNCTION isValidStatus(param_oldstatus VARCHAR(15), param_newstatus VARCHAR(15)) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE errormessage		VARCHAR(200);
    
    IF (param_oldstatus = param_newstatus) THEN RETURN TRUE;
    END IF;
    
    -- Check if the value of the status is valid
    IF (NOT isStatusValid(param_oldstatus) OR NOT isStatusValid(param_newstatus)) THEN
		SET errormessage := CONCAT("Either ", param_oldstatus, " or ", param_newstatus, " is not a valid status");
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;	
    END IF;
        
    IF (param_oldstatus = "In Process") THEN
		IF (param_newstatus != "Shipped") THEN
			SET errormessage := CONCAT("Status from ", param_oldstatus, " to ", param_newstatus, " is not allowed");
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;		
        END IF;	
	ELSEIF (param_oldstatus = "Shipped") THEN
		IF (param_newstatus = "In Process") OR ( param_newstatus = "Resolved") THEN
			SET errormessage := CONCAT("Status from ", param_oldstatus, " to ", param_newstatus, " is not allowed");
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;		
        END IF;	
    END IF;
    
    -- Continue this for the other status checking
    
    RETURN TRUE;
END $$
DELIMITER ;

-- Testing of Functions
SELECT isValidStatus("In Process","In Process");




