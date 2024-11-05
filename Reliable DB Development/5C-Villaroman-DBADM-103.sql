-- Villaroman, Raphael Luis G.
-- DBADM-103

DROP PROCEDURE IF EXISTS generate_turnaround_report;
DELIMITER $$
CREATE PROCEDURE generate_turnaround_report(IN report_year INT, IN report_month INT, IN user_name VARCHAR(255))
BEGIN
    DECLARE report_id INT;
    DECLARE errormessage VARCHAR(255);
    
    -- Insert new report metadata into reports_inventory
    INSERT INTO reports_inventory (reporttype, time_dimension_year, time_dimension_month, generated_by, reportdesc, generated_at)
    VALUES ('Turnaround Time', report_year, report_month, user_name, CONCAT('Turnaround Time Report for ', report_year, '-', report_month), NOW());
    
    -- Get the newly generated report_id
    SET report_id = LAST_INSERT_ID();
    
    -- Insert turnaround time data into turnaround_time_report
    INSERT INTO turnaround_time_report (report_id, report_year, report_month, country, office_code, average_turnaround_days)
    SELECT 
        report_id,
        report_year,
        report_month,
        ofc.country,
        ofc.officeCode,
        ROUND(AVG(TIMESTAMPDIFF(DAY, o.orderDate, o.shippedDate)), 2) AS average_turnaround_days
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    JOIN customers c ON o.customerNumber = c.customerNumber
    JOIN salesrepassignments sa ON c.salesRepEmployeeNumber = sa.employeeNumber
    JOIN offices ofc ON sa.officeCode = ofc.officeCode
    WHERE o.status IN ('Shipped', 'Completed')
      AND YEAR(o.orderDate) = report_year
      AND MONTH(o.orderDate) = report_month
    GROUP BY ofc.country, ofc.officeCode;
    
END $$
DELIMITER ;

-- Create or replace the event to generate Turnaround Time report monthly
DROP EVENT IF EXISTS event_generate_turnaround_report;
DELIMITER $$
CREATE EVENT event_generate_turnaround_report
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-11-30 23:59:59'
DO
BEGIN
    CALL generate_turnaround_report(YEAR(NOW()), MONTH(NOW()), 'System-Generated');
END $$
DELIMITER ;
