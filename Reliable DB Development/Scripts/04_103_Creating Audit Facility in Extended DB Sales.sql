
-- Audit Tables and Automatic Population Script
-- Extended DB Sales
-- This script will create Audit Tables and triggers to automatically 
-- populate the audit tables as data activities happen on tables

DROP TABLE IF EXISTS audit_products;
CREATE TABLE audit_products (
  activity 					enum('C','U','D') 	DEFAULT NULL,
  activity_timestamp		datetime 			NOT NULL,
  productCode 				varchar(15) 		NOT NULL,
  old_productname 			varchar(70) 		DEFAULT NULL,
  old_productscale 			varchar(10) 		DEFAULT NULL,
  old_vendor 				varchar(50) 		DEFAULT NULL,
  old_productdescription 	text,
  old_buyprice 				double 				DEFAULT NULL,
  old_productcategory 		enum('C','D')		DEFAULT NULL,
  new_productname 			varchar(70) 		DEFAULT NULL,
  new_productscale 			varchar(10) 		DEFAULT NULL,
  new_vendor 				varchar(50) 		DEFAULT NULL,
  new_productdescription 	text,
  new_buyprice 				double 				DEFAULT NULL,
  new_productcategory 		enum('C','D')		DEFAULT NULL,
  dbuser 					varchar(45)	 		DEFAULT NULL,
  latest_audituser 			varchar(45) 		DEFAULT NULL,
  latest_authorizinguser	varchar(45) 		DEFAULT NULL,
  latest_activityreason	 	varchar(45) 		DEFAULT NULL,
  latest_activitymethod 	enum('W','M','D') 	DEFAULT NULL,
  PRIMARY KEY (productCode,activity_timestamp)
);

ALTER TABLE products
  ADD COLUMN latest_audituser 			varchar(45) DEFAULT NULL,
  ADD COLUMN latest_authorizinguser 	varchar(45) DEFAULT NULL,
  ADD COLUMN latest_activityreason 		varchar(45) DEFAULT NULL,
  ADD COLUMN latest_activitymethod 		enum('W','M','D') DEFAULT NULL;
  
DROP TRIGGER IF EXISTS products_AFTER_INSERT;
DELIMITER $$
CREATE	TRIGGER products_AFTER_INSERT AFTER INSERT ON products FOR EACH ROW BEGIN
	INSERT INTO audit_products VALUES
		('C', NOW(), new.productCode, NULL, NULL, NULL, NULL, NULL, NULL,
		  new.productName, new.productScale, new.productVendor, 
          new.productDescription, new.buyPrice, new.product_category,
          USER(), 
          new.latest_audituser, new.latest_authorizinguser,
          new.latest_activityreason, new.latest_activitymethod);
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS products_AFTER_UPDATE;
DELIMITER $$
CREATE TRIGGER products_AFTER_UPDATE AFTER UPDATE ON products FOR EACH ROW BEGIN
	INSERT INTO audit_products VALUES
		('U', NOW(), new.productCode, 
		  old.productName, old.productScale, old.productVendor, 
          old.productDescription, old.buyPrice, old.product_category,
		  new.productName, new.productScale, new.productVendor, 
          new.productDescription, new.buyPrice, new.product_category,
          USER(), new.latest_audituser, new.latest_authorizinguser,
          new.latest_activityreason, new.latest_activitymethod);
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS products_BEFORE_DELETE;
DELIMITER $$
CREATE TRIGGER products_BEFORE_DELETE BEFORE DELETE ON products FOR EACH ROW BEGIN
	INSERT INTO audit_products VALUES
		('D', NOW(), old.productCode, NULL, NULL, NULL, NULL, NULL, NULL,
		  old.productName, old.productScale, old.productVendor, 
          old.productDescription, old.buyPrice, old.product_category,
          USER(), NULL, NULL, NULL, NULL);
END $$
DELIMITER ;

