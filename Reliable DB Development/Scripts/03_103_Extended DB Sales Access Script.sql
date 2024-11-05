
-- Data Access Script
-- Extended DB Sales
-- This script is to define the access privileges based on the CRUD Matrix

CREATE USER IF NOT EXISTS salesmodule 		IDENTIFIED BY 'DLSU1234!';
CREATE USER IF NOT EXISTS inventorymodule	IDENTIFIED BY 'DLSU1234!';
CREATE USER IF NOT EXISTS paymentmodule		IDENTIFIED BY 'DLSU1234!';
CREATE USER IF NOT EXISTS customermodule	IDENTIFIED BY 'DLSU1234!';
CREATE USER IF NOT EXISTS employeemodule	IDENTIFIED BY 'DLSU1234!';
CREATE USER IF NOT EXISTS systemmodule		IDENTIFIED BY 'DLSU1234!';

USE `dbsalesv2.0`;

GRANT	SELECT							ON	check_payments			TO	salesmodule;
GRANT	SELECT							ON	couriers				TO	salesmodule;
GRANT	SELECT							ON	credit_payments			TO	salesmodule;
GRANT	SELECT, UPDATE					ON	current_products		TO	salesmodule;
GRANT	SELECT							ON	customers				TO	salesmodule;
GRANT	SELECT							ON	discontinued_products	TO	salesmodule;
GRANT	SELECT							ON	employees				TO	salesmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT 	ON	orderdetails			TO 	salesmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	orders					TO	salesmodule;
GRANT	SELECT							ON 	payment_orders			TO	salesmodule;
GRANT	SELECT							ON 	payments				TO	salesmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	product_pricing			TO	salesmodule;
GRANT	SELECT							ON	product_productlines	TO	salesmodule;
GRANT	SELECT							ON	product_retail			TO	salesmodule;
GRANT	SELECT, UPDATE					ON	product_wholesale		TO	salesmodule;
GRANT	SELECT							ON	productlines			TO	salesmodule;
GRANT	SELECT							ON	products				TO	salesmodule;
GRANT	SELECT							ON	ref_shipmentstatus		TO	salesmodule;
GRANT	SELECT							ON 	riders					TO	salesmodule;
GRANT	SELECT							ON	sales_managers			TO	salesmodule;
GRANT	SELECT							ON	salesrepassignments		TO	salesmodule;
GRANT	SELECT							ON	salesrepresentatives	TO	salesmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	shipments				TO	salesmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	shipmentstatus			TO	salesmodule;

GRANT	SELECT, UPDATE, DELETE, INSERT	ON	current_products			TO	inventorymodule;
GRANT	SELECT							ON	discontinued_products		TO	inventorymodule;
GRANT	SELECT							ON	employees					TO	inventorymodule;
GRANT	SELECT							ON	inventory_managers			TO	inventorymodule;
GRANT	SELECT							ON	non_salesrepresentatives	TO	inventorymodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	product_productlines		TO	inventorymodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	product_retail				TO	inventorymodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	product_wholesale			TO	inventorymodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	productlines				TO	inventorymodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	products					TO	inventorymodule;

GRANT	SELECT, UPDATE, DELETE, INSERT	ON	banks						TO	paymentmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	check_payments				TO	paymentmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	credit_payments				TO	paymentmodule;
GRANT	SELECT							ON	current_products			TO	paymentmodule;
GRANT	SELECT							ON	customers					TO	paymentmodule;
GRANT	SELECT							ON	employees					TO	paymentmodule;
GRANT	SELECT							ON	non_salesrepresentatives	TO	paymentmodule;
GRANT	SELECT							ON	orderdetails				TO	paymentmodule;
GRANT	SELECT							ON	orders						TO	paymentmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	payment_orders				TO	paymentmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	payments					TO	paymentmodule;
GRANT	SELECT							ON	product_pricing				TO	paymentmodule;
GRANT	SELECT							ON	product_retail				TO	paymentmodule;
GRANT	SELECT							ON	product_wholesale			TO	paymentmodule;
GRANT	SELECT							ON	products					TO	paymentmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	ref_checkno					TO	paymentmodule;
GRANT	SELECT							ON	ref_paymentreferenceno		TO	paymentmodule;

GRANT	SELECT, UPDATE, DELETE, INSERT	ON	customers					TO	customermodule;
GRANT	SELECT							ON	employees					TO	customermodule;
GRANT	SELECT							ON	orderdetails				TO	customermodule;
GRANT	SELECT							ON	orders						TO	customermodule;
GRANT	SELECT							ON	salesrepassignments			TO	customermodule;
GRANT	SELECT							ON	salesrepresentatives		TO	customermodule;

GRANT	SELECT							ON	customers					TO	employeemodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	employees					TO	employeemodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	inventory_managers			TO	employeemodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	non_salesrepresentatives	TO	employeemodule;
GRANT	SELECT							ON	offices						TO	employeemodule;
GRANT	SELECT							ON	orderdetails				TO	employeemodule;
GRANT	SELECT							ON	orders						TO	employeemodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	sales_managers				TO	employeemodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	salesrepassignments			TO	employeemodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	salesrepresentatives		TO	employeemodule;

GRANT	SELECT, UPDATE, DELETE, INSERT	ON	couriers					TO	systemmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	departments					TO	systemmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	offices						TO	systemmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	ref_paymentreferenceno		TO	systemmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	ref_shipmentstatus			TO	systemmodule;
GRANT	SELECT, UPDATE, DELETE, INSERT	ON	riders						TO	systemmodule;






























