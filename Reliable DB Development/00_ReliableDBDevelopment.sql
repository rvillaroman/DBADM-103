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

    -- Skip requiredDate validation if a special comment or flag is present (e.g., "SKIP_VALIDATION")
    IF NEW.comments NOT LIKE '%SKIP_VALIDATION%' THEN
        -- Validate that requiredDate is at least 3 days after orderDate
        IF (TIMESTAMPDIFF(DAY, NEW.orderDate, NEW.requiredDate) < 3) THEN
            SET errormessage = CONCAT("Required Date cannot be less than 3 days from the Order Date of ", NEW.orderDate);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        END IF;
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
        -- If the quantity is being increased, ensure enough stock is available
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
        -- If the quantity has been reduced, add the difference back to stock
        -- Since quantity_difference is negative, we use -quantity_difference to add back to stock
        UPDATE current_products
        SET quantityInStock = quantityInStock + ABS(quantity_difference)
        WHERE productCode = NEW.productCode;
    END IF;
END $$
DELIMITER ;

-- =============================================================
-- 4AA TEST CASE 1: Verify orderDate is automatically set
-- =============================================================
-- INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, city, country)
-- VALUES (485, 'Test Customer', 'Doe', 'John', '1234567890', '123 Main St', 'Test City', 'Test Country');

-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1001, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'Pending', 485);

-- SELECT orderNumber, orderDate, requiredDate, status, customerNumber
-- FROM orders
-- WHERE orderNumber = 1001;

-- =============================================================
-- 4AA TEST CASE 2: Verify status is automatically set to In Process
-- =============================================================
-- New order with a specified status other than 'In Process'
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1002, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'Completed', 485);

-- SELECT orderNumber, orderDate, requiredDate, status, customerNumber
-- FROM orders
-- WHERE orderNumber = 1002;

-- =============================================================
-- 4AA TEST CASE 3: Validate requiredDate cannot be less than 3 days from orderDate
-- =============================================================
-- Attempt to insert an order with requiredDate less than 3 days from orderDate
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1003, DATE_ADD(CURRENT_DATE(), INTERVAL 2 DAY), 'Pending', 485);

-- =============================================================
-- 4AA TEST CASE 4: Verify shippedDate is set to NULL on order creation
-- =============================================================
-- New order with a specified shippedDate (which should be overridden to NULL by the trigger)
-- INSERT INTO orders (orderNumber, requiredDate, shippedDate, status, customerNumber)
-- VALUES (1004, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), CURRENT_DATE(), 'Pending', 485);

-- Verify shippedDate is set to NULL
-- SELECT orderNumber, orderDate, requiredDate, shippedDate, status, customerNumber
-- FROM orders
-- WHERE orderNumber = 1004;

-- =============================================================
-- 4AA TEST CASE 5: Verify inventory deduction on order creation
-- =============================================================
-- Create a new product entry in the products table
-- INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category)
-- VALUES ('S1_1000', 'Test Product', '1:18', 'Test Vendor', 'test product', 50.00, 'C');

-- Create an entry for the product in the current_products table
-- INSERT INTO current_products (productCode, product_type, quantityInStock)
-- VALUES ('S1_1000', 'R', 100);

-- Create a new order that will be used for the orderdetail
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1005, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485);

-- Create a new orderdetail for the existing order to verify inventory deduction
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
-- VALUES (1005, 'S1_1000', 5, 100.00, 1);

-- Verify inventory deduction
-- SELECT productCode, quantityInStock 
-- FROM current_products
-- WHERE productCode = 'S1_1000';

-- =============================================================
-- 4AA TEST CASE 6: Verify inventory updates on order quantity changes
-- =============================================================

-- Add an initial order detail entry to update later
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1006, DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485);

-- Stock should be currently 95 due to earlier test case using S1_1000
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
-- VALUES (1006, 'S1_1000', 5, 100.00, 1);

-- Before update, ensure that inventory was properly deducted by the initial insertion
-- SELECT productCode, quantityInStock 
-- FROM current_products
-- WHERE productCode = 'S1_1000';

-- Increase the quantityOrdered from 5 to 10 and verify the inventory deduction
-- UPDATE orderdetails
-- SET quantityOrdered = 10
-- WHERE orderNumber = 1006 AND productCode = 'S1_1000';

-- Inventory should now be reduced by an additional 5 units
-- SELECT productCode, quantityInStock 
-- FROM current_products
-- WHERE productCode = 'S1_1000';

-- Decrease the quantityOrdered from 10 to 3 and verify inventory adjustment
-- UPDATE orderdetails
-- SET quantityOrdered = 3
-- WHERE orderNumber = 1006 AND productCode = 'S1_1000';

-- Inventory should now be increased by 7 units (since it was decreased from 10 to 3)
-- SELECT productCode, quantityInStock 
-- FROM current_products
-- WHERE productCode = 'S1_1000';


-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4A-B: When products are ordered, the order line number is generated by the system. The quantity ordered cannot be allowed to be more than what is currently
-- available in the inventory. Furthermore, the price provided for the product cannot be more than a 20% discount from the MSRP but can at most be 100%
-- beyond the MSRP. 
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- Villaroman, Raphael Luis G.
-- DBADM-103

-- Getting a specific MSRP for a product
-- Function to retrieve the MSRP based on product type and status

DROP FUNCTION IF EXISTS getMSRP;
DELIMITER $$
CREATE FUNCTION getMSRP (param_productCode VARCHAR(15)) 
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE var_productcategory ENUM('C', 'D');
    DECLARE var_producttype ENUM('R', 'W');
    DECLARE var_MSRP DECIMAL(9,2);
    DECLARE errormessage VARCHAR(200);

    -- Check if the product exists in the products table
    SELECT product_category
    INTO var_productcategory
    FROM products
    WHERE productCode = param_productCode;

    IF (var_productcategory IS NULL) THEN
        SET errormessage := CONCAT("Product does not exist: ", param_productCode);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Check if the product is discontinued
    IF (var_productcategory = 'D') THEN
        SET errormessage := CONCAT("Product is discontinued: ", param_productCode);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Check the product type in the current_products table
    SELECT product_type
    INTO var_producttype
    FROM current_products
    WHERE productCode = param_productCode;

    IF (var_producttype IS NULL) THEN
        SET errormessage := CONCAT("Product type not found in current_products: ", param_productCode);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Retrieve MSRP based on product type
    IF (var_producttype = 'R') THEN
        -- The product is retail
        SELECT MSRP
        INTO var_MSRP
        FROM product_pricing
        WHERE productCode = param_productCode
        AND NOW() BETWEEN startdate AND enddate;

        IF (var_MSRP IS NULL) THEN
            SET errormessage := CONCAT("MSRP of the product does not exist for the current date: ", param_productCode);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        END IF;

        RETURN var_MSRP;

    ELSEIF (var_producttype = 'W') THEN
        -- The product is wholesale
        SELECT MSRP
        INTO var_MSRP
        FROM product_wholesale
        WHERE productCode = param_productCode;

        IF (var_MSRP IS NULL) THEN
            SET errormessage := CONCAT("MSRP not found in product_wholesale for product: ", param_productCode);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        END IF;

        RETURN var_MSRP;
    END IF;

    -- If product type is neither R nor W, raise an error
    SET errormessage := CONCAT("Unexpected product type for product: ", param_productCode);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;

