ALTER TABLE Products ADD isAvailable TINYINT(1) DEFAULT 1;

DROP TRIGGER IF EXISTS products_BEFORE_UPDATE;
DELIMITER $$

CREATE TRIGGER products_BEFORE_UPDATE 
BEFORE UPDATE ON products 
FOR EACH ROW 
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Check if the product status (category) is being updated
    IF NEW.productCategory != OLD.productCategory THEN

        -- Step 1: Ensure only inventory managers can change product status
        IF (SELECT role FROM Users WHERE username = USER()) != 'inventorymodule' THEN
            SET errormessage = 'Only Inventory Managers can discontinue or reactivate products.';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        END IF;

        -- Step 2: If the product is being discontinued
        IF NEW.productCategory = 'D' THEN
            -- Log the discontinuation event
            SET NEW.latest_activityreason = 'Product Discontinued by Inventory Manager';
            SET NEW.latest_activitymethod = 'System';  -- Automatically logged by the system
            
            -- Step 3: Mark product as unavailable for ordering
            UPDATE Products SET isAvailable = 0 WHERE productCode = NEW.productCode;

            -- (Any additional record processing can go here, e.g., marking the product as inactive in related tables)

        -- Step 4: If the product is being reactivated
        ELSEIF NEW.productCategory = 'C' THEN
            -- Log the reactivation event
            SET NEW.latest_activityreason = 'Product Reactivated by Inventory Manager';
            SET NEW.latest_activitymethod = 'System';  -- Automatically logged by the system

            -- Step 5: Mark product as available for ordering
            UPDATE Products SET isAvailable = 1 WHERE productCode = NEW.productCode;

            -- (Any additional record processing can go here, e.g., notifying sales team, updating stock)
        END IF;

    END IF;

END $$ 
DELIMITER ;