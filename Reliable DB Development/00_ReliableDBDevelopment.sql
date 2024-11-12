-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema dbsalesV2.0
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `dbsalesV2.0` ;

-- -----------------------------------------------------
-- Schema dbsalesV2.0
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbsalesV2.0` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `dbsalesV2.0` ;

-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`departments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`departments` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`departments` (
  `deptCode` INT NOT NULL,
  `deptName` VARCHAR(45) NULL DEFAULT NULL,
  `deptManagerNumber` INT NULL DEFAULT NULL,
  PRIMARY KEY (`deptCode`),
  INDEX `FK-84_001_idx` (`deptManagerNumber` ASC) VISIBLE,
  CONSTRAINT `FK-84_001`
    FOREIGN KEY (`deptManagerNumber`)
    REFERENCES `dbsalesV2.0`.`Non_SalesRepresentatives` (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`employees`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`employees` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`employees` (
  `employeeNumber` INT NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  `firstName` VARCHAR(50) NOT NULL,
  `extension` VARCHAR(10) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `jobTitle` VARCHAR(50) NOT NULL,
  `employee_type` ENUM('S', 'N') NULL DEFAULT NULL,
  PRIMARY KEY (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`Non_SalesRepresentatives`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`Non_SalesRepresentatives` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`Non_SalesRepresentatives` (
  `employeeNumber` INT NOT NULL,
  `deptCode` INT NULL DEFAULT NULL,
  PRIMARY KEY (`employeeNumber`),
  INDEX `FK-83_001_idx` (`deptCode` ASC) VISIBLE,
  CONSTRAINT `FK-83_001`
    FOREIGN KEY (`deptCode`)
    REFERENCES `dbsalesV2.0`.`departments` (`deptCode`),
  CONSTRAINT `FK-83_002`
    FOREIGN KEY (`employeeNumber`)
    REFERENCES `dbsalesV2.0`.`employees` (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`banks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`banks` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`banks` (
  `bank` INT NOT NULL,
  `bankname` VARCHAR(45) NULL DEFAULT NULL,
  `branch` VARCHAR(45) NULL DEFAULT NULL,
  `branchaddress` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`bank`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`salesRepresentatives`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`salesRepresentatives` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`salesRepresentatives` (
  `employeeNumber` INT NOT NULL,
  PRIMARY KEY (`employeeNumber`),
  CONSTRAINT `FK-86_001`
    FOREIGN KEY (`employeeNumber`)
    REFERENCES `dbsalesV2.0`.`employees` (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`offices`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`offices` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`offices` (
  `officeCode` VARCHAR(10) NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  `addressLine1` VARCHAR(50) NOT NULL,
  `addressLine2` VARCHAR(50) NULL DEFAULT NULL,
  `state` VARCHAR(50) NULL DEFAULT NULL,
  `country` VARCHAR(50) NOT NULL,
  `postalCode` VARCHAR(15) NOT NULL,
  `territory` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`officeCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`sales_managers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`sales_managers` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`sales_managers` (
  `employeeNumber` INT NOT NULL,
  PRIMARY KEY (`employeeNumber`),
  CONSTRAINT `FK-89_001`
    FOREIGN KEY (`employeeNumber`)
    REFERENCES `dbsalesV2.0`.`Non_SalesRepresentatives` (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`salesRepAssignments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`salesRepAssignments` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`salesRepAssignments` (
  `employeeNumber` INT NOT NULL,
  `officeCode` VARCHAR(10) NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` DATE NULL DEFAULT NULL,
  `reason` VARCHAR(45) NULL DEFAULT NULL,
  `quota` DECIMAL(9,2) NULL DEFAULT NULL,
  `salesManagerNumber` INT NULL DEFAULT NULL,
  PRIMARY KEY (`employeeNumber`, `officeCode`, `startDate`),
  INDEX `FK-88_002_idx` (`officeCode` ASC) VISIBLE,
  INDEX `FK-88_003_idx` (`salesManagerNumber` ASC) VISIBLE,
  CONSTRAINT `FK-88_001`
    FOREIGN KEY (`employeeNumber`)
    REFERENCES `dbsalesV2.0`.`salesRepresentatives` (`employeeNumber`),
  CONSTRAINT `FK-88_002`
    FOREIGN KEY (`officeCode`)
    REFERENCES `dbsalesV2.0`.`offices` (`officeCode`),
  CONSTRAINT `FK-88_003`
    FOREIGN KEY (`salesManagerNumber`)
    REFERENCES `dbsalesV2.0`.`sales_managers` (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`customers` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`customers` (
  `customerNumber` INT NOT NULL,
  `customerName` VARCHAR(50) NOT NULL,
  `contactLastName` VARCHAR(50) NOT NULL,
  `contactFirstName` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  `addressLine1` VARCHAR(50) NOT NULL,
  `addressLine2` VARCHAR(50) NULL DEFAULT NULL,
  `city` VARCHAR(50) NOT NULL,
  `state` VARCHAR(50) NULL DEFAULT NULL,
  `postalCode` VARCHAR(15) NULL DEFAULT NULL,
  `country` VARCHAR(50) NOT NULL,
  `salesRepEmployeeNumber` INT NULL DEFAULT NULL,
  `creditLimit` DOUBLE NULL DEFAULT NULL,
  `officeCode` VARCHAR(10) NULL,
  `startDate` DATE NULL,
  PRIMARY KEY (`customerNumber`),
  INDEX `FKX001_idx` (`salesRepEmployeeNumber` ASC, `officeCode` ASC, `startDate` ASC) VISIBLE,
  CONSTRAINT `FKX001`
    FOREIGN KEY (`salesRepEmployeeNumber` , `officeCode` , `startDate`)
    REFERENCES `dbsalesV2.0`.`salesRepAssignments` (`employeeNumber` , `officeCode` , `startDate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`payments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`payments` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`payments` (
  `customerNumber` INT NOT NULL,
  `paymentTimestamp` DATETIME NOT NULL,
  `paymentType` ENUM('S', 'H', 'C') NOT NULL,
  PRIMARY KEY (`customerNumber`, `paymentTimestamp`),
  CONSTRAINT `FK0007`
    FOREIGN KEY (`customerNumber`)
    REFERENCES `dbsalesV2.0`.`customers` (`customerNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`ref_checkno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`ref_checkno` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`ref_checkno` (
  `checkno` INT NOT NULL,
  `bank` INT NULL DEFAULT NULL,
  PRIMARY KEY (`checkno`),
  INDEX `FK-49_001_idx` (`bank` ASC) VISIBLE,
  CONSTRAINT `FK-49_001`
    FOREIGN KEY (`bank`)
    REFERENCES `dbsalesV2.0`.`banks` (`bank`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`check_payments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`check_payments` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`check_payments` (
  `customerNumber` INT NOT NULL,
  `paymentTimestamp` DATETIME NOT NULL,
  `checkno` INT NULL DEFAULT NULL,
  PRIMARY KEY (`customerNumber`, `paymentTimestamp`),
  INDEX `FK-31_002_idx` (`checkno` ASC) VISIBLE,
  CONSTRAINT `FK-31_001`
    FOREIGN KEY (`customerNumber` , `paymentTimestamp`)
    REFERENCES `dbsalesV2.0`.`payments` (`customerNumber` , `paymentTimestamp`),
  CONSTRAINT `FK-31_002`
    FOREIGN KEY (`checkno`)
    REFERENCES `dbsalesV2.0`.`ref_checkno` (`checkno`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`couriers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`couriers` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`couriers` (
  `courierName` VARCHAR(100) NOT NULL,
  `address` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`courierName`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`ref_paymentreferenceNo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`ref_paymentreferenceNo` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`ref_paymentreferenceNo` (
  `referenceNo` INT NOT NULL,
  `bank` INT NULL DEFAULT NULL,
  PRIMARY KEY (`referenceNo`),
  INDEX `FK-30_001_idx` (`bank` ASC) VISIBLE,
  CONSTRAINT `FK-30_001`
    FOREIGN KEY (`bank`)
    REFERENCES `dbsalesV2.0`.`banks` (`bank`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`credit_payments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`credit_payments` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`credit_payments` (
  `customerNumber` INT NOT NULL,
  `paymentTimestamp` DATETIME NOT NULL,
  `postingDate` DATE NULL DEFAULT NULL,
  `paymentReferenceNo` INT NULL DEFAULT NULL,
  PRIMARY KEY (`customerNumber`, `paymentTimestamp`),
  INDEX `FK-50_001_idx` (`paymentReferenceNo` ASC) VISIBLE,
  CONSTRAINT `FK-50_001`
    FOREIGN KEY (`paymentReferenceNo`)
    REFERENCES `dbsalesV2.0`.`ref_paymentreferenceNo` (`referenceNo`),
  CONSTRAINT `FK-50_002`
    FOREIGN KEY (`customerNumber` , `paymentTimestamp`)
    REFERENCES `dbsalesV2.0`.`payments` (`customerNumber` , `paymentTimestamp`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`products` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`products` (
  `productCode` VARCHAR(15) NOT NULL,
  `productName` VARCHAR(70) NOT NULL,
  `productScale` VARCHAR(10) NOT NULL,
  `productVendor` VARCHAR(50) NOT NULL,
  `productDescription` TEXT NOT NULL,
  `buyPrice` DOUBLE NOT NULL,
  `product_category` ENUM('C', 'D') NULL DEFAULT NULL,
  PRIMARY KEY (`productCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`current_products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`current_products` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`current_products` (
  `productCode` VARCHAR(15) NOT NULL,
  `product_type` ENUM('R', 'W') NULL DEFAULT NULL,
  `quantityInStock` SMALLINT NULL DEFAULT NULL,
  PRIMARY KEY (`productCode`),
  CONSTRAINT `FK90_001`
    FOREIGN KEY (`productCode`)
    REFERENCES `dbsalesV2.0`.`products` (`productCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`inventory_managers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`inventory_managers` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`inventory_managers` (
  `employeeNumber` INT NOT NULL,
  PRIMARY KEY (`employeeNumber`),
  CONSTRAINT `FK-92_001`
    FOREIGN KEY (`employeeNumber`)
    REFERENCES `dbsalesV2.0`.`Non_SalesRepresentatives` (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`discontinued_products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`discontinued_products` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`discontinued_products` (
  `productCode` VARCHAR(15) NOT NULL,
  `reason` VARCHAR(45) NULL DEFAULT NULL,
  `inventory_manager` INT NULL DEFAULT NULL,
  PRIMARY KEY (`productCode`),
  INDEX `FK-91_002_idx` (`inventory_manager` ASC) VISIBLE,
  CONSTRAINT `FK-91_001`
    FOREIGN KEY (`productCode`)
    REFERENCES `dbsalesV2.0`.`products` (`productCode`),
  CONSTRAINT `FK-91_002`
    FOREIGN KEY (`inventory_manager`)
    REFERENCES `dbsalesV2.0`.`inventory_managers` (`employeeNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`orders` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`orders` (
  `orderNumber` INT NOT NULL,
  `orderDate` DATETIME NOT NULL,
  `requiredDate` DATETIME NOT NULL,
  `shippedDate` DATETIME NULL DEFAULT NULL,
  `status` VARCHAR(15) NOT NULL,
  `comments` TEXT NULL DEFAULT NULL,
  `customerNumber` INT NULL DEFAULT NULL,
  PRIMARY KEY (`orderNumber`),
  INDEX `FK0002_idx` (`customerNumber` ASC) VISIBLE,
  CONSTRAINT `FK0002`
    FOREIGN KEY (`customerNumber`)
    REFERENCES `dbsalesV2.0`.`customers` (`customerNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`shipments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`shipments` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`shipments` (
  `referenceNo` INT NOT NULL,
  `courierName` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`referenceNo`),
  INDEX `FK-63_001_idx` (`courierName` ASC) VISIBLE,
  CONSTRAINT `FK-63_001`
    FOREIGN KEY (`courierName`)
    REFERENCES `dbsalesV2.0`.`couriers` (`courierName`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`orderdetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`orderdetails` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`orderdetails` (
  `orderNumber` INT NOT NULL,
  `productCode` VARCHAR(15) NOT NULL,
  `quantityOrdered` INT NOT NULL,
  `priceEach` DOUBLE NOT NULL,
  `orderLineNumber` SMALLINT NOT NULL,
  `referenceNo` INT NULL DEFAULT NULL,
  PRIMARY KEY (`orderNumber`, `productCode`),
  INDEX `FK0008_idx` (`productCode` ASC) VISIBLE,
  INDEX `FK1009_idx` (`referenceNo` ASC) VISIBLE,
  CONSTRAINT `FK0001`
    FOREIGN KEY (`orderNumber`)
    REFERENCES `dbsalesV2.0`.`orders` (`orderNumber`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `FK0008`
    FOREIGN KEY (`productCode`)
    REFERENCES `dbsalesV2.0`.`current_products` (`productCode`),
  CONSTRAINT `FK1009`
    FOREIGN KEY (`referenceNo`)
    REFERENCES `dbsalesV2.0`.`shipments` (`referenceNo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`payment_orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`payment_orders` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`payment_orders` (
  `customerNumber` INT NOT NULL,
  `paymentTimestamp` DATETIME NOT NULL,
  `orderNumber` INT NOT NULL,
  `amountpaid` DECIMAL(9,2) NULL DEFAULT NULL,
  PRIMARY KEY (`customerNumber`, `paymentTimestamp`, `orderNumber`),
  INDEX `FK-69_001_idx` (`orderNumber` ASC) VISIBLE,
  CONSTRAINT `FK-69_001`
    FOREIGN KEY (`orderNumber`)
    REFERENCES `dbsalesV2.0`.`orders` (`orderNumber`),
  CONSTRAINT `FK-69_002`
    FOREIGN KEY (`customerNumber` , `paymentTimestamp`)
    REFERENCES `dbsalesV2.0`.`payments` (`customerNumber` , `paymentTimestamp`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`product_retail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`product_retail` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`product_retail` (
  `productCode` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`productCode`),
  CONSTRAINT `FK-94_001`
    FOREIGN KEY (`productCode`)
    REFERENCES `dbsalesV2.0`.`current_products` (`productCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`product_pricing`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`product_pricing` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`product_pricing` (
  `productCode` VARCHAR(15) NOT NULL,
  `startdate` DATE NOT NULL,
  `enddate` DATE NULL DEFAULT NULL,
  `MSRP` DECIMAL(9,2) NULL DEFAULT NULL,
  PRIMARY KEY (`productCode`, `startdate`),
  CONSTRAINT `FK-96_001`
    FOREIGN KEY (`productCode`)
    REFERENCES `dbsalesV2.0`.`product_retail` (`productCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`productlines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`productlines` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`productlines` (
  `productLine` VARCHAR(50) NOT NULL,
  `textDescription` VARCHAR(4000) NULL DEFAULT NULL,
  `htmlDescription` MEDIUMTEXT NULL DEFAULT NULL,
  `image` MEDIUMBLOB NULL DEFAULT NULL,
  PRIMARY KEY (`productLine`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`product_productlines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`product_productlines` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`product_productlines` (
  `productCode` VARCHAR(15) NOT NULL,
  `productLine` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`productCode`, `productLine`),
  INDEX `FK-97_002_idx` (`productLine` ASC) VISIBLE,
  CONSTRAINT `FK-97_001`
    FOREIGN KEY (`productCode`)
    REFERENCES `dbsalesV2.0`.`products` (`productCode`),
  CONSTRAINT `FK-97_002`
    FOREIGN KEY (`productLine`)
    REFERENCES `dbsalesV2.0`.`productlines` (`productLine`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`product_wholesale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`product_wholesale` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`product_wholesale` (
  `productCode` VARCHAR(15) NOT NULL,
  `MSRP` DECIMAL(9,2) NULL DEFAULT NULL,
  PRIMARY KEY (`productCode`),
  CONSTRAINT `FK-95_001`
    FOREIGN KEY (`productCode`)
    REFERENCES `dbsalesV2.0`.`current_products` (`productCode`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`ref_shipmentstatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`ref_shipmentstatus` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`ref_shipmentstatus` (
  `status` INT NOT NULL,
  `description` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`status`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`riders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`riders` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`riders` (
  `mobileno` INT NOT NULL,
  `lastName` VARCHAR(45) NULL DEFAULT NULL,
  `firstName` VARCHAR(45) NULL DEFAULT NULL,
  `courierName` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`mobileno`),
  INDEX `FK-60_001_idx` (`courierName` ASC) VISIBLE,
  CONSTRAINT `FK-60_001`
    FOREIGN KEY (`courierName`)
    REFERENCES `dbsalesV2.0`.`couriers` (`courierName`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbsalesV2.0`.`shipmentStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbsalesV2.0`.`shipmentStatus` ;

CREATE TABLE IF NOT EXISTS `dbsalesV2.0`.`shipmentStatus` (
  `referenceNo` INT NOT NULL,
  `statusTimeStamp` DATETIME NOT NULL,
  `status` INT NULL DEFAULT NULL,
  `comments` VARCHAR(45) NULL DEFAULT NULL,
  `ridermobileno` INT NULL DEFAULT NULL,
  PRIMARY KEY (`referenceNo`, `statusTimeStamp`),
  INDEX `FK-68_002_idx` (`status` ASC) VISIBLE,
  INDEX `FK-68_003_idx` (`ridermobileno` ASC) VISIBLE,
  CONSTRAINT `FK-68_001`
    FOREIGN KEY (`referenceNo`)
    REFERENCES `dbsalesV2.0`.`shipments` (`referenceNo`),
  CONSTRAINT `FK-68_002`
    FOREIGN KEY (`status`)
    REFERENCES `dbsalesV2.0`.`ref_shipmentstatus` (`status`),
  CONSTRAINT `FK-68_003`
    FOREIGN KEY (`ridermobileno`)
    REFERENCES `dbsalesV2.0`.`riders` (`mobileno`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 02_DBSales Migration
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================


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
    
    
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 03_Extended DBSales Access
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================

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

-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 04_Auditing
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================


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
  
DROP TRIGGER IF EXISTS 04_products_AFTER_INSERT;
DELIMITER $$
CREATE	TRIGGER 04_products_AFTER_INSERT AFTER INSERT ON products FOR EACH ROW BEGIN
	INSERT INTO audit_products VALUES
		('C', NOW(), new.productCode, NULL, NULL, NULL, NULL, NULL, NULL,
		  new.productName, new.productScale, new.productVendor, 
          new.productDescription, new.buyPrice, new.product_category,
          USER(), 
          new.latest_audituser, new.latest_authorizinguser,
          new.latest_activityreason, new.latest_activitymethod);
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS 04_products_AFTER_UPDATE;
DELIMITER $$
CREATE TRIGGER 04_products_AFTER_UPDATE AFTER UPDATE ON products FOR EACH ROW BEGIN
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

DROP TRIGGER IF EXISTS 04_products_BEFORE_DELETE;
DELIMITER $$
CREATE TRIGGER 04_products_BEFORE_DELETE BEFORE DELETE ON products FOR EACH ROW BEGIN
	INSERT INTO audit_products VALUES
		('D', NOW(), old.productCode, NULL, NULL, NULL, NULL, NULL, NULL,
		  old.productName, old.productScale, old.productVendor, 
          old.productDescription, old.buyPrice, old.product_category,
          USER(), NULL, NULL, NULL, NULL);
END $$
DELIMITER ;

-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4A-A: When orders are taken, the transaction date should always be system-generated and not allowed to be user-supplied. The company implements a strict
-- business rule of target delivery to be not less than 3 days the order was made. When orders are taken, it should automatically have a status of “In-Process”.
-- Products ordered are automatically taken out of the inventory, and its shipment reference should always be empty.When order quantities are updated, the
-- necessary taking out or bringing back of inventory should be implemented.
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- Villaroman, Raphael Luis G.
-- DBADM-103

DROP TRIGGER IF EXISTS 4AA_orders_BEFORE_INSERT;
DROP TRIGGER IF EXISTS 4AA_orderdetails_BEFORE_INSERT;
DROP TRIGGER IF EXISTS 4AA_orderdetails_BEFORE_UPDATE;

-- Trigger to handle automatic order date, status, and required date validation for new orders
DELIMITER $$
CREATE TRIGGER 4AA_orders_BEFORE_INSERT
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Automatically set orderDate to the current date
    SET NEW.orderDate = CURRENT_DATE();

    -- Set default status to 'In Process'
    SET NEW.status = 'In Process';

    -- Validate that requiredDate is at least 3 days after orderDate
    IF (TIMESTAMPDIFF(DAY, NEW.orderDate, NEW.requiredDate) < 3) THEN
        SET errormessage = CONCAT("Required Date cannot be less than 3 days from the Order Date of ", NEW.orderDate);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Set shipment reference (shippedDate) to NULL by default on order creation
    SET NEW.shippedDate = NULL;
END $$
DELIMITER ;

-- Trigger to deduct products from inventory when orderdetails are created
DELIMITER $$
CREATE TRIGGER 4AA_orderdetails_BEFORE_INSERT
BEFORE INSERT ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    DECLARE errormessage VARCHAR(255);

    -- Fetch current stock for the product
    SELECT quantityInStock INTO current_stock
    FROM current_products
    WHERE productCode = NEW.productCode;

    -- Check if there is enough stock available
    IF current_stock < NEW.quantityOrdered THEN
        SET errormessage = CONCAT('Insufficient stock for the ordered product ', NEW.productCode, '. Available stock: ', current_stock, ', Requested: ', NEW.quantityOrdered);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    ELSE
        -- Deduct ordered quantity from the stock
        UPDATE current_products
        SET quantityInStock = quantityInStock - NEW.quantityOrdered
        WHERE productCode = NEW.productCode;
    END IF;
END $$
DELIMITER ;

-- Trigger to adjust inventory when quantityOrdered is updated in orderdetails
DELIMITER $$
CREATE TRIGGER 4AA_orderdetails_BEFORE_UPDATE
BEFORE UPDATE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    DECLARE errormessage VARCHAR(255);
    DECLARE quantity_difference INT;

    -- Calculate the difference between the new and old quantityOrdered
    SET quantity_difference = NEW.quantityOrdered - OLD.quantityOrdered;

    -- Fetch current stock for the product
    SELECT quantityInStock INTO current_stock
    FROM current_products
    WHERE productCode = NEW.productCode;

    -- Adjust inventory based on the quantity difference
    IF quantity_difference > 0 THEN
        -- Check if there is enough stock available to cover the increase
        IF current_stock < quantity_difference THEN
            SET errormessage = CONCAT('Insufficient stock for the ordered product ', NEW.productCode, '. Available stock: ', current_stock, ', Additional requested: ', quantity_difference);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        ELSE
            -- Deduct the additional quantity from stock
            UPDATE current_products
            SET quantityInStock = quantityInStock - quantity_difference
            WHERE productCode = NEW.productCode;
        END IF;
    ELSEIF quantity_difference < 0 THEN
        -- If quantity has been reduced, add the difference back to stock
        UPDATE current_products
        SET quantityInStock = quantityInStock - quantity_difference
        WHERE productCode = NEW.productCode;
    END IF;
END $$
DELIMITER ;

-- =============================================================
-- 4AA TEST CASE 1: Verify orderDate is automatically set
-- =============================================================
INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, city, country)
VALUES (485, 'Test Customer', 'Doe', 'John', '1234567890', '123 Main St', 'Test City', 'Test Country');

INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
VALUES (1001, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'Pending', 485);

SELECT orderNumber, orderDate, requiredDate, status, customerNumber
FROM orders
WHERE orderNumber = 1001;

-- =============================================================
-- 4AA TEST CASE 2: Verify status is automatically set to In Process
-- =============================================================
-- New order with a specified status other than 'In Process'
INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
VALUES (1002, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'Completed', 485);

SELECT orderNumber, orderDate, requiredDate, status, customerNumber
FROM orders
WHERE orderNumber = 1002;

-- =============================================================
-- 4AA TEST CASE 3: Validate requiredDate cannot be less than 3 days from orderDate
-- =============================================================
-- Attempt to insert an order with requiredDate less than 3 days from orderDate
INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
VALUES (1003, DATE_ADD(CURRENT_DATE(), INTERVAL 2 DAY), 'Pending', 485);

-- =============================================================
-- 4AA TEST CASE 4: Verify shippedDate is set to NULL on order creation
-- =============================================================
-- New order with a specified shippedDate (which should be overridden to NULL by the trigger)
INSERT INTO orders (orderNumber, requiredDate, shippedDate, status, customerNumber)
VALUES (1004, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), CURRENT_DATE(), 'Pending', 485);

-- Verify shippedDate is set to NULL
SELECT orderNumber, orderDate, requiredDate, shippedDate, status, customerNumber
FROM orders
WHERE orderNumber = 1004;

-- =============================================================
-- 4AA TEST CASE 5: Verify inventory deduction on order creation
-- =============================================================
-- Create a new product entry in the products table
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category)
VALUES ('S1_1000', 'Test Product', '1:18', 'Test Vendor', 'A sample product for testing purposes.', 50.00, 'C');

-- Create an entry for the product in the current_products table
INSERT INTO current_products (productCode, quantityInStock)
VALUES ('S1_1000', 100);

-- Create a new order that will be used for the orderdetail
INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
VALUES (1005, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485);

-- Create a new orderdetail for the existing order to verify inventory deduction
INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (1005, 'S1_1000', 5, 100.00, 1);

-- Verify inventory deduction
SELECT productCode, quantityInStock 
FROM current_products
WHERE productCode = 'S1_1000';

-- =============================================================
-- 4AA TEST CASE 6: Verify inventory updates on order quantity changes
-- =============================================================

-- Add an initial order detail entry to update later
INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
VALUES (1006, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485);

-- Stock should be currently 95 due to earlier test case using S1_1000
INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (1006, 'S1_1000', 5, 100.00, 1);

-- Before update, ensure that inventory was properly deducted by the initial insertion
SELECT productCode, quantityInStock 
FROM current_products
WHERE productCode = 'S1_1000';

-- Increase the quantityOrdered from 5 to 10 and verify the inventory deduction
UPDATE orderdetails
SET quantityOrdered = 10
WHERE orderNumber = 1006 AND productCode = 'S1_1000';

-- Inventory should now be reduced by an additional 5 units
SELECT productCode, quantityInStock 
FROM current_products
WHERE productCode = 'S1_1000';

-- Decrease the quantityOrdered from 10 to 3 and verify inventory adjustment
UPDATE orderdetails
SET quantityOrdered = 3
WHERE orderNumber = 1006 AND productCode = 'S1_1000';

-- Inventory should now be increased by 7 units (since it was decreased from 10 to 3)
SELECT productCode, quantityInStock 
FROM current_products
WHERE productCode = 'S1_1000';

-- Final quantityInStock should be 92
-- 4A-A END