END $$
DELIMITER ;


-- Trigger on Order Details

DROP TRIGGER IF EXISTS 4AB_orderdetails_BEFORE_INSERT;
DELIMITER $$
CREATE TRIGGER `4AB_orderdetails_BEFORE_INSERT` BEFORE INSERT ON `orderdetails` FOR EACH ROW 
BEGIN
    DECLARE errormessage VARCHAR(200);
    DECLARE var_MSRP DECIMAL(9,2);

    SET NEW.referenceNo = NULL;

    -- Get the MSRP value for the product
    SET var_MSRP = getMSRP(NEW.productCode);

    -- Check if the quantity ordered will make the inventory go below 0
    IF ((SELECT quantityInStock - NEW.quantityOrdered FROM current_products WHERE productCode = NEW.productCode) < 0) THEN
        SET errormessage = CONCAT("The quantity being ordered for ", NEW.productCode, " will make the inventory quantity go below zero");
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Auto generation of orderline numbers
    SET NEW.orderLineNumber = IFNULL(
        (SELECT MAX(orderLineNumber) + 1 FROM orderdetails WHERE orderNumber = NEW.orderNumber),
        1
    );

    -- Check for consistency of price with MSRP: 20% discount and at most 100% beyond MSRP
    IF (NEW.priceEach < var_MSRP * 0.8) OR (NEW.priceEach > var_MSRP * 2) THEN
        SET errormessage = CONCAT("The price for this ", NEW.productCode, " should not be below 80% and above 100% of its MSRP: ", var_MSRP);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage; 
    END IF;
END $$
DELIMITER ;

-- =============================================================
-- 4AB TEST CASE 1: Verify order line number is generated automatically
-- =============================================================

-- Create a new order with a new orderNumber
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1007, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- Create an orderdetail for the new order providing a placeholder for orderLineNumber
-- Provide a placeholder value (0) for orderLineNumber, and let the trigger replace it
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1007, 'S1_1000', 3, 80.00, 0, NULL);

-- Verify the orderLineNumber has been generated automatically by the trigger
-- SELECT orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber
-- FROM orderdetails
-- WHERE orderNumber = 1007;

-- =============================================================
-- 4AB TEST CASE 2: Verify quantity ordered does not exceed available inventory
-- =============================================================

-- Check the current inventory of productCode 'S1_1000'
-- Confirm the current available inventory before attempting to order
-- SELECT productCode, quantityInStock
-- FROM current_products
-- WHERE productCode = 'S1_1000';

-- Create a new order with a new unique orderNumber
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1008, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- Create an orderdetail with quantityOrdered exceeding the available quantity
-- Assuming the product has less than 200 units in the inventory, we'll try to order more than is available
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1008, 'S1_1000', 200, 80.00, 0, NULL);


-- =============================================================
-- 4AB TEST CASE 3: Verify price is within acceptable range of MSRP
-- =============================================================

-- Step 1: Create product 'S1_1001' into products table
-- INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category)
-- VALUES ('S1_1001', 'Test Product', '1:18', 'Test Vendor', 'A sample product for testing purposes.', 50.00, 'C');

-- Step 2: Insert productCode 'S1_1001' into current_products table with inventory
-- INSERT INTO current_products (productCode, product_type, quantityInStock)
-- VALUES ('S1_1001', 'R', 100);

-- Step 3: Insert productCode 'S1_1001' into product_retail table
-- INSERT INTO product_retail (productCode)
-- VALUES ('S1_1001');

-- Step 4: Insert MSRP details for productCode 'S1_1001'
-- Create a product pricing entry for 'S1_1001' with an MSRP of 100.00
-- INSERT INTO product_pricing (productCode, startdate, enddate, MSRP)
-- VALUES ('S1_1001', CURRENT_DATE() - INTERVAL 1 MONTH, CURRENT_DATE() + INTERVAL 1 MONTH, 100.00);

-- Step 5: Insert a new order for testing purposes
-- Create a new order with a new unique order number (1009)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1009, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- Step 6: Attempt to insert an orderdetail with a price below 80% of MSRP
-- 80% of MSRP (100) is 80. So, we'll try to insert a price below this limit, e.g., 70.00
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1009, 'S1_1001', 2, 70.00, 0, NULL);

-- Step 7: Insert a new order for testing another price limit with a new unique order number (1010)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1010, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- Step 8: Attempt to insert an orderdetail with a price above 200% of MSRP
-- 200% of MSRP (100) is 200. So, we'll try to insert a price above this limit, e.g., 250.00
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1010, 'S1_1001', 2, 250.00, 0, NULL);

-- =============================================================
-- 4AB TEST CASE 4: Verify `orderLineNumber` incrementation with multiple order details
-- =============================================================

-- Create another product 'S1_1002' in the products table
-- INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category)
-- VALUES ('S1_1002', 'Test Product 2', '1:18', 'Test Vendor', 'Another sample product for testing purposes.', 60.00, 'C');

-- Create productCode 'S1_1002' into current_products table with inventory and product type
-- INSERT INTO current_products (productCode, product_type, quantityInStock)
-- VALUES ('S1_1002', 'R', 100);

-- Create productCode 'S1_1002' into product_retail table
-- INSERT INTO product_retail (productCode)
-- VALUES ('S1_1002');

-- Create MSRP details for productCode 'S1_1002' in product_pricing table
-- and a product pricing entry for 'S1_1002' with an MSRP of 100.00
-- INSERT INTO product_pricing (productCode, startdate, enddate, MSRP)
-- VALUES ('S1_1002', CURRENT_DATE() - INTERVAL 1 MONTH, CURRENT_DATE() + INTERVAL 1 MONTH, 100.00);

-- Create a new order with a unique orderNumber (1011)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1011, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- Create the first orderdetail for the order (productCode = 'S1_1001')
-- should have an automatically generated orderLineNumber of 1
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1011, 'S1_1001', 3, 90.00, 0, NULL);

-- Create a second orderdetail for the same order with a different product (productCode = 'S1_1002')
-- should have an automatically generated orderLineNumber of 2
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1011, 'S1_1002', 5, 90.00, 0, NULL);

-- Verify orderLineNumber for both entries
-- SELECT orderNumber, productCode, quantityOrdered, orderLineNumber
-- FROM orderdetails
-- WHERE orderNumber = 1011;

-- =============================================================
-- 4AB TEST CASE 5: Verify MSRP retrieval and enforcement for wholesale products
-- =============================================================

-- Create a new wholesale product 'S1_2000' in the products table
-- INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category)
-- VALUES ('S1_2000', 'Wholesale Product', '1:18', 'Wholesale Vendor', 'A sample wholesale product for testing.', 60.00, 'C');

-- Create productCode 'S1_2000' in the current_products table with inventory and product type 'W'
-- INSERT INTO current_products (productCode, product_type, quantityInStock)
-- VALUES ('S1_2000', 'W', 150);

-- Create MSRP details for productCode 'S1_2000' in product_wholesale table
-- INSERT INTO product_wholesale (productCode, MSRP)
-- VALUES ('S1_2000', 120.00);

-- Create a new order with a new unique orderNumber (1013)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1013, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- Attempt to insert an orderdetail with a price above 200% of MSRP for the wholesale product; an error should appear
-- 200% of MSRP (120) is 240. So, we'll try to insert a price above this limit, e.g., 300.00
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1013, 'S1_2000', 2, 300.00, 0, NULL);

-- Insert a valid orderdetail with price within the allowed range (e.g., 180.00 which is within 100% beyond MSRP)
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1013, 'S1_2000', 3, 180.00, 0, NULL);

-- Step 8: Verify inventory has been correctly deducted
-- SELECT productCode, quantityInStock
-- FROM current_products
-- WHERE productCode = 'S1_2000';

-- Step 9: Update `quantityOrdered` for the orderdetail to 1 (reduce from 3 to 1)
-- UPDATE orderdetails
-- SET quantityOrdered = 1
-- WHERE orderNumber = 1013 AND productCode = 'S1_2000';

-- Step 10: Verify the inventory has increased by the difference (i.e., 2 units should be added back)
-- SELECT productCode, quantityInStock
-- FROM current_products
-- WHERE productCode = 'S1_2000';

-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4A-C: Orders can be updated, but only its required date, status and comments. When the status of the order is “shipped” should a shipped date be allowed to
-- have a value. Previous comments cannot be removed from the data, therefore any new comment provided should be appended rather than override any
-- existing comment. Statuses cannot be reverted. This means that the sequence of the status must always be forward and not backward. Once an order is
-- completed then no activity on the order and the products ordered can be allowed.
-- a. In-Process to Shipped
-- b. Shipped to Disputed
-- c. Disputed to Resolved
-- d. Shipped to Completed
-- e. Resolved to Completed 
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- Villaroman, Raphael Luis G.
-- DBADM-103

-- Check if the status value is valid
DROP FUNCTION IF EXISTS isStatusValid;
DELIMITER $$
CREATE FUNCTION isStatusValid(param_status VARCHAR(15))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    IF (param_status IN ("In Process", "Shipped", "Disputed", "Resolved", "Completed", "Cancelled")) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
END $$
DELIMITER ;

-- Check if the transition from old to new status is valid based on the defined sequence
DROP FUNCTION IF EXISTS isValidStatus;
DELIMITER $$
CREATE FUNCTION isValidStatus(param_oldstatus VARCHAR(15), param_newstatus VARCHAR(15))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE errormessage VARCHAR(200);
    
    -- Allow cancelling from any status except Completed
    IF param_newstatus = 'Cancelled' AND param_oldstatus != 'Completed' THEN
        RETURN TRUE;
    END IF;

    -- If the old status and new status are the same, no further validation needed
    IF (param_oldstatus = param_newstatus) THEN 
        RETURN TRUE;
    END IF;

    -- Valid status transitions
    IF (param_oldstatus = "In Process" AND param_newstatus = "Shipped") THEN
        RETURN TRUE;
    END IF;

    IF (param_oldstatus = "Shipped" AND param_newstatus IN ("Disputed", "Completed")) THEN
        RETURN TRUE;
    END IF;

    IF (param_oldstatus = "Disputed" AND param_newstatus = "Resolved") THEN
        RETURN TRUE;
    END IF;

    IF (param_oldstatus = "Resolved" AND param_newstatus = "Completed") THEN
        RETURN TRUE;
    END IF;

    -- Prevent backward status transitions
    IF (param_newstatus = "In Process" AND param_oldstatus IN ("Shipped", "Disputed", "Resolved", "Completed")) THEN
        SET errormessage := "Reverting status backward is not allowed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    SET errormessage := CONCAT("Invalid status transition from ", param_oldstatus, " to ", param_newstatus);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;

END $$
DELIMITER ;



-- Enforce order update rules on status, requiredDate, and comments
DROP TRIGGER IF EXISTS 4AC_before_order_update;
DELIMITER $$
CREATE TRIGGER 4AC_before_order_update
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Prevent updates if status is "Completed"
    IF (OLD.status = "Completed") THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No updates allowed for orders with Completed status';
    END IF;

    -- Validate status transition
    IF (NEW.status IS NOT NULL AND OLD.status != NEW.status) THEN
        IF (NOT isValidStatus(OLD.status, NEW.status)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid status transition';
        END IF;
    END IF;

    -- Set shippedDate if status is "Shipped"
    IF (NEW.status = "Shipped" AND OLD.status != "Shipped" AND NEW.shippedDate IS NULL) THEN
        SET NEW.shippedDate = NOW();
    END IF;

    -- Prevent shippedDate changes if already set, even with valid status changes
    IF (OLD.shippedDate IS NOT NULL AND NEW.shippedDate != OLD.shippedDate) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot modify shippedDate directly once it has been set';
    END IF;

    -- Append comments instead of overwriting
    IF (NEW.comments IS NOT NULL AND NEW.comments != OLD.comments) THEN
        SET NEW.comments = CONCAT(OLD.comments, ' ', NEW.comments);
    END IF;

    -- Restrict updates to requiredDate, status, and comments only
    IF (OLD.orderDate != NEW.orderDate OR OLD.customerNumber != NEW.customerNumber) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only requiredDate, status, and comments can be updated';
    END IF;
    
    -- Acknowledge update of requiredDate if it's the only change (except when status is completed)
    IF (NEW.requiredDate != OLD.requiredDate AND OLD.status != "Completed") THEN
        SET NEW.requiredDate = NEW.requiredDate;
    END IF;
END $$
DELIMITER ;

-- -- =============================================================
-- -- 4AC TEST CASE 1: Verify status forward-only transitions
-- -- a. In-Process to Shipped
-- -- b. Shipped to Disputed
-- -- c. Disputed to Resolved
-- -- d. Shipped to Completed
-- -- e. Resolved to Completed 
-- -- =============================================================

-- -- Step 1: Insert a new order with an initial status of 'In Process' (orderNumber = 1014)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1014, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- -- Step 2: Update the status from 'In Process' to 'Shipped' (valid transition)
-- UPDATE orders
-- SET status = 'Shipped'
-- WHERE orderNumber = 1014;

-- -- Step 3: Update the status from 'Shipped' to 'Disputed' (valid transition)
-- UPDATE orders
-- SET status = 'Disputed'
-- WHERE orderNumber = 1014;

-- -- Step 4: Attempt to revert the status from 'Disputed' to 'In Process' (invalid transition)
-- -- Expected outcome: Error indicating that reverting status backward is not allowed
-- UPDATE orders
-- SET status = 'In Process'
-- WHERE orderNumber = 1014;

-- -- Step 5: Attempt to update the status from 'Disputed' to 'Resolved' (valid transition)
-- UPDATE orders
-- SET status = 'Resolved'
-- WHERE orderNumber = 1014;

-- -- Step 6: Attempt to update the status from 'Resolved' to 'Completed' (valid transition)
-- UPDATE orders
-- SET status = 'Completed'
-- WHERE orderNumber = 1014;


-- -- =============================================================
-- -- 4AC TEST CASE 2: Verify `shippedDate` modification rules
-- -- =============================================================

-- -- Create a new order with an initial status of 'In Process' (orderNumber = 1015)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1015, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- -- Update the status from 'In Process' to 'Shipped' and set the `shippedDate` (valid transition)
-- UPDATE orders
-- SET status = 'Shipped', shippedDate = CURRENT_DATE()
-- WHERE orderNumber = 1015;

-- -- Attempt to modify the `shippedDate` after it has already been set
-- UPDATE orders
-- SET shippedDate = DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY)
-- WHERE orderNumber = 1015;

-- -- Step 5: Verify the `shippedDate` remains unchanged
-- SELECT orderNumber, status, shippedDate
-- FROM orders
-- WHERE orderNumber = 1015;

-- -- =============================================================
-- -- 4AC TEST CASE 3: Verify comments are appended
-- -- =============================================================

-- -- Create a new order with an initial comment (orderNumber = 1016)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber, comments)
-- VALUES (1016, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485, 'test comment 1');

-- -- Update the order by adding a new comment
-- UPDATE orders
-- SET comments = 'test comment 2'
-- WHERE orderNumber = 1016;

-- -- Verify the comments were appended
-- SELECT orderNumber, comments
-- FROM orders
-- WHERE orderNumber = 1016;

-- -- =============================================================
-- -- 4AC TEST CASE 4: Verify no updates are allowed for orders with status "Completed"
-- -- =============================================================

-- -- Step 1: Insert a new order with status 'In Process' (orderNumber = 1017)
-- INSERT INTO orders (orderNumber, requiredDate, status, customerNumber)
-- VALUES (1017, DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'In Process', 485);

-- -- Step 2: Update the status from 'In Process' to 'Shipped' (valid transition)
-- UPDATE orders
-- SET status = 'Shipped'
-- WHERE orderNumber = 1017;

-- -- Step 3: Update the status from 'Shipped' to 'Completed' (valid transition)
-- UPDATE orders
-- SET status = 'Completed'
-- WHERE orderNumber = 1017;

-- -- Step 4: Attempt to update the `requiredDate` after the status is 'Completed'
-- -- Expected outcome: Error indicating no updates allowed for orders with status "Completed"
-- UPDATE orders
-- SET requiredDate = DATE_ADD(CURRENT_DATE(), INTERVAL 10 DAY)
-- WHERE orderNumber = 1017;

-- -- Step 5: Attempt to add a new comment after the status is 'Completed'
-- -- Expected outcome: Error indicating no updates allowed for orders with status "Completed"
-- UPDATE orders
-- SET comments = 'Attempt to add a comment'
-- WHERE orderNumber = 1017;

-- -- Step 6: Attempt to revert the status from 'Completed' to 'Disputed'
-- -- Expected outcome: Error indicating that no status changes are allowed after completion
-- UPDATE orders
-- SET status = 'Disputed'
-- WHERE orderNumber = 1017;

-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4A-D: When products are ordered, the order line number is generated by the system. The quantity ordered cannot be allowed to be more than what is currently
-- available in the inventory. Furthermore, the price provided for the product cannot be more than a 20% discount from the MSRP but can at most be 100%
-- beyond the MSRP. 
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- Villaroman, Raphael Luis G.
-- DBADM-103

DROP TRIGGER IF EXISTS 4AD_orders_BEFORE_UPDATE;
DROP TRIGGER IF EXISTS 4AD_orderdetails_restrictions;
DROP TRIGGER IF EXISTS 4AD_orderdetails_delete_restriction;

-- Trigger for orders: Enforces restrictions on order fields
DELIMITER $$
CREATE TRIGGER `4AD_orders_BEFORE_UPDATE` BEFORE UPDATE ON `orders` FOR EACH ROW 
BEGIN
    DECLARE errormessage VARCHAR(200);
    
    -- Skip requiredDate validation if a special comment or flag is present (e.g., "SKIP_VALIDATION")
    IF NEW.comments NOT LIKE '%SKIP_VALIDATION%' THEN
        -- Check if requiredDate is at least 3 days after orderDate
        IF (TIMESTAMPDIFF(DAY, NEW.orderdate, NEW.requireddate) < 3) THEN
            SET errormessage = CONCAT("Required Date cannot be less than 3 days from the Order Date of ", NEW.orderdate);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
        END IF;
    END IF;

    -- Check if orderNumber is being updated
    IF (NEW.ordernumber != OLD.ordernumber) THEN
        SET errormessage = CONCAT("Order Number ", OLD.ordernumber, " cannot be updated to a new value of ", NEW.ordernumber);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Check if updated orderDate is before the original orderDate
    IF (NEW.orderDate < OLD.orderDate) THEN
        SET errormessage = CONCAT("Updated orderdate cannot be less than the original date of ", OLD.orderDate);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Ensure customerNumber is present
    IF (NEW.customernumber IS NULL) THEN
        SET errormessage = CONCAT("Order number ", NEW.ordernumber, " cannot be updated without a customer");
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
END $$
DELIMITER ;

-- Trigger for orderdetails: Enforces restrictions based on order status
DELIMITER $$
CREATE TRIGGER 4AD_orderdetails_restrictions
BEFORE UPDATE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE order_status VARCHAR(50);

    -- Retrieve the status from the orders table for the relevant orderNumber
    SELECT status INTO order_status
    FROM orders
    WHERE orders.orderNumber = NEW.orderNumber;

    -- If the order status is "Shipped"
    IF order_status = 'Shipped' THEN
        -- Allow updates only to referenceNo, and no changes to other fields
        IF NEW.quantityOrdered != OLD.quantityOrdered OR 
           NEW.priceEach != OLD.priceEach OR
           NEW.orderLineNumber != OLD.orderLineNumber THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No updates are allowed on fields other than referenceNo once the order is shipped.';
        END IF;
    ELSE
        -- When status is not "Shipped", only allow updates to quantityOrdered and priceEach
        IF NEW.quantityOrdered = OLD.quantityOrdered AND NEW.priceEach = OLD.priceEach THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only quantityOrdered and priceEach can be updated on non-shipped orders.';
        END IF;

        -- Prevent any attempt to update referenceNo on non-shipped orders
        IF NEW.referenceNo != OLD.referenceNo THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'referenceNo can only be updated when the order status is shipped.';
        END IF;

        -- Disallow updates to orderLineNumber and other fields when the order status is not "Shipped"
        IF NEW.orderLineNumber != OLD.orderLineNumber THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only quantityOrdered and priceEach can be updated on non-shipped orders.';
        END IF;
    END IF;
END $$
DELIMITER ;

