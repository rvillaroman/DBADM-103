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
