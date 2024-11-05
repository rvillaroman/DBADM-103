
-- Data Migration Script
-- Extended DB Sales
-- This script is to migrate the data from the old dbSales to the new dbSales Database

-- Migrate Offices Data

INSERT INTO `dbsalesv2.0`.offices (officecode, city, phone, addressline1, addressline2, state, country, postalcode, territory)
	SELECT 	officecode, city, phone, addressline1, addressline2, state, country, postalcode, territory 
    FROM   `dbsales`.offices;
    
-- Migrate ProductLines Data

INSERT INTO `dbsalesv2.0`.productlines (productline, textdescription, htmldescription, image)
	SELECT 	productline, textdescription, htmldescription, image
    FROM	`dbsales`.productlines;
    
-- Migrate Products Data

INSERT INTO `dbsalesv2.0`.products (productcode, productname, productscale, productvendor, productdescription, buyprice, product_category)
	SELECT	productcode, productname, productscale, productvendor, productdescription, buyprice, 'C'
    FROM	`dbsales`.products;
    
INSERT INTO `dbsalesv2.0`.product_productlines (productcode, productline)
	SELECT	productcode, productline
    FROM	`dbsales`.products;
    
INSERT INTO `dbsalesv2.0`.current_products (productcode, product_type, quantityinstock)
	SELECT	productcode, 'R', quantityInStock
    FROM	`dbsales`.products;
    
INSERT INTO `dbsalesv2.0`.product_retail (productcode)
	SELECT	productcode
    FROM    `dbsalesv2.0`.current_products;
    
INSERT INTO `dbsalesv2.0`.product_pricing (productcode, startdate, enddate, MSRP)
	SELECT	productcode, NOW(), DATE_ADD(NOW(), INTERVAL 4 MONTH), MSRP
    FROM	`dbsales`.products;

-- Migrate Employees Data

INSERT INTO `dbsalesv2.0`.employees (employeenumber, lastname, firstname, extension, email, jobtitle, employee_type)
	SELECT employeenumber, lastname, firstname, extension, email, jobtitle, NULL
    FROM	`dbsales`.employees;
    
UPDATE `dbsalesv2.0`.employees SET employee_type = 'N' WHERE jobtitle != 'Sales Rep';
UPDATE `dbsalesv2.0`.employees SET employee_type = 'S' WHERE jobtitle = 'Sales Rep';

INSERT INTO `dbsalesv2.0`.non_salesrepresentatives (employeenumber, deptcode)
	SELECT 	employeenumber, NULL
    FROM	`dbsalesv2.0`.employees
    WHERE	employee_type = 'N';

INSERT INTO `dbsalesv2.0`.salesrepresentatives (employeenumber)
	SELECT 	employeenumber
    FROM	`dbsalesv2.0`.employees
    WHERE	employee_type = 'S';

INSERT INTO `dbsalesv2.0`.sales_managers (employeenumber)
	SELECT 	employeenumber
    FROM	`dbsalesv2.0`.employees
    WHERE	jobtitle LIKE '%Sales Manager%' OR jobtitle LIKE '%Sale Manager%';

INSERT INTO `dbsalesv2.0`.salesrepassignments (employeenumber, officecode, startdate, enddate, reason, quota, salesmanagernumber)
	SELECT 	s.employeenumber, (	SELECT e1.officecode
								FROM   `dbsales`.employees e1
                                WHERE  e1.employeenumber = s.employeenumber
							  ), 
			NOW(), DATE_ADD(NOW(), INTERVAL 14 DAY), 'Migration',0.00, (	SELECT e2.reportsto
																			FROM   `dbsales`.employees e2
																			WHERE  e2.employeenumber = s.employeenumber
																		)
    FROM	`dbsalesv2.0`.salesrepresentatives s;

-- Create Department

INSERT INTO `dbsalesv2.0`.departments (deptcode, deptname, deptmanagernumber)
	VALUES (8001, 'Administrative Department', 1002);
    
UPDATE `dbsalesv2.0`.non_salesrepresentatives SET deptcode=8001;

-- Migrate Customers

	INSERT INTO `dbsalesv2.0`.customers (customernumber, customername, contactlastname, contactfirstname, phone, addressline1, addressline2, 
 	 								     city, state, postalcode, country, salesrepemployeenumber, creditlimit, officecode, startdate)
    SELECT 	 c.customernumber, c.customername, c.contactlastname, c.contactfirstname, 
			 c.phone, c.addressline1, c.addressline2, c.city, c.state, c.postalcode, c.country,
			 sra.employeeNumber, c.creditlimit, sra.officeCode, sra.startDate	
    FROM	`dbsales`.customers c	LEFT JOIN	`dbsalesv2.0`.salesrepassignments sra
										  ON	c.salesrepemployeenumber = sra.employeenumber;

-- Migrate Payments

INSERT INTO `dbsalesv2.0`.payments (customernumber, paymenttimestamp, paymenttype)
	SELECT	customernumber, paymentdate, 'S'
    FROM	`dbsales`.payments;

DROP FUNCTION IF EXISTS ISNUMERIC;
CREATE FUNCTION ISNUMERIC(val varchar(1024))
RETURNS TINYINT(1) 
DETERMINISTIC
RETURN val REGEXP '^(-|\\+)?([0-9]+\\.[0-9]*|[0-9]*\\.[0-9]+|[0-9]+)$';

DROP FUNCTION IF EXISTS NumericOnly;
DELIMITER $$
CREATE FUNCTION NumericOnly (val VARCHAR(255)) 
 RETURNS VARCHAR(255)
 DETERMINISTIC
BEGIN
 DECLARE idx INT DEFAULT 0;
 IF ISNULL(val) THEN RETURN NULL; END IF;

 IF LENGTH(val) = 0 THEN RETURN ""; END IF;

 SET idx = LENGTH(val);
  WHILE idx > 0 DO
    IF ISNUMERIC(SUBSTRING(val,idx,1)) = 0 THEN
     SET val = REPLACE(val,SUBSTRING(val,idx,1),"");
    END IF;
    SET idx = idx - 1;
  END WHILE;
  RETURN val;
 END; $$
 DELIMITER ;
    
INSERT INTO `dbsalesv2.0`.ref_checkno (checkno, bank)
SELECT	 	`dbsalesv2.0`.NumericOnly(checknumber), NULL
    FROM	`dbsales`.payments;	
    
INSERT INTO `dbsalesv2.0`.check_payments (customernumber, paymenttimestamp, checkno)
	SELECT	customernumber, paymentdate, NumericOnly(checknumber)
    FROM	`dbsales`.payments;
    
-- Migrate Orders
INSERT INTO `dbsalesv2.0`.orders 
	SELECT * FROM `dbsales`.orders;
    
INSERT INTO `dbsalesv2.0`.orderdetails
	SELECT *, NULL FROM `dbsales`.orderdetails;
    
    