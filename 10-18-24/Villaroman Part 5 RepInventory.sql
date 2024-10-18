DROP TABLE IF EXISTS reports_inventory;
CREATE TABLE reports_inventory (
reportid INT(10) AUTO_INCREMENT,
generationdate DATETIME,
generatedby VARCHAR(100),
reportdesc VARCHAR(100),
reporttype ENUM('Sales', 'Discounts', 'Markups', 
				'Quantity Ordered', 'Turnaround Time', 
				'Pricing Variation'),
time_dimension_year INT(4),
time_dimension_month INT(2),
PRIMARY KEY (reportid)
);