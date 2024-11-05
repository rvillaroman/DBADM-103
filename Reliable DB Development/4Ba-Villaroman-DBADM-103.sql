-- ITDBADM-103
-- VILLAROMAN, RAPHAEL LUIS

-- 4B.A
-- Products in Inventory records are kept organized at any given time. 
-- When products are created, it is necessary that it is automatically categorized as current products 
-- and its product category be defined as either product for wholesale or for retail. 	
-- Provided with these definitions, their respective MSRPs must be defined.
-- The creation of relevant records should automatically be done by the system such that only the product information 
-- (including the primary product line is classified under) is provided.

-- TO DO:
-- 1. Modify the products table to support R/W classification
-- 2. Automatically categorize a product as retail or wholesale based on product type
-- 3. Insert product information into the current_products table after product creation if the product is current (product_category = 'C')
-- 4. If the product is retail (product_type = 'R'):
--    a. Insert productCode into product_retail
--    b. Insert productCode and MSRP into product_pricing
-- 5. If the product is wholesale (product_type = 'W')
--    a. Insert productCode and MSRP into product_wholesale


-- INITIAL: Modify the products table to include product_type
ALTER TABLE products
ADD COLUMN product_type ENUM('R', 'W') DEFAULT NULL;

-- After a product is added...
DROP TRIGGER IF EXISTS after_product_insert;
DELIMITER $$
CREATE TRIGGER after_product_insert
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    -- Insert into current_products
    IF NEW.product_category = 'C' THEN
        INSERT INTO current_products (productCode, product_type, quantityInStock)
        VALUES (NEW.productCode, NEW.product_type, 100);  -- Default stock set to 100

        -- Insert into product_retail or product_wholesale based on product_type
        IF NEW.product_type = 'R' THEN
            -- Insert into product_retail
            INSERT INTO product_retail (productCode)
            VALUES (NEW.productCode);

            -- Insert MSRP into product_pricing for retail products
            INSERT INTO product_pricing (productCode, startdate, enddate, MSRP)
            VALUES (NEW.productCode, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 YEAR), 100.00);  -- Default MSRP for retail
        ELSEIF NEW.product_type = 'W' THEN
            -- or into product_wholesale with MSRP for wholesale products
            INSERT INTO product_wholesale (productCode, MSRP)
            VALUES (NEW.productCode, 150.00);  -- Default MSRP for wholesale
        END IF;
    END IF;
END$$
DELIMITER ;


-- For testing

-- Retail product test
-- INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
-- VALUES ('S10_010', 'Retail Test', '1:10', 'Test Vendor', 'Sample retail product', 60.00, 'C', 'R');

-- Wholesale product test
-- INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
-- VALUES ('S10_011', 'Wholesale Test', '1:10', 'Test Vendor', 'Sample wholesale product', 60.00, 'C', 'W');

