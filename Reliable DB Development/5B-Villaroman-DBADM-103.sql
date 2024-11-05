-- Villaroman, Raphael Luis G.
-- DBADM-103

DROP TABLE IF EXISTS quantity_ordered_report;
CREATE TABLE quantity_ordered_report (
    reportid INT(10),
    report_year INT(4),
    report_month INT(2),
    productLine VARCHAR(50),
    productCode VARCHAR(50),
    productName VARCHAR(100),
    country VARCHAR(50),
    office VARCHAR(50),
    salesRep VARCHAR(100),
    total_quantity INT,
    PRIMARY KEY (reportid , productCode , report_year , report_month)
);

DROP PROCEDURE IF EXISTS generate_quantity_ordered_report;
DELIMITER $$
CREATE PROCEDURE generate_quantity_ordered_report (param_year INT(4), param_month INT(2), param_generatedby VARCHAR(100))
BEGIN
    DECLARE report_description VARCHAR(100);
    DECLARE v_reportid INT(10);

    SET report_description = CONCAT('Quantity Ordered Report for the Month of ', param_month, ' and year ', param_year);

    -- Insert report generation details into reports_inventory
    INSERT INTO reports_inventory (generationdate, generatedby, reportdesc, reporttype, time_dimension_year, time_dimension_month)
    VALUES (NOW(), param_generatedby, report_description, 'Quantity Ordered', param_year, param_month);

    -- Get the generated report ID
SELECT 
    MAX(reportid)
INTO v_reportid FROM
    reports_inventory;

    -- Generate the quantity ordered report
    INSERT INTO quantity_ordered_report
    SELECT 
        v_reportid,
        param_year AS report_year,
        param_month AS report_month,
        pp.productLine,
        p.productCode,
        p.productName,
        ofc.country,
        ofc.city AS office,
        CONCAT(e.lastName, ', ', e.firstName) AS salesRep,
        SUM(od.quantityOrdered) AS total_quantity
    FROM 
        orders o
    JOIN orderdetails od 			ON o.orderNumber = od.orderNumber
    JOIN products p 				ON od.productCode = p.productCode
    JOIN product_productlines pp 	ON p.productCode = pp.productCode
    JOIN customers c 				ON o.customerNumber = c.customerNumber
    JOIN salesrepassignments sa 	ON c.salesRepEmployeeNumber = sa.employeeNumber
    JOIN offices ofc 				ON sa.officeCode = ofc.officeCode
    JOIN employees e 				ON sa.employeeNumber = e.employeeNumber
    WHERE 
        YEAR(o.orderDate) = param_year 
        AND MONTH(o.orderDate) = param_month
    GROUP BY 
        pp.productLine, p.productCode, p.productName, ofc.country, ofc.city, e.employeeNumber;

END $$
DELIMITER ;

-- Schedule the report generation event
DELIMITER $$
CREATE EVENT event_generate_quantity_ordered_report
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-11-30 23:59:59'
DO
BEGIN
    CALL generate_quantity_ordered_report(YEAR(NOW()), MONTH(NOW()), 'System-Generated');
END $$
DELIMITER ;
show events;
