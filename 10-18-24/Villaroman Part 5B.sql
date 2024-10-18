DROP TABLE IF EXISTS quantity_ordered_report;
CREATE TABLE quantity_ordered_report (
reportid 		INT(10),
report_year 	INT(4),
report_month 	INT(2),
productLine 	VARCHAR(50),
productCode 	VARCHAR(50),
productName 	VARCHAR(100),
country			VARCHAR(50),
office			VARCHAR(50),
salesRep		VARCHAR(100),
total_quantity	INT,
PRIMARY KEY (reportid, productCode, report_year, report_month)
);


DROP PROCEDURE IF EXISTS generate_quantity_ordered_report;
DELIMITER $$
CREATE PROCEDURE generate_quantity_ordered_report (param_year INT(4), param_month INT(2), param_generatedby VARCHAR(100))
BEGIN
	DECLARE report_description VARCHAR(100);
    DECLARE v_reportid INT(10);
    SET 	report_description = CONCAT('Quantity Ordered Report for the Month of ', param_month,' and year ', param_year);
    
    -- report generation details
    INSERT INTO reports_inventory (generationdate, generatedby, reportdesc, reporttype, time_dimension_year, time_dimension_month)
	VALUES 						  (NOW(), param_generatedby, report_description, 'Quantity Ordered', param_year, param_month);
    SELECT 	MAX(reportid) 
    INTO 	v_reportid
    FROM 	reports_inventory;
    
    -- report generation
    INSERT INTO quantity_ordered_report
		SELECT v_reportid,
		YEAR(o.orderDate) 			AS report_year,
		MONTH(o.orderDate) 			AS report_month,
		p.productLine, p.productCode, p.productName,
		sr.employeeNumber 			AS salesRepEmployeeNumber,
		SUM(od.quantityOrdered)		AS total_quantity
        
        FROM orders o 
        JOIN orderdetails od 		 ON o.orderNumber  = od.orderNumber
        JOIN products p 			 ON p.productCode  = od.productCode
        JOIN salesrepassignments sra ON sr.officeCode  = o.office
        
        WHERE YEAR(o.orderDate) = param_year 
		AND	  MONTH(o.orderDate) = param_month
        GROUP BY p.productLine, p.productCode, p.productName, sr.employeeNumber, o.country, o.office;
        
END $$
DELIMITER ;

DELIMITER $$
CREATE EVENT event_generate_quantity_ordered_report
ON SCHEDULE EVERY 10 SECOND
STARTS CURRENT_TIMESTAMP
DO
BEGIN
	CALL generate_quantity_ordered_report(YEAR(NOW()), MONTH(NOW()), "System-Generated");
END $$
DELIMITER ;