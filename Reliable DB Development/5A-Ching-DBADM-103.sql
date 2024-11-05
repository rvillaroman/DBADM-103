-- 1. Create a Report table to store the report

DROP TABLE IF EXISTS sales_reports;
CREATE TABLE sales_reports (
	reportid		INT(10),
	reportyear		INT(4),
    reportmonth 	INT(2),
    reportday		INT(2),
    product_line	VARCHAR(50),
    product_code	VARCHAR(15),
    country			VARCHAR(50),
    office_code		VARCHAR (10),
    sales_rep		INT(10),
    sales			DECIMAL(9,2),
    discount		DECIMAL(9,2),
    markup			DECIMAL(9,2),
    
    PRIMARY KEY (reportid, reportyear, reportmonth, reportday, product_line, sales_rep, product_code)
);

-- 2. Create a Stored Procedure that we can call to generate the report

DROP PROCEDURE IF EXISTS generate_salesreport;
DELIMITER $$
CREATE PROCEDURE generate_salesreport (param_year INT(4), param_month INT(2), param_generatedby VARCHAR(100)) 
BEGIN
	DECLARE report_description	VARCHAR(100);
    DECLARE v_reportid			INT(10);
    SET report_description = CONCAT('Sales Report for the Month of ', param_month, ' and year ', param_year);
    INSERT INTO reports_inventory (generationdate, generatedby, reportdesc) VALUES (NOW(), param_generatedby, report_description);
	SELECT MAX(reportid) INTO v_reportid FROM reports_inventory;
    
	INSERT INTO sales_reports 
		SELECT		v_reportid,
					YEAR(orderdate)		as reportyear, 
					MONTH(orderdate)	as reportmonth, 
					DAY(orderdate)		as reportday,
					ROUND(SUM(od.priceEach*od.quantityOrdered),2)	as SALES
		FROM		orders o JOIN orderdetails od ON o.orderNumber=od.orderNumber 
		JOIN 		productlines JOIN offices JOIN salesrepresentatives JOIN customers
		WHERE		o.status IN ('Shipped', 'Completed')
		AND			YEAR(orderdate)  = param_year
		AND			MONTH(orderdate) = param_month
		GROUP BY	YEAR(orderdate), MONTH(orderdate), DAY(orderdate);
END $$
DELIMITER ;

SHOW PROCESSLIST;
SHOW EVENTS;