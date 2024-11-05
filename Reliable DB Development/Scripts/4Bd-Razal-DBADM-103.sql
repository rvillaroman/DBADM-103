-- Prevent modification of product category (wholesale or retail)

DROP TRIGGER IF EXISTS products_BEFORE_UPDATE;
DELIMITER $$
CREATE TRIGGER `products_BEFORE_UPDATE` BEFORE UPDATE ON `products` FOR EACH ROW 
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Check if the product category is being modified
    IF old.product_category <> new.product_category THEN
        SET errormessage = CONCAT("Product category cannot be modified from ", old.product_category, " to ", new.product_category, ".");
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

END $$
DELIMITER ;