-- salesModule, paymentModule, inventoryModule, customerModule, employeeModule

CREATE USER 'salesmodule' 		IDENTIFIED BY 'DLSU1234!';
CREATE USER 'inventorymodule' 	IDENTIFIED BY 'DLSU1234!';
CREATE USER 'customermodule'    IDENTIFIED BY 'DLSU1234!';
CREATE USER 'employeemodule'	IDENTIFIED BY 'DLSU1234!';
CREATE USER 'paymentmodule'		IDENTIFIED BY 'DLSU1234!';


GRANT SELECT, INSERT, UPDATE, DELETE	on bank