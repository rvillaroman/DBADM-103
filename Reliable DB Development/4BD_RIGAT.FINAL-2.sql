-- 4b.d 
-- Product categories cannot be modified. 
-- Ridz Rigat

DROP TRIGGER IF EXISTS current_products_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER `current_products_BEFORE_UPDATE` BEFORE UPDATE ON `current_products` FOR EACH ROW BEGIN
	DECLARE errormessage	VARCHAR(200);
    
    IF (OLD.product_type != NEW.product_type) THEN
		SET errormessage = "Product categories cannot be modified. Wholesale products cannot become retail and vice versa.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
	END IF;
    
END $$
DELIMITER ;