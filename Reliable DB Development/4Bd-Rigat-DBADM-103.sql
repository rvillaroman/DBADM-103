-- 4b.d 
-- Product categories cannot be modified. 
-- Ridz Rigat

DROP TRIGGER IF EXISTS 4BD_current_products_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER `4BD_current_products_BEFORE_UPDATE` BEFORE UPDATE ON `current_products` FOR EACH ROW BEGIN
	DECLARE errormessage	VARCHAR(200);
    
    IF (OLD.product_type != NEW.product_type) THEN
		SET errormessage = "Product categories cannot be modified. Wholesale products cannot become retail and vice versa.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
	END IF;
    
END $$
DELIMITER ;


-- should not update since you cannot go modify product categories.
UPDATE current_products
SET product_type = 'W'
WHERE productCode = 'S10_1678'; 

-- should not update since you cannot go modify product categories.
UPDATE current_products
SET product_type = 'W'
WHERE productCode = 'S10_1949'; 

-- should work but no changes since the product_type is already set to 'R'
UPDATE current_products
SET product_type = 'R'
WHERE productCode = 'S10_1949'; 

-- should work since the trigger is in the update only
INSERT INTO products(productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, latest_audituser, latest_authorizinguser, latest_activityreason, latest_activitymethod)
VALUES('S10_0001', 'ridznew', '1:712', 'ridztest2', 'testdesc', 33.21, 'C',  NULL, NULL, NULL, NULL);

INSERT INTO current_products (productCode, product_type, quantityInStock)
VALUES ('S10_0001', 'W', 1000);

-- should not update since you cannot modify product categories 
UPDATE current_products
SET product_type = 'R'
WHERE productCode = 'S10_0001'; 
