-- ITDBADM-103
-- VILLAROMAN, RAPHAEL LUIS

-- 4B.C
-- Product MSRPs should be retrieved from the system without the need for the relevant records to be exposed to any users. 
-- This will alleviate the need to go through several records just to retrieve the appropriate MSRP for a specific product.

-- TO DO:
-- Check if a product is classified as retail or wholesale
-- If retail, it retrieves the MSRP from the product_pricing table
-- If wholesale, it retrieves the MSRP from the product_wholesale table
-- Check retail first; if it does not exist, check wholesale next
-- Throw an error if it is not found in either

DROP FUNCTION IF EXISTS getProductMSRP;
DELIMITER $$
CREATE FUNCTION getProductMSRP(param_productCode VARCHAR(15)) 
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE var_MSRP DECIMAL(9,2);
    DECLARE errormessage VARCHAR(200);

    -- First, check if the product is retail
    IF EXISTS (SELECT 1 FROM product_retail WHERE productCode = param_productCode) THEN
        -- Retail product found, get MSRP from product_pricing
        SELECT MSRP INTO var_MSRP
        FROM product_pricing
        WHERE productCode = param_productCode
          AND CURDATE() BETWEEN startdate AND enddate;
          
        -- If MSRP is found for retail, return it
        IF var_MSRP IS NOT NULL THEN
            RETURN var_MSRP;
        END IF;
    END IF;

    -- If no valid MSRP for retail, check if the product is wholesale
    IF EXISTS (SELECT 1 FROM product_wholesale WHERE productCode = param_productCode) THEN
        -- Wholesale product found, get MSRP from product_wholesale
        SELECT MSRP INTO var_MSRP
        FROM product_wholesale
        WHERE productCode = param_productCode;
        
        -- If MSRP is found for wholesale, return it
        IF var_MSRP IS NOT NULL THEN
            RETURN var_MSRP;
        END IF;
    END IF;

    -- If the product is found in neither retail nor wholesale
    SET errormessage := "Product not found";
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;

END$$
DELIMITER ;

-- Checking
-- SELECT getProductMSRP('S10_1678'); -- retail
-- SELECT getProductMSRP('S10_9999'); -- invalid



