-- ITDBADM-103
-- Villaroman, Ching, Rigat, Razal

USE `dbsalesv2.1`;

DROP USER IF EXISTS 'salesmodule';
DROP USER IF EXISTS 'inventorymodule';
DROP USER IF EXISTS 'customermodule';
DROP USER IF EXISTS 'employeemodule';
DROP USER IF EXISTS 'paymentmodule';
DROP USER IF EXISTS 'systemmodule';

CREATE USER 'salesmodule' 		IDENTIFIED BY 'DLSU1234!';
CREATE USER 'inventorymodule' 	IDENTIFIED BY 'DLSU1234!';
CREATE USER 'customermodule'    IDENTIFIED BY 'DLSU1234!';
CREATE USER 'employeemodule'	IDENTIFIED BY 'DLSU1234!';
CREATE USER 'paymentmodule'		IDENTIFIED BY 'DLSU1234!';
CREATE USER 'systemmodule'		IDENTIFIED BY 'DLSU1234!';

-- sales module
GRANT SELECT                         ON check_payments           TO 'salesmodule';
GRANT SELECT                         ON couriers                 TO 'salesmodule';
GRANT SELECT                         ON credit_payments          TO 'salesmodule';
GRANT SELECT, UPDATE                 ON current_products         TO 'salesmodule';
GRANT SELECT                         ON customers                TO 'salesmodule';
GRANT SELECT                         ON discontinued_products    TO 'salesmodule';
GRANT SELECT                         ON employees                TO 'salesmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON orderdetails             TO 'salesmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON orders                   TO 'salesmodule';
GRANT SELECT                         ON payment_orders           TO 'salesmodule';
GRANT SELECT                         ON payments                 TO 'salesmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON product_pricing          TO 'salesmodule';
GRANT SELECT                         ON product_productlines     TO 'salesmodule';
GRANT SELECT                         ON product_retail           TO 'salesmodule';
GRANT SELECT, UPDATE                 ON product_wholesale        TO 'salesmodule';
GRANT SELECT                         ON productlines             TO 'salesmodule';
GRANT SELECT                         ON products                 TO 'salesmodule';
GRANT SELECT                         ON ref_shipmentstatus       TO 'salesmodule';
GRANT SELECT                         ON riders                   TO 'salesmodule';
GRANT SELECT                         ON sales_managers           TO 'salesmodule';
GRANT SELECT                         ON salesrepassignments      TO 'salesmodule';
GRANT SELECT                         ON salesrepresentatives     TO 'salesmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON shipments                TO 'salesmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON shipmentstatus           TO 'salesmodule';


-- inventory module
GRANT SELECT, INSERT, UPDATE, DELETE ON current_products         TO 'inventorymodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON discontinued_products    TO 'inventorymodule';
GRANT SELECT                         ON employees                TO 'inventorymodule';
GRANT SELECT                         ON inventory_managers       TO 'inventorymodule';
GRANT SELECT                         ON non_salesrepresentatives TO 'inventorymodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON product_productlines     TO 'inventorymodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON product_retail           TO 'inventorymodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON product_wholesale        TO 'inventorymodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON productlines             TO 'inventorymodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON products                 TO 'inventorymodule';

-- payment module
GRANT SELECT, INSERT, UPDATE, DELETE ON banks                    TO 'paymentmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON check_payments           TO 'paymentmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON credit_payments          TO 'paymentmodule';
GRANT SELECT                         ON current_products         TO 'paymentmodule';
GRANT SELECT                         ON customers                TO 'paymentmodule';
GRANT SELECT                         ON employees                TO 'paymentmodule';
GRANT SELECT                         ON non_salesrepresentatives TO 'paymentmodule';
GRANT SELECT                         ON orderdetails          	 TO 'paymentmodule';
GRANT SELECT                         ON orders                 	 TO 'paymentmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON payment_orders           TO 'paymentmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON payments                 TO 'paymentmodule';
GRANT SELECT                         ON product_pricing        	 TO 'paymentmodule';
GRANT SELECT                         ON product_retail         	 TO 'paymentmodule';
GRANT SELECT                         ON product_wholesale      	 TO 'paymentmodule';
GRANT SELECT                         ON products               	 TO 'paymentmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON ref_checkno              TO 'paymentmodule';
GRANT SELECT                         ON ref_paymentreferenceno 	 TO 'paymentmodule';

-- customer module
GRANT SELECT, INSERT, UPDATE, DELETE ON customers             	 TO 'customermodule';
GRANT SELECT                         ON employees             	 TO 'customermodule';
GRANT SELECT                         ON orderdetails          	 TO 'customermodule';
GRANT SELECT                         ON orders                	 TO 'customermodule';
GRANT SELECT                         ON salesrepassignments   	 TO 'customermodule';
GRANT SELECT                         ON salesrepresentatives  	 TO 'customermodule';

-- employee module
GRANT SELECT, INSERT, UPDATE, DELETE ON employees             	 TO 'employeemodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON inventory_managers    	 TO 'employeemodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON non_salesrepresentatives TO 'employeemodule';
GRANT SELECT                         ON offices              	 TO 'employeemodule';
GRANT SELECT                         ON orderdetails          	 TO 'employeemodule';
GRANT SELECT                         ON orders               	 TO 'employeemodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON sales_managers       	 TO 'employeemodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON salesrepassignments  	 TO 'employeemodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON salesrepresentatives 	 TO 'employeemodule';

-- system module
GRANT SELECT, INSERT, UPDATE, DELETE ON couriers             	 TO 'systemmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON departments          	 TO 'systemmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON offices              	 TO 'systemmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON ref_paymentreferenceno 	 TO 'systemmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON ref_shipmentstatus   	 TO 'systemmodule';
GRANT SELECT, INSERT, UPDATE, DELETE ON riders                	 TO 'systemmodule';
