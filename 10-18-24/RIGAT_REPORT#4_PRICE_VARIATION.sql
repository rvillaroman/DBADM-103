-- Report Generation
-- Pricing Variation REPORT#4 (refers to the eaverage percentage of increase or decrease in pricing of a product)

-- Ridz Rigat
-- ITDBADM_S16


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
    PRIMARY KEY(report_id, productCode)
);

DROP PROCEDURE IF EXISTS generate_priceVariationReport;
DELIMITER $$
CREATE PROCEDURE generate_priceVariationReport (param_productCode VARCHAR(15), param_report_year INT, param_report_month INT)
BEGIN
    DECLARE report_id INT;

   
    INSERT INTO reports (report_name, report_type, created_by, report_description)
    VALUES ('Average Pricing Variation Report', 'Pricing Variation', 'System', 'Average percentage of pricing variation for the product');
    
    SET report_id = LAST_INSERT_ID();  

    
    INSERT INTO pricing_variation_report (report_id, productCode, productLine, current_MSRP, priceEach, variation_percentage, report_year, report_month)
    SELECT 		report_id,
				p.productCode,
				pl.productLine 	  AS productLine, -- Get the product line
				curr_pricing.MSRP AS current_MSRP,
				od.priceEach 	  AS priceEach,
				CASE 
					WHEN od.priceEach IS NOT NULL AND od.priceEach != 0 
					THEN ((curr_pricing.MSRP - od.priceEach) / od.priceEach) * 100 
					ELSE NULL 
				END AS variation_percentage,
				param_report_year AS report_year,   
				param_report_month AS report_month   
    FROM 		products p		JOIN product_pricing curr_pricing 	ON p.productCode = curr_pricing.productCode
								JOIN orderdetails od 				ON p.productCode = od.productCode
								JOIN product_productlines pl 		ON p.productCode = pl.productCode  
    WHERE 		p.productCode = param_productCode;

    
    SELECT 		AVG(variation_percentage) AS avg_variation_percentage
    FROM 		pricing_variation_report
    WHERE 		report_id = report_id;

END $$

DELIMITER ;

-- Test the procedure
CALL generate_priceVariationReport('S10_2016', 2024, 10);  


DROP EVENT IF EXISTS generate_priceVariationReport;
DELIMITER $$
CREATE EVENT generate_priceVariationReport
ON SCHEDULE EVERY 10 SECOND
DO
BEGIN
	CALL generate_priceVariationReport('S10_1678', 2024, 9); 
END $$
DELIMITER ;

ALTER EVENT generate_priceVariationReport 				DISABLE;
ALTER EVENT generate_priceVariationReport 				ENABLE;



 SHOW EVENTS;
 






