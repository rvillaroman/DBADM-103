DROP TRIGGER IF EXISTS product_creation_classification;
DELIMITER $$


CREATE TRIGGER product_creation_classification
AFTER INSERT ON products
FOR EACH ROW
BEGIN

    DELETE FROM product_productlines WHERE productCode = NEW.productCode;


    INSERT INTO product_productlines (productCode, productLine)
    VALUES (NEW.productCode, 0); 
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS add_productline_classification;
DELIMITER $$

CREATE TRIGGER add_productline_classification
BEFORE INSERT ON product_productlines
FOR EACH ROW
BEGIN

    DELETE FROM product_productlines WHERE productCode = NEW.productCode AND productLine = NEW.productLine;


    IF (SELECT * FROM products WHERE productCode = NEW.productCode) IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot classify under new product line: Product does not exist';
    END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS delete_productline_classification;
DELIMITER $$

CREATE TRIGGER delete_productline_classification
BEFORE DELETE ON product_productlines
FOR EACH ROW
BEGIN

    IF (SELECT * FROM products WHERE productCode = OLD.productCode) IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete classification: product no longer exists';
    END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS remove_classifications_on_product_delete;
DELIMITER $$

CREATE TRIGGER remove_classifications_on_product_delete
AFTER DELETE ON products
FOR EACH ROW
BEGIN

    DELETE FROM product_productlines
    WHERE productCode = OLD.productCode;
END $$

DELIMITER ;
