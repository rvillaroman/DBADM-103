DROP TABLE IF EXISTS `job_titles`;
CREATE TABLE `job_titles` (
  `jobTitleID` INT NOT NULL AUTO_INCREMENT,
  `jobTitle` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`jobTitleID`)
);

-- Insert controlled job titles
INSERT INTO `job_titles` VALUES 
(1,'President'),
(2,'VP Sales'),
(3,'VP Marketing'),
(4,'Sales Manager (APAC)'),
(5,'Sales Manager (EMEA)'),
(6,'Sales Manager (NA)'),
(7,'Sales Rep'),
(8,'Inventory Manager');


CREATE TABLE IF NOT EXISTS `employee_types` (
    `employeeType` VARCHAR(20) PRIMARY KEY
);

DROP TABLE IF EXISTS `employee_types`;
CREATE TABLE `employee_types` (
    `employeeType` VARCHAR(2) PRIMARY KEY
);

-- Insert restricted employee types with abbreviations
INSERT INTO `employee_types` (employeeType) VALUES
('SR'), -- Sales Representative
('SM'), -- Sales Manager
('IM'), -- Inventory Manager
('N');  -- Non-Sales Representative


ALTER TABLE `employees`
ADD COLUMN jobTitleID INT,
ADD COLUMN employee_type VARCHAR(2);

-- Add foreign key constraints
ALTER TABLE `employees`
ADD CONSTRAINT fk_jobTitleID
FOREIGN KEY (jobTitleID) REFERENCES job_titles(jobTitleID);

ALTER TABLE `employees`
ADD CONSTRAINT fk_employeeType
FOREIGN KEY (employee_type) REFERENCES employee_types(employeeType);


CREATE TABLE IF NOT EXISTS `employee_audit` (
    `audit_id` INT AUTO_INCREMENT PRIMARY KEY,
    `employeeNumber` INT,
    `old_employee_type` VARCHAR(2),
    `new_employee_type` VARCHAR(2),
    `change_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `changed_by` VARCHAR(50),
    `reason` VARCHAR(255),
    FOREIGN KEY (employeeNumber) REFERENCES employees(employeeNumber)
);


DELIMITER $$

CREATE TRIGGER employee_type_BEFORE_UPDATE
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE reason VARCHAR(255);
    DECLARE changed_by VARCHAR(50);

    -- Check if the employee type is changing
    IF OLD.employee_type <> NEW.employee_type THEN
        
        -- Set "System" as the changer for system-triggered updates
        IF USER() LIKE 'system%' THEN
            SET changed_by = 'System';
            SET reason = 'Automatic update due to role re-assignment';
        ELSE
            SET changed_by = USER(); -- Log the actual user performing the update
            SET reason = 'Manual update';
        END IF;

        -- Insert change details into the audit table
        INSERT INTO employee_audit (employeeNumber, old_employee_type, new_employee_type, changed_by, reason)
        VALUES (OLD.employeeNumber, OLD.employee_type, NEW.employee_type, changed_by, reason);
    END IF;
END $$

DELIMITER ;


