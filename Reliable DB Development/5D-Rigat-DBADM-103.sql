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