-- Trigger to restrict deletion in orderdetails when order status is shipped
DELIMITER $$
CREATE TRIGGER 4AD_orderdetails_delete_restriction
BEFORE DELETE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE order_status VARCHAR(50);

    -- Retrieve the status from the orders table for the relevant orderNumber
    SELECT status INTO order_status
    FROM orders
    WHERE orders.orderNumber = OLD.orderNumber;

    -- Restrict deletion if the order status is "Shipped"
    IF order_status = 'Shipped' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordered products cannot be deleted once the order has shipped.';
    END IF;
END $$
DELIMITER ;

-- -- =============================================================
-- -- 4AD TEST CASE 1: Verify order field update restrictions
-- -- =============================================================

-- -- Create a new order with initial values (orderNumber = 1018)
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
-- VALUES (1018, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485);

-- -- Attempt to update the `orderNumber` (invalid update)
-- UPDATE orders
-- SET orderNumber = 2000
-- WHERE orderNumber = 1018;

-- -- Attempt to update the `orderDate` to an earlier date (invalid update)
-- UPDATE orders
-- SET orderDate = DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)
-- WHERE orderNumber = 1018;

-- -- Attempt to update the `requiredDate` to be less than 3 days after `orderDate` (invalid update)
-- UPDATE orders
-- SET requiredDate = DATE_ADD(CURRENT_DATE(), INTERVAL 2 DAY)
-- WHERE orderNumber = 1018;

-- -- Verify that no updates were applied
-- SELECT orderNumber, orderDate, requiredDate, status, customerNumber
-- FROM orders
-- WHERE orderNumber = 1018;

-- -- =============================================================
-- -- 4AD TEST CASE 2: Verify order details update restrictions based on order status
-- -- =============================================================

-- -- Create a new order with initial status 'In Process' (orderNumber = 1019)
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
-- VALUES (1019, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485);

-- -- Create an orderdetail associated with this order (productCode = 'S1_1001')
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1019, 'S1_1001', 5, 100.00, 1, NULL);

-- -- Update the order status to 'Shipped' (valid transition)
-- UPDATE orders
-- SET status = 'Shipped'
-- WHERE orderNumber = 1019;

-- -- Attempt to update `quantityOrdered` after the order status is 'Shipped' (invalid update)
-- UPDATE orderdetails
-- SET quantityOrdered = 10
-- WHERE orderNumber = 1019 AND productCode = 'S1_1001';

-- -- Insert a valid courier entry in the `couriers` table (courierName = 'Test Courier')
-- INSERT INTO couriers (courierName)
-- VALUES ('Test Courier');

-- -- Insert a valid shipment reference in the `shipments` table (referenceNo = 12345)
-- INSERT INTO shipments (referenceNo, courierName)
-- VALUES (12345, 'Test Courier');

-- -- Attempt to update `referenceNo` (valid update when status is 'Shipped')
-- UPDATE orderdetails
-- SET referenceNo = 12345
-- WHERE orderNumber = 1019 AND productCode = 'S1_1001';

-- -- Attempt to update `orderLineNumber` after the order status is 'Shipped' (invalid update)
-- UPDATE orderdetails
-- SET orderLineNumber = 2
-- WHERE orderNumber = 1019 AND productCode = 'S1_1001';

-- -- Verify the `orderdetails` record
-- SELECT orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo
-- FROM orderdetails
-- WHERE orderNumber = 1019 AND productCode = 'S1_1001';

-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4A-E: Orders cannot be deleted physically from the records. Orders can be cancelled though causing its status to be “Cancelled”. Cancelled orders (and the
-- products ordered) should not allow any further data activity on the order and the ordered products.When orders are cancelled, the products ordered should
-- be returned to inventory and provided with the appropriate reason of being cancelled by the System.
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- Villaroman, Raphael Luis G.
-- DBADM-103

-- Prevent Physical Deletion of Orders (Cancelling Instead)
DROP TRIGGER IF EXISTS 4AE_orders_BEFORE_DELETE;
DELIMITER $$
CREATE TRIGGER 4AE_orders_BEFORE_DELETE
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Orders cannot be deleted, only cancelled.';
END $$
DELIMITER ;

-- Trigger for Cancelling Orders (BEFORE UPDATE)
DROP TRIGGER IF EXISTS 4AE_orders_BEFORE_UPDATE;
DELIMITER $$

CREATE TRIGGER 4AE_orders_BEFORE_UPDATE
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Check if the order status is being changed to 'Cancelled'
    IF NEW.status = 'Cancelled' THEN
        -- Restore products to inventory when the order is cancelled
        UPDATE current_products cp
        JOIN orderdetails od ON cp.productCode = od.productCode
        SET cp.quantityInStock = cp.quantityInStock + od.quantityOrdered
        WHERE od.orderNumber = OLD.orderNumber;

        -- Log the reason for cancellation as "Cancelled by System"
        SET NEW.comments = CONCAT(OLD.comments, ' | System Cancelled Order');
    END IF;

    -- Prevent further modifications on cancelled orders
    IF OLD.status = 'Cancelled' THEN
        SET errormessage = 'No further changes are allowed for cancelled orders.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

END $$ 
DELIMITER ;

-- Prevent Modifications on Ordered Products if Order is Cancelled
DROP TRIGGER IF EXISTS 4AE_orderdetails_BEFORE_UPDATE;
DELIMITER $$

CREATE TRIGGER 4AE_orderdetails_BEFORE_UPDATE
BEFORE UPDATE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Prevent updates on orderdetails if the order is cancelled
    IF (SELECT status FROM orders WHERE orderNumber = NEW.orderNumber) = 'Cancelled' THEN
        SET errormessage = 'No modifications allowed on products of a cancelled order.';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

END $$ 
DELIMITER ;

-- Prevent Deletion of Ordered Products if Order is Cancelled
DROP TRIGGER IF EXISTS 4AE_orderdetails_BEFORE_DELETE;
DELIMITER $$

CREATE TRIGGER 4AE_orderdetails_BEFORE_DELETE
BEFORE DELETE ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE order_status VARCHAR(50);

    -- Retrieve the status from the orders table for the relevant orderNumber
    SELECT status INTO order_status
    FROM orders
    WHERE orders.orderNumber = OLD.orderNumber;

    -- Restrict deletion if the order status is "Cancelled"
    IF order_status = 'Cancelled' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordered products cannot be deleted once the order has been cancelled.';
    END IF;
END $$
DELIMITER ;


-- =============================================================
-- 4AE TEST CASE 1: Prevent Physical Deletion of Orders
-- =============================================================

-- Insert a new order with initial status 'In Process' (orderNumber = 1020)
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
-- VALUES (1020, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485);

-- Insert an order detail associated with this order (productCode = 'S1_1001')
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1020, 'S1_1001', 5, 100.00, 1, NULL);

-- Attempt to delete the order (invalid action)
-- Expected outcome: Error indicating that orders cannot be deleted, only cancelled
-- DELETE FROM orders
-- WHERE orderNumber = 1020;

