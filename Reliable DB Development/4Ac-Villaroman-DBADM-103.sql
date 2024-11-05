-- Villaroman, Raphael Luis G.
-- DBADM-103

-- 4A-C START
-- Function to check if the status value is valid
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

-- Function to check if the transition from old to new status is valid based on the defined sequence
DROP FUNCTION IF EXISTS isValidStatus;
DELIMITER $$
CREATE FUNCTION isValidStatus(param_oldstatus VARCHAR(15), param_newstatus VARCHAR(15))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE errormessage VARCHAR(200);
    
    IF (param_oldstatus = param_newstatus) THEN RETURN TRUE;
    END IF;
    
    IF (NOT isStatusValid(param_oldstatus) OR NOT isStatusValid(param_newstatus)) THEN
        SET errormessage := CONCAT("Either ", param_oldstatus, " or ", param_newstatus, " is not a valid status");
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Valid status transitions
    IF (param_oldstatus = "In Process" AND param_newstatus != "Shipped") THEN
        SET errormessage := "Transition from In Process to any status other than Shipped is not allowed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    IF (param_oldstatus = "Shipped" AND param_newstatus NOT IN ("Disputed", "Completed")) THEN
        SET errormessage := "Transition from Shipped is only allowed to Disputed or Completed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    IF (param_oldstatus = "Disputed" AND param_newstatus != "Resolved") THEN
        SET errormessage := "Transition from Disputed is only allowed to Resolved";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;
    
    IF (param_oldstatus = "Resolved" AND param_newstatus != "Completed") THEN
        SET errormessage := "Transition from Resolved is only allowed to Completed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    -- Prevent backward status transitions
    IF (param_newstatus = "In Process" AND param_oldstatus IN ("Shipped", "Disputed", "Resolved", "Completed")) THEN
        SET errormessage := "Reverting status backward is not allowed";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errormessage;
    END IF;

    RETURN TRUE;
END $$
DELIMITER ;


-- Trigger to enforce order update rules on status, requiredDate, and comments
DROP TRIGGER IF EXISTS before_order_update;
DELIMITER $$
CREATE TRIGGER before_order_update
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    DECLARE errormessage VARCHAR(200);

    -- Validate status transition
    IF (NEW.status IS NOT NULL AND OLD.status != NEW.status) THEN
        IF (NOT isValidStatus(OLD.status, NEW.status)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid status transition';
        END IF;
        
        -- Prevent updates if status is "Completed"
        IF (OLD.status = "Completed") THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No updates allowed for orders with Completed status';
        END IF;
    END IF;

    -- Set shippedDate if status is "Shipped"
    IF (NEW.status = "Shipped" AND OLD.status = "Shipped" AND NEW.shippedDate IS NULL) THEN
        SET NEW.shippedDate = NOW();
    END IF;

    -- Prevent shippedDate changes if status is not "Shipped"
    IF (NEW.status = "Shipped" AND NEW.shippedDate IS NOT NULL AND OLD.shippedDate != NEW.shippedDate) THEN
        IF (OLD.status != "Shipped") THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot set shippedDate unless status is Shipped';
        END IF;
        
        -- Disallow direct modification of shippedDate if already set
        IF (OLD.shippedDate IS NOT NULL AND NEW.shippedDate != OLD.shippedDate) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot modify shippedDate directly for a shipped order';
        END IF;
    END IF;

    -- Append comments instead of overwriting
    IF (NEW.comments IS NOT NULL AND NEW.comments != OLD.comments) THEN
        SET NEW.comments = CONCAT(OLD.comments, ' ', NEW.comments);
    END IF;

    -- Restrict updates to requiredDate, status, and comments only
    IF (OLD.orderDate != NEW.orderDate OR OLD.customerNumber != NEW.customerNumber) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Only requiredDate, status, and comments can be updated';
    END IF;
    
    -- Acknowledge update of requiredDate if it's the only change
    IF (NEW.requiredDate != OLD.requiredDate AND OLD.status != "Completed") THEN
        SET NEW.requiredDate = NEW.requiredDate;
    END IF;
END $$
DELIMITER ;


-- 4A-C END

-- Test Case 1: In Process to Shipped
-- UPDATE orders
-- SET status = 'Shipped', requiredDate = '2024-12-15', comments = 'Order has been processed'
-- WHERE orderNumber = 10100;

-- Test Case 2: Invalid Status Transition
-- UPDATE orders
-- SET status = 'Resolved', comments = 'Shipped to Resolved'
-- WHERE orderNumber = 10101;

-- Test Case 3: Setting shippedDate When Status is Not Shipped
-- UPDATE orders
-- SET shippedDate = '2024-11-15 00:00:00', comments = 'Setting shippedDate when status is not Shipped'
-- WHERE orderNumber = 11012;

-- Test Case 3: Setting In Process to Shipped
-- UPDATE orders
-- SET status = 'Shipped'
-- WHERE orderNumber = 10423;

-- Test Case 4: Setting Shipped to Completed
-- UPDATE orders 
-- SET status = 'Completed', comments = 'Order completed successfully' 
-- WHERE orderNumber = '10104';

-- Test Case 5: Setting Shipped to Disputed
-- UPDATE orders 
-- SET status = 'Disputed', comments = 'Order disputed'
-- WHERE orderNumber = '10105';
