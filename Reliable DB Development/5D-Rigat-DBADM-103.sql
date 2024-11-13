-- Report Generation
-- Pricing Variation REPORT#4 (refers to the eaverage percentage of increase or decrease in pricing of a product)

-- Ridz Rigat
-- ITDBADM_S16

-- new getMSRP
DROP FUNCTION IF EXISTS getMSRP_2;
DELIMITER $$
CREATE FUNCTION getMSRP_2 (param_productCode VARCHAR(15), param_origdate DATE) 
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
        WHERE	param_origdate BETWEEN startdate AND enddate
        AND		productCode = param_productCode;
        
        -- Check if the price was available
        IF (var_MSRP IS NULL) THEN
			SET errormessage := CONCAT("MSRP of the product does not exist yet given the date of ", param_origdate);
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

DROP TABLE IF EXISTS pricing_variation_report;
CREATE TABLE pricing_variation_report (
    report_id INT,                  
    productCode VARCHAR(15),       
    productLine VARCHAR(255),       
    current_MSRP DECIMAL(9,2),      
    priceEach DOUBLE,               
    variation_percentage DECIMAL(5,2), 
    report_year INT,                
    report_month INT,               
    PRIMARY KEY(report_id, productCode, report_year, report_month)
);

DROP PROCEDURE IF EXISTS generate_priceVariationReport;
DELIMITER $$
CREATE PROCEDURE generate_priceVariationReport (param_productCode VARCHAR(15), param_report_year INT, param_report_month INT)
BEGIN
    DECLARE report_id INT;

    INSERT INTO reports_inventory (generationdate, generatedby, reportdesc, reporttype, time_dimension_year, time_dimension_month) 
    VALUES (NOW(), 'System', 'Average percentage of pricing variation for the product', 'Pricing Variation', param_report_year, param_report_month);
    
    SET report_id = LAST_INSERT_ID();  

    
    INSERT INTO pricing_variation_report (report_id, productCode, productLine, current_MSRP, priceEach, variation_percentage, report_year, report_month)
    SELECT 	 report_id,
		 p.productCode,
       		 pp.productLine,
      		 getMSRP_2(p.productCode, o.orderdate) AS current_MSRP,
      	 	 od.priceEach,
        	 ROUND(((od.priceEach - getMSRP_2(p.productCode, o.orderdate)) / getMSRP_2(p.productCode, o.orderdate)) * 100, 2) AS variation_percentage,
        	 param_report_year AS report_year,
        	 param_report_month AS report_month
    FROM 
        	orders o
        	JOIN orderdetails od ON o.orderNumber = od.orderNumber
       	 	JOIN products p ON od.productCode = p.productCode
        	JOIN product_productlines pp ON p.productCode = pp.productCode
    WHERE 
       	 	p.productCode = param_productCode
        	AND YEAR(o.orderdate) = param_report_year
        	AND MONTH(o.orderdate) = param_report_month
        	AND o.status IN ('Shipped', 'Completed');

END $$
DELIMITER ;

-- Test the procedure
CALL generate_priceVariationReport('S10_2016', 2024, 10);  


DROP EVENT IF EXISTS event_generate_priceVariationReport;
DELIMITER $$
CREATE EVENT event_generate_priceVariationReport
ON SCHEDULE EVERY 10 SECOND
DO
BEGIN
	CALL generate_priceVariationReport('S10_1678', 2024, 9); 
END $$
DELIMITER ;

ALTER EVENT event_generate_priceVariationReport				DISABLE;
ALTER EVENT event_generate_priceVariationReport				ENABLE;

-- SHOW EVENTS;