-- Verify that the order still exists in the orders table
-- SELECT orderNumber, status, customerNumber
-- FROM orders
-- WHERE orderNumber = 1020;

-- =============================================================
-- 4AE TEST CASE 2: Verify Cancelling an Order and Inventory Update
-- =============================================================

-- Insert a new order with initial status 'In Process' (orderNumber = 1021)
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber, comments)
-- VALUES (1021, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'In Process', 485, 'Initial order for testing cancellation.');

-- Insert an order detail associated with this order (productCode = 'S1_1001', quantity = 10)
-- INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber, referenceNo)
-- VALUES (1021, 'S1_1001', 10, 100.00, 1, NULL);

-- Check current stock in `current_products` before cancellation
-- SELECT productCode, quantityInStock
-- FROM current_products
-- WHERE productCode = 'S1_1001';

-- Update the status of the order to 'Cancelled' (valid action)
-- UPDATE orders
-- SET status = 'Cancelled'
-- WHERE orderNumber = 1021;

-- Verify that the order status is updated and comment is appended
-- SELECT orderNumber, status, comments
-- FROM orders
-- WHERE orderNumber = 1021;

-- Verify that the product inventory has been restored (quantity should increase by 10)
-- SELECT productCode, quantityInStock
-- FROM current_products
-- WHERE productCode = 'S1_1001';

-- Attempt to update `quantityOrdered` of the cancelled order's details (invalid update)
-- UPDATE orderdetails
-- SET quantityOrdered = 5
-- WHERE orderNumber = 1021 AND productCode = 'S1_1001';

-- Attempt to update the `requiredDate` of the cancelled order (invalid update)
-- UPDATE orders
-- SET requiredDate = DATE_ADD(CURRENT_DATE(), INTERVAL 10 DAY)
-- WHERE orderNumber = 1021;

-- =============================================================
-- 4AE TEST CASE 3: Prevent Modifications on Cancelled Orders
-- =============================================================

-- Attempt to update the `requiredDate` of the cancelled order (orderNumber = 1021)
-- Expected outcome: Error indicating no modifications allowed for cancelled orders
-- UPDATE orders
-- SET requiredDate = DATE_ADD(CURRENT_DATE(), INTERVAL 10 DAY)
-- WHERE orderNumber = 1021;

-- Attempt to update the `status` of the cancelled order to "In Process" (invalid transition)
-- UPDATE orders
-- SET status = 'In Process'
-- WHERE orderNumber = 1021;

-- Attempt to update `quantityOrdered` of the cancelled order's details (invalid update)
-- Expected outcome: Error indicating no modifications allowed on products of a cancelled order
-- UPDATE orderdetails
-- SET quantityOrdered = 5
-- WHERE orderNumber = 1021 AND productCode = 'S1_1001';

-- Attempt to update `priceEach` of the cancelled order's details (invalid update)
-- Expected outcome: Error indicating no modifications allowed on products of a cancelled order
-- UPDATE orderdetails
-- SET priceEach = 120.00
-- WHERE orderNumber = 1021 AND productCode = 'S1_1001';

-- Attempt to delete an order detail for the cancelled order (invalid action)
-- Expected outcome: Error indicating that deletion is not allowed for cancelled orders
-- DELETE FROM orderdetails
-- WHERE orderNumber = 1021 AND productCode = 'S1_1001';

-- Verify that the cancelled order and orderdetails remain unchanged
-- SELECT orderNumber, status, requiredDate, comments
-- FROM orders
-- WHERE orderNumber = 1021;

-- SELECT orderNumber, productCode, quantityOrdered, priceEach
-- FROM orderdetails
-- WHERE orderNumber = 1021;


-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- <4A-F>: Orders that are not shipped within one week is automatically cancelled. A comment needs to be appended that it was the system that automatically
-- cancelled the order
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================

-- Part 4A-F
-- Ridz Rigat

DROP EVENT IF EXISTS 4AF_cancel_unshipped_orders_event;
DELIMITER $$
CREATE EVENT 4AF_cancel_unshipped_orders_event
ON SCHEDULE 
EVERY 7 DAY
DO
BEGIN
    UPDATE orders
    SET 
        status = 'Cancelled',
        comments = 'Automatically cancelled by system due to non-shipping within one week.'
    WHERE 
        status != 'Shipped' AND status != 'Cancelled'
        AND shippedDate IS NULL 
        AND orderDate <= DATE_SUB(CURDATE(), INTERVAL 7 DAY);
END $$
DELIMITER ;

-- SHOW PROCESSLIST;
-- SHOW EVENTS;

SET GLOBAL EVENT_SCHEDULER = OFF;
SET GLOBAL EVENT_SCHEDULER = ON;


-- SHOW VARIABLES LIKE 'event_scheduler';
																
ALTER EVENT 4AF_cancel_unshipped_orders_event DISABLE;
ALTER EVENT 4AF_cancel_unshipped_orders_event ENABLE;

-- FOR CHECKING OF THE ORDERS THAT ARE NOT SHIPPED
-- SELECT * FROM orders
-- WHERE 
--     status != 'Shipped' 
--     AND shippedDate IS NULL 
--     AND orderDate <= DATE_SUB(CURDATE(), INTERVAL 7 DAY);


-- test1
-- working since requiredDate data is more than 3 days of the order date and the orderdate is automaticall set to  CURDATE due to 4AA
-- need to adjust the device time to more than 7 days for the
-- status to be set to 'Cancelled' and comments to be set to 'Automatically cancelled by system due to non-shipping within one week.'
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
-- VALUES (1001, '2024-10-11', CURDATE() + INTERVAL 4 DAY, NULL, 'Processing', NULL, 119);

-- test2
-- working since requiredDate data is more than 3 days of the order date
-- status will be set to 'Cancelled' and comments will be set to 'Automatically cancelled by system due to non-shipping within one week.'
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
-- VALUES (1002, CURDATE(), CURDATE() + INTERVAL 5 DAY, NULL, 'Processing', "SKIP_VALIDATION", 119);

-- test3
-- working since requiredDate data is more than 3 days of the order date
-- status will be set to 'Cancelled' and comments will be set to 'Automatically cancelled by system due to non-shipping within one week.'
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
-- VALUES (1002, CURDATE(), CURDATE() + INTERVAL 4 DAY, NULL, 'Processing', NULL, 119);

-- test4
-- working since requiredDate data is more than 3 days of the order date, status will be set to In Process due to 4AA. 
-- status will be set to 'Cancelled' and comments will be set to 'Automatically cancelled by system due to non-shipping within one week.'
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
-- VALUES (1002, CURDATE(), CURDATE() + INTERVAL 4 DAY, NULL, 'Cancelled', 'cancelled by the user', 119);

-- test5
-- will not work due to 4AA before insert restriction with the 3 day rule.
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
-- VALUES (1002, CURDATE(), CURDATE() + INTERVAL 3 DAY, NULL, 'Processing', NULL, 119);

-- test6
-- will not work due to 4AA before insert restriction with the 3 day rule.
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
-- VALUES (1002, CURDATE(), CURDATE() + INTERVAL 2 DAY, NULL, 'Processing', NULL, 119);

-- test7
-- will not work due to 4AA before insert restriction with the 3 day rule.
-- INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
-- VALUES (1002, CURDATE(), CURDATE() + INTERVAL 1 DAY, NULL, 'Processing', NULL, 119);


-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4B-A: Products in Inventory records are kept organized at any given time. When products are created, it is necessary that is automatically categorized as current
-- products and its product category be defined as either product for wholesale or for retail. Provided with these definitions, their respective MSRPs must be
-- defined. The creation of relevant records should automatically be done by the system such that only the product information (including the primary product
-- line is classified under) is provided.
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- Villaroman, Raphael Luis G.
-- DBADM-103

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


DROP TRIGGER IF EXISTS 4BA_before_product_insert;
DELIMITER $$
CREATE TRIGGER 4BA_before_product_insert
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    -- Set product_type to 'R' (Retail) if it is NULL
    SET NEW.product_type = IFNULL(NEW.product_type, 'R');
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS 4BA_after_product_insert;
DELIMITER $$
CREATE TRIGGER 4BA_after_product_insert
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    -- Insert into current_products if product_category is 'C'
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
            -- Insert into product_wholesale with MSRP for wholesale products
            INSERT INTO product_wholesale (productCode, MSRP)
            VALUES (NEW.productCode, 150.00);  -- Default MSRP for wholesale
        END IF;
    END IF;
END$$
DELIMITER ;




-- =============================================================
-- 4BA TEST CASE 1: Inserting a Retail Product
-- =============================================================

-- Insert a new retail product into the `products` table
-- Expected outcome: The product is added to `current_products`, `product_retail`, and `product_pricing`
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
VALUES ('S1_2000', 'Retail Product Test', '1:12', 'Retail Vendor', 'Retail product for testing', 75.00, 'C', 'R');

-- Verify the product is added to `current_products`
SELECT productCode, product_type, quantityInStock
FROM current_products
WHERE productCode = 'S1_2000';

-- Verify the product is added to `product_retail`
SELECT productCode
FROM product_retail
WHERE productCode = 'S1_2000';

-- Verify the product pricing details in `product_pricing`
SELECT productCode, startdate, enddate, MSRP
FROM product_pricing
WHERE productCode = 'S1_2000';

-- =============================================================
-- 4BA TEST CASE 2: Inserting a Wholesale Product
-- =============================================================

-- Insert a new wholesale product into the `products` table
-- Expected outcome: The product is added to `current_products` and `product_wholesale`
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
VALUES ('S1_2001', 'Wholesale Product Test', '1:12', 'Wholesale Vendor', 'Wholesale product for testing', 85.00, 'C', 'W');

-- Verify the product is added to `current_products`
SELECT productCode, product_type, quantityInStock
FROM current_products
WHERE productCode = 'S1_2001';

-- Verify the product is added to `product_wholesale` with MSRP details
SELECT productCode, MSRP
FROM product_wholesale
WHERE productCode = 'S1_2001';

-- =============================================================
-- 4BA TEST CASE 3: Inserting a Product Without `product_type`
-- =============================================================

-- Insert a new product without specifying `product_type`
-- Expected outcome: The system assumes `product_type` as 'R' (retail) and categorizes accordingly
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category)
VALUES ('S1_2002', 'No Type Product Test', '1:12', 'No Type Vendor', 'Product without type for testing', 65.00, 'C');

-- Verify the product is added to `current_products` as retail
SELECT productCode, product_type, quantityInStock
FROM current_products
WHERE productCode = 'S1_2002';

-- Verify the product is added to `product_retail`
SELECT productCode
FROM product_retail
WHERE productCode = 'S1_2002';

-- Verify the product pricing details in `product_pricing`
SELECT productCode, startdate, enddate, MSRP
FROM product_pricing
WHERE productCode = 'S1_2002';

-- =============================================================
-- 4BA TEST CASE 4: Inserting a Product with `product_category` Not Equal to 'C'
-- =============================================================

-- Insert a new product with `product_category` set to 'D' (Discontinued)
-- Expected outcome: The product should be inserted into the `products` table but should not appear in `current_products`, `product_retail`, or `product_wholesale`
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
VALUES ('S1_2003', 'Discontinued Product Test', '1:12', 'Test Vendor', 'Discontinued product', 55.00, 'D', 'R');

-- Verify no entry is made in `current_products`
SELECT productCode
FROM current_products
WHERE productCode = 'S1_2003';

-- Verify no entry is made in `product_retail`
SELECT productCode
FROM product_retail
WHERE productCode = 'S1_2003';

-- Verify no entry is made in `product_wholesale`
SELECT productCode
FROM product_wholesale
WHERE productCode = 'S1_2003';


-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4B-B: When products are created, additional product lines it is classified under can be defined. Product’s product lines can be deleted, and new product lines can
-- be defined the product will be classified under (When products are created, they can be assigned to multiple product lines. Existing product lines can be removed, and new product lines can be added to classify the product differently)
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================

-- Drop Existing Triggers
DROP TRIGGER IF EXISTS 4BB_product_creation_classification;
DROP TRIGGER IF EXISTS 4BB_add_productline_classification;
DROP TRIGGER IF EXISTS 4BB_delete_productline_classification;

-- Create Product Creation Classification Trigger
DELIMITER $$
CREATE TRIGGER 4BB_product_creation_classification
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    -- Default product line classification
    INSERT INTO product_productlines (productCode, productLine)
    VALUES (NEW.productCode, 'Classic Cars');
END$$
DELIMITER ;

-- Create Trigger for Adding Product Line Classification
DELIMITER $$
CREATE TRIGGER 4BB_add_productline_classification
BEFORE INSERT ON product_productlines
FOR EACH ROW
BEGIN
    DECLARE duplicate_error_message VARCHAR(255);

    -- Ensure the product exists before allowing classification
    IF (SELECT COUNT(*) FROM products WHERE productCode = NEW.productCode) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot classify under new product line: Product does not exist';
    END IF;

    -- Ensure uniqueness of the classification
    IF (SELECT COUNT(*) FROM product_productlines WHERE productCode = NEW.productCode AND productLine = NEW.productLine) > 0 THEN
        SET duplicate_error_message = CONCAT('Duplicate classification found: Product ', NEW.productCode, ' is already classified under the product line ', NEW.productLine);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = duplicate_error_message;
    END IF;
END$$
DELIMITER ;

-- Create Trigger for Deleting Product Line Classification
DELIMITER $$
CREATE TRIGGER 4BB_delete_productline_classification
BEFORE DELETE ON productlines
FOR EACH ROW
BEGIN
    DECLARE error_message VARCHAR(255);

    -- Ensure there are no products classified under this product line before allowing deletion
    IF (SELECT COUNT(*) FROM product_productlines WHERE productLine = OLD.productLine) > 0 THEN
        SET error_message = CONCAT('Cannot delete product line ', OLD.productLine, ' because there are existing products classified under it');
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = error_message;
    END IF;
END$$
DELIMITER ;


-- Alter `product_productlines` Table to Add Foreign Key Constraint for Automatic Cleanup
ALTER TABLE product_productlines
DROP FOREIGN KEY fk_product_productlines;

ALTER TABLE product_productlines
ADD CONSTRAINT fk_product_productlines
FOREIGN KEY (productCode)
REFERENCES products (productCode)
ON DELETE CASCADE;

-- Add Unique Constraint to `product_productlines` Table to Prevent Duplicate Classifications
ALTER TABLE product_productlines
ADD CONSTRAINT uq_product_productline UNIQUE (productCode, productLine);




-- =============================================================
-- 4BB TEST CASE 1: Product Creation Classification to Default Product Line
-- =============================================================

-- Insert a new product into the `products` table
-- Expected outcome: The product is automatically classified under the "Classic Cars" product line
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
VALUES ('S1_3000', 'Classic Car Product Test', '1:12', 'Classic Vendor', 'Classic car for testing', 95.00, 'C', 'R');

-- Verify the product is added to `product_productlines` under "Classic Cars"
SELECT productCode, productLine
FROM product_productlines
WHERE productCode = 'S1_3000';

-- =============================================================
-- 4BB TEST CASE 2: Adding a New Product Line Classification
-- =============================================================

-- Insert a new product line "Sports Cars" into the `productlines` table
-- Expected outcome: The new product line is successfully added
INSERT INTO productlines (productLine, textDescription)
VALUES ('Sports Cars', 'A product line for sports cars, focusing on high-performance vehicles.');

-- Insert a new classification for an existing product
-- Expected outcome: Product classification is added successfully under a new product line
INSERT INTO product_productlines (productCode, productLine)
VALUES ('S1_3000', 'Sports Cars');

-- Verify that the product is now classified under both "Classic Cars" and "Sports Cars"
SELECT productCode, productLine
FROM product_productlines
WHERE productCode = 'S1_3000';

-- Attempt to insert a duplicate classification
-- Expected outcome: Insertion fails due to unique constraint on `(productCode, productLine)`
INSERT INTO product_productlines (productCode, productLine)
VALUES ('S1_3000', 'Classic Cars');

-- =============================================================
-- 4BB TEST CASE 3: Handling Product Classification When Product Does Not Exist
-- =============================================================

-- Attempt to classify a non-existent product
-- Expected outcome: Insertion fails with an error message
INSERT INTO product_productlines (productCode, productLine)
VALUES ('S1_9999', 'Luxury Cars');

-- =============================================================
-- 4BB TEST CASE 4: Preventing Deletion of Product Line with Existing Product Classifications
-- =============================================================

-- Attempt to delete the "Classic Cars" product line
-- Expected outcome: Deletion fails with an error message indicating that there are existing products classified under this line
DELETE FROM productlines
WHERE productLine = 'Classic Cars';

-- Verify the product line still exists
SELECT productLine
FROM productlines
WHERE productLine = 'Classic Cars';


-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4B-C: Product MSRPs should be retrieved from the system without the need for the relevant records to be exposed to any users. This will alleviate the need to go
-- through several records just to retrieve the appropriate MSRP for a specific product.
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================

-- Villaroman, Raphael Luis G.
-- DBADM-103

-- TO DO:
-- Check if a product is classified as retail or wholesale
-- If retail, it retrieves the MSRP from the product_pricing table
-- If wholesale, it retrieves the MSRP from the product_wholesale table
-- Check retail first; if it does not exist, check wholesale next
-- Throw an error if it is not found in either

DROP FUNCTION IF EXISTS 4BC_getProductMSRP;
DELIMITER $$
CREATE FUNCTION 4BC_getProductMSRP(param_productCode VARCHAR(15)) 
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE var_MSRP DECIMAL(9,2);
    DECLARE errormessage VARCHAR(200);

    -- First, check if the product is retail
    IF EXISTS (SELECT 1 FROM product_retail WHERE productCode = param_productCode) THEN
        -- Retail product found, get the latest MSRP from product_pricing within the valid date range
        SELECT MSRP INTO var_MSRP
        FROM product_pricing
        WHERE productCode = param_productCode
          AND CURDATE() BETWEEN startdate AND enddate
        ORDER BY enddate DESC
        LIMIT 1;

        -- If MSRP is found for retail, return it
        IF var_MSRP IS NOT NULL THEN
            RETURN var_MSRP;
        END IF;
    END IF;

    -- If no valid MSRP for retail, check if the product is wholesale
    IF EXISTS (SELECT 1 FROM product_wholesale WHERE productCode = param_productCode) THEN
        -- Wholesale product found, get MSRP from product_wholesale
        SELECT MSRP INTO var_MSRP
        FROM product_wholesale
        WHERE productCode = param_productCode;
        
        -- If MSRP is found for wholesale, return it
        IF var_MSRP IS NOT NULL THEN
            RETURN var_MSRP;
        END IF;
    END IF;

    -- If the product is found in neither retail nor wholesale
    SET errormessage := "Product not found";
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;

END$$
DELIMITER ;




-- =============================================================
-- 4BC TEST CASE 1: Retrieve MSRP for Retail Product
-- =============================================================

-- Insert test product classified as retail
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
VALUES ('S1_4000', 'Retail Test Product', '1:18', 'Test Vendor', 'Retail product for MSRP test', 80.00, 'C', 'R');


-- Add MSRP for retail product in the product_pricing table
INSERT INTO product_pricing (productCode, startdate, enddate, MSRP)
VALUES ('S1_4000', CURDATE() - INTERVAL 1 MONTH, CURDATE() + INTERVAL 1 MONTH, 120.00);

-- Call function to retrieve MSRP for the retail product
SELECT 4BC_getProductMSRP('S1_4000') AS MSRP;

-- =============================================================
-- 4BC TEST CASE 2: Retrieve MSRP for Wholesale Product
-- =============================================================

-- Insert test product classified as wholesale
INSERT INTO products (productCode, productName, productScale, productVendor, productDescription, buyPrice, product_category, product_type)
VALUES ('S1_4001', 'Wholesale Test Product', '1:18', 'Test Vendor', 'Wholesale product for MSRP test', 100.00, 'C', 'W');


-- Call function to retrieve MSRP for the wholesale product
SELECT 4BC_getProductMSRP('S1_4001') AS MSRP;

-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- 4B-D: Products categories cannot be modified. This means that products that are already categorized as wholesale cannot be retail
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
-- ========================================================================================================================================================================================================================================================================
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

-- -- test1
-- -- should not update since you cannot go modify product categories.
-- UPDATE current_products
-- SET product_type = 'W'
-- WHERE productCode = 'S10_1678'; 

-- -- test2
-- -- should not update since you cannot go modify product categories.
-- UPDATE current_products
-- SET product_type = 'W'
-- WHERE productCode = 'S10_1949'; 

-- -- test3
-- -- should work but no changes since the product_type is already set to 'R'
-- UPDATE current_products
-- SET product_type = 'R'
-- WHERE productCode = 'S10_1949'; 
