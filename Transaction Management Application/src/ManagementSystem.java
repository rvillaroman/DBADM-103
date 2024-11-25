// DBADM-103

// javac -cp ".;mysql-connector-j-9.0.0.jar" ManagementSystem.java
// java -cp ".;C:\Users\XG755N\Documents\GitHub\DBADM-103\Transaction Management Application\lib\mysql-connector-j-9.0.0.jar" ManagementSystem


import java.sql.*;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class ManagementSystem {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "p@ssword";

    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Connection Successful");

            Scanner scanner = new Scanner(System.in);
            while (true) {
                System.out.println("\n=== Management System Menu ===");
                System.out.println("1. Product Management");
                System.out.println("2. Employee Management");
                System.out.println("3. Office Management");
                System.out.println("4. Order Management");
                System.out.println("5. Exit");
                System.out.print("Enter your choice: ");
                int choice = scanner.nextInt();

                switch (choice) {
                    case 1:
                        productManagementMenu(conn, scanner);
                        break;
                    case 2:
                        employeeManagementMenu(conn, scanner);
                        break;
                    case 3:
                        officeManagementMenu(scanner);
                        break;
                    case 4:
                        orderManagementMenu(scanner);
                        break;
                    case 5:
                        System.out.println("Exiting program.");
                        conn.close();
                        return;
                    default:
                        System.out.println("Invalid choice. Please try again.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Product Management Menu
    private static void productManagementMenu(Connection conn, Scanner scanner) {
        while (true) {
            System.out.println("\n=== Product Management Menu ===");
            System.out.println("1. View a Product");
            System.out.println("2. Update Product Quantity");
            System.out.println("3. Deactivate a Product");
            System.out.println("4. Return to Main Menu");
            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    viewProduct(conn, scanner);
                    break;
                case 2:
                    updateProductQuantity(conn, scanner);
                    break;
                case 3:
                    deactivateProduct(conn, scanner);
                    break;
                case 4:
                    return;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        }
    }

    private static void viewProduct(Connection conn, Scanner scanner) {
        try {
            conn.setAutoCommit(false);

            System.out.print("\nEnter Product Code: ");
            String productCode = scanner.next();

            System.out.println("Checking for locks. Please wait up to 10 seconds...");

            // Simulate waiting for lock
            TimeUnit.SECONDS.sleep(10);

            // READ LOCK
            String query = """
                    SELECT p.productName, p.productLine, p.buyPrice, p.quantityInStock, pl.textDescription
                    FROM products p
                    JOIN productlines pl ON p.productLine = pl.productLine
                    WHERE p.productCode = ?
                    LOCK IN SHARE MODE;
                    """;

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, productCode);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("\nProduct Details:");
                System.out.println("Name: " + rs.getString("productName"));
                System.out.println("Line: " + rs.getString("productLine"));
                System.out.println("Description: " + rs.getString("textDescription"));
                System.out.println("Price: " + rs.getDouble("buyPrice"));
                System.out.println("Stock: " + rs.getInt("quantityInStock"));

                System.out.println("\nPress any key to release the lock...");
                scanner.nextLine();
                scanner.nextLine();
            } else {
                System.out.println("Product not found.");
            }

            conn.commit();
        } catch (SQLException e) {
            System.err.println("Error viewing product. Another transaction might be holding a lock.");
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("Error during rollback.");
            }
        } catch (InterruptedException ex) {
            System.err.println("Error during sleep: " + ex.getMessage());
            Thread.currentThread().interrupt();
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("Error resetting auto-commit.");
            }
        }
    }

    private static void updateProductQuantity(Connection conn, Scanner scanner) {
        try {
            conn.setAutoCommit(false);

            System.out.print("\nEnter Product Code: ");
            String productCode = scanner.next();

            System.out.print("Enter New Quantity: ");
            int newQuantity = scanner.nextInt();

            System.out.println("Checking for locks. Please wait up to 10 seconds...");

            TimeUnit.SECONDS.sleep(10);

            // WRITE LOCK
            String lockQuery = """
                    SELECT productName, quantityInStock
                    FROM products
                    WHERE productCode = ?
                    FOR UPDATE;
                    """;

            PreparedStatement lockStmt = conn.prepareStatement(lockQuery);
            lockStmt.setString(1, productCode);
            ResultSet lockRs = lockStmt.executeQuery();

            if (lockRs.next()) {
                System.out.println("\nCurrent Stock: " + lockRs.getInt("quantityInStock"));
                System.out.println("\nPress any key to update...");
                scanner.nextLine();
                scanner.nextLine();

                String updateQuery = """
                        UPDATE products
                        SET quantityInStock = ?
                        WHERE productCode = ?;
                        """;

                PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setInt(1, newQuantity);
                updateStmt.setString(2, productCode);
                int rowsUpdated = updateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    System.out.println("Quantity updated successfully.");
                } else {
                    System.out.println("Product not found.");
                }
            } else {
                System.out.println("Product not found.");
            }

            conn.commit();
        } catch (SQLException e) {
            System.err.println("Error updating product quantity. Another transaction might be holding a lock.");
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("Error during rollback.");
            }
        } catch (InterruptedException ex) {
            System.err.println("Error during sleep: " + ex.getMessage());
            Thread.currentThread().interrupt();
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("Error resetting auto-commit.");
            }
        }
    }

    private static void deactivateProduct(Connection conn, Scanner scanner) {
        try {
            conn.setAutoCommit(false);

            System.out.print("\nEnter Product Code to Deactivate: ");
            String productCode = scanner.next();

            System.out.println("Checking for locks. Please wait up to 10 seconds...");
            TimeUnit.SECONDS.sleep(10);

            // WRITE LOCK
            String lockQuery = """
                    SELECT productName, productLine, buyPrice, quantityInStock
                    FROM products
                    WHERE productCode = ?
                    FOR UPDATE;
                    """;

            PreparedStatement lockStmt = conn.prepareStatement(lockQuery);
            lockStmt.setString(1, productCode);
            ResultSet lockRs = lockStmt.executeQuery();

            if (lockRs.next()) {
                System.out.println("\nProduct Details:");
                System.out.println("Name: " + lockRs.getString("productName"));
                System.out.println("Line: " + lockRs.getString("productLine"));
                System.out.println("Price: " + lockRs.getDouble("buyPrice"));
                System.out.println("Stock: " + lockRs.getInt("quantityInStock"));

                System.out.println("\nPress any key to deactivate...");
                scanner.nextLine();
                scanner.nextLine();

                String deactivateQuery = """
                        UPDATE products
                        SET quantityInStock = -1
                        WHERE productCode = ?;
                        """;

                PreparedStatement deactivateStmt = conn.prepareStatement(deactivateQuery);
                deactivateStmt.setString(1, productCode);
                int rowsUpdated = deactivateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    System.out.println("Product deactivated successfully.");
                } else {
                    System.out.println("Product not found.");
                }
            } else {
                System.out.println("Product not found.");
            }

            conn.commit();
        } catch (SQLException e) {
            System.err.println("Error deactivating product. Another transaction might be holding a lock.");
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("Error during rollback.");
            }
        } catch (InterruptedException ex) {
            System.err.println("Error during sleep: " + ex.getMessage());
            Thread.currentThread().interrupt();
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                System.err.println("Error resetting auto-commit.");
            }
        }
    }

    // Employee Management Menu
    private static void employeeManagementMenu(Connection conn, Scanner scanner) {
        while (true) {
            System.out.println("\n=== Employee Management Menu ===");
            System.out.println("1. View an Employee");
            System.out.println("2. Disable an Employee");
            System.out.println("3. Return to Main Menu");
            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    viewEmployee(conn, scanner);
                    break;
                case 2:
                    disableEmployee(conn, scanner);
                    break;
                case 3:
                    return;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        }
    }

    /*

Villaroman, Raphael Luis
11935901
DBADM-103
Employee Management

======================
VIEW EMPLOYEE PROCESS
======================
01 Ask the user for the Employee Number to view
02 Query the database to retrieve employee details using a FOR SHARE (read lock):
   - Lock is applied to the employee row
   - This ensures the employee row cannot be modified or deleted while being viewed
   - Other transactions can still read the row
03 Retrieve and display the employee's details
04 Query the database to retrieve customers assigned to the employee using a FOR SHARE (read lock):
   - Lock is applied to the customer rows linked to the employee
   - This ensures the customer rows cannot be modified or reassigned while being viewed
05 Display the list of customers assigned to the employee
06 Ask the user if they want to view another employee (Y/N)
07 If "Y", loop back to step 01
08 If "N", commit the transaction:
   - The read locks on the employee and customer rows are released
======================
LOCK TIMING SUMMARY
======================
- FOR SHARE (view employee):
  Applied when retrieving employee and customer rows for viewing
  Released after the transaction is committed

*/

    private static void viewEmployee(Connection conn, Scanner scanner) {
        boolean[] isWaiting = {true}; // spinner control shared variable
        try {
            conn.setAutoCommit(false); // disable auto-commit for locking
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ); // ensure consistent reads

            while (true) {
                System.out.print("\nEnter Employee Number: ");
                int employeeNumber = scanner.nextInt();

                // initialize spinner
                ExecutorService executor = Executors.newSingleThreadExecutor();
                executor.submit(() -> {
                    String[] spinner = {"-", "\\", "|", "/"};
                    int index = 0;
                    while (isWaiting[0]) {
                        System.out.print("\rWaiting to view employee details " + spinner[index]);
                        index = (index + 1) % spinner.length;
                        try {
                            Thread.sleep(200);
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                    System.out.print("\r");
                });

                String query = """
                    SELECT e.lastName, e.firstName, e.jobTitle, e.email
                    FROM employees e
                    WHERE e.employeeNumber = ?
                    FOR SHARE;
                    /*
                     * FOR SHARE lock:
                     * ensures that the row(s) being read cannot be modified or deleted by other transactions 
                     * while this transaction is still active.
                     */
                    """;

                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, employeeNumber);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    isWaiting[0] = false; // stop the spinner
                    executor.shutdown();

                    System.out.println("\nEmployee Details:");
                    System.out.println("Name: " + rs.getString("lastName") + ", " + rs.getString("firstName"));
                    System.out.println("Job: " + rs.getString("jobTitle"));
                    System.out.println("E-mail: " + rs.getString("email"));

                    // query customers linked to the employee
                    String customerQuery = """
                        SELECT customerName
                        FROM customers
                        WHERE salesRepEmployeeNumber = ?
                        FOR SHARE;
                        /*
                         * FOR SHARE lock:
                         * locks customer rows associated with the employee being viewed,
                         * ensuring no modifications (e.g., reassignment or deletion) can happen until the transaction ends.
                         */
                        """;

                    PreparedStatement custStmt = conn.prepareStatement(customerQuery);
                    custStmt.setInt(1, employeeNumber);
                    ResultSet custRs = custStmt.executeQuery();

                    System.out.println("\nAssigned Customers:");
                    boolean hasCustomers = false;
                    while (custRs.next()) {
                        System.out.println("- " + custRs.getString("customerName"));
                        hasCustomers = true;
                    }
                    if (!hasCustomers) {
                        System.out.println("No customers are assigned to this employee.");
                    }
                } else {
                    isWaiting[0] = false; // stop the spinner
                    executor.shutdown();
                    System.out.println("Employee does not exist.");
                }

                System.out.print("\nDo you want to view another employee? (Y/N): ");
                String response = scanner.next().trim().toUpperCase();
                if (!response.equals("Y")) {
                    conn.commit(); // release the lock when user exits
                    break;
                }
            }
        } catch (SQLException e) {
            try {
                conn.rollback(); // rollback to release locks
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            isWaiting[0] = false; // ensure spinner stops
            try {
                conn.setAutoCommit(true); // re-enable auto-commit
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }


/*
======================
DISABLE EMPLOYEE PROCESS
======================
01 Ask the user for the Employee Number to disable
02 Query the database to retrieve employee details using a FOR UPDATE (write lock):
   - Lock is applied to the employee row
   - This ensures no other transaction can read, update, or delete the row while this transaction is ongoing
03 Retrieve and display the employee's details
04 Check if the employee is already deactivated (negative employeeNumber)
05 Check if the employee is a "Sales Rep" (only Sales Reps can be deactivated)
06 Ask the user for confirmation to proceed (Y/N)
07 If "N", rollback the transaction:
   - The write lock on the employee row is released, and no changes are made
08 If "Y", reassign all customers assigned to this employee:
   - The customers linked to the employee are updated without applying new locks since they inherit the write lock from the employee
09 Deactivate the employee by updating their employeeNumber to a negative value:
   - The write lock ensures no other transaction interferes with the update
10 Commit the transaction:
   - The write lock on the employee row and inherited locks on customer rows are released
11 Display a success message indicating the employee has been deactivated and customers reassigned
12 Ask the user if they want to disable another employee (Y/N)
13 If "Y", loop back to step 01
14 If "N", exit
======================
LOCK TIMING SUMMARY
======================
- FOR UPDATE (disable employee):
  Applied when retrieving the employee row to disable
  Ensures no other transaction can interfere with the employee row until the transaction is committed or rolled back

*/


    private static void disableEmployee(Connection conn, Scanner scanner) {
        boolean[] isWaiting = {true};
        try {
            conn.setAutoCommit(false); // disable auto-commit for locking
            conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ); // ensure consistent reads

            while (true) {
                System.out.print("\nEnter Employee Number to Disable: ");
                int employeeNumber = scanner.nextInt();

                // reinitialize spinner executor
                ExecutorService executor = Executors.newSingleThreadExecutor();
                executor.submit(() -> {
                    String[] spinner = {"-", "\\", "|", "/"};
                    int index = 0;
                    while (isWaiting[0]) {
                        System.out.print("\rWaiting for a prior transaction to complete " + spinner[index]);
                        index = (index + 1) % spinner.length;
                        try {
                            Thread.sleep(200);
                        } catch (InterruptedException e) {
                            Thread.currentThread().interrupt();
                        }
                    }
                    System.out.print("\r");
                });

                String lockEmployeeQuery = """
                SELECT e.lastName, e.firstName, e.jobTitle, e.email, e.employeeNumber
                FROM employees e
                WHERE e.employeeNumber = ?
                FOR UPDATE;
                """;

                PreparedStatement empStmt = conn.prepareStatement(lockEmployeeQuery);
                empStmt.setInt(1, employeeNumber);
                ResultSet empRs = empStmt.executeQuery(); // lock is applied here

                if (empRs.next()) {
                    isWaiting[0] = false; // stop the spinner
                    executor.shutdown();

                    int currentEmployeeNumber = empRs.getInt("employeeNumber");
                    if (currentEmployeeNumber < 0) { // check if already deactivated
                        System.out.println("\nError: This employee is already deactivated.");
                        System.out.print("Do you want to try another employee? (Y/N): ");
                        String retryResponse = scanner.next().trim().toUpperCase();
                        if (!retryResponse.equals("Y")) {
                            conn.rollback();
                            break;
                        } else {
                            conn.rollback();
                            continue;
                        }
                    }

                    String jobTitle = empRs.getString("jobTitle");
                    if (!jobTitle.equalsIgnoreCase("Sales Rep")) {
                        System.out.println("\nError: Only employees with the title 'Sales Rep' can be disabled.");
                        System.out.print("Do you want to try another employee? (Y/N): ");
                        String retryResponse = scanner.next().trim().toUpperCase();
                        if (!retryResponse.equals("Y")) {
                            conn.rollback();
                            break;
                        } else {
                            conn.rollback();
                            continue;
                        }
                    }

                    System.out.println("\nEmployee Details:");
                    System.out.println("Name: " + empRs.getString("lastName") + ", " + empRs.getString("firstName"));
                    System.out.println("Job: " + empRs.getString("jobTitle"));
                    System.out.println("E-mail: " + empRs.getString("email"));

                    System.out.print("\nAre you sure you want to deactivate this employee? (Y/N): ");
                    String response = scanner.next().trim().toUpperCase();
                    if (!response.equals("Y")) {
                        System.out.println("Deactivation canceled.");
                        System.out.print("Do you want to try another employee? (Y/N): ");
                        String retryResponse = scanner.next().trim().toUpperCase();
                        if (!retryResponse.equals("Y")) {
                            conn.rollback();
                            break;
                        } else {
                            conn.rollback();
                            continue;
                        }
                    }

                    // reassign customers
                    String reassignCustomersQuery = """
                    UPDATE customers
                    SET salesRepEmployeeNumber = 1165
                    WHERE salesRepEmployeeNumber = ?;
                    """;

                    PreparedStatement reassignCustomersStmt = conn.prepareStatement(reassignCustomersQuery);
                    reassignCustomersStmt.setInt(1, employeeNumber);
                    int customersUpdated = reassignCustomersStmt.executeUpdate();

                    // deactivate the employee
                    String deactivateEmployeeQuery = """
                    UPDATE employees
                    SET employeeNumber = ?
                    WHERE employeeNumber = ?;
                    """;

                    PreparedStatement deactivateStmt = conn.prepareStatement(deactivateEmployeeQuery);
                    deactivateStmt.setInt(1, -employeeNumber);
                    deactivateStmt.setInt(2, employeeNumber);
                    int rowsUpdated = deactivateStmt.executeUpdate();

                    conn.commit();

                    System.out.println("\nDeactivation successful.");
                    System.out.println("Employee Number updated to: -" + employeeNumber);
                    System.out.println(customersUpdated + " customer(s) were reassigned to the overall Sales Manager (1165).");
                } else {
                    isWaiting[0] = false; // stop the spinner
                    executor.shutdown();
                    System.out.println("Employee does not exist.");
                    System.out.print("Do you want to try another employee? (Y/N): ");
                    String retryResponse = scanner.next().trim().toUpperCase();
                    if (!retryResponse.equals("Y")) {
                        conn.rollback();
                        break;
                    } else {
                        conn.rollback();
                        continue;
                    }
                }

                System.out.print("\nDo you want to disable another employee? (Y/N): ");
                String response = scanner.next().trim().toUpperCase();
                if (!response.equals("Y")) {
                    conn.commit(); // release the lock when user exits
                    break;
                }
            }
        } catch (SQLException e) {
            isWaiting[0] = false;
            try {
                conn.rollback();
                System.out.println("Transaction rolled back due to an error.");
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            isWaiting[0] = false; // ensure spinner stops
            try {
                conn.setAutoCommit(true); // re-enable auto-commit
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    //officeManagementMenu
    private static void officeManagementMenu(Scanner scanner) {
        boolean exit = false;

        while (!exit) {
            System.out.println("\n=== Office Management Menu ===");
            System.out.println("1. View Office Details");
            System.out.println("2. Update Office Details");
            System.out.println("3. Deactivate Office");
            System.out.println("4. Return to Main Menu");
            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();
            scanner.nextLine();

            switch (choice) {
                case 1:
                    viewOffice(scanner);
                    break;
                case 2:
                    updateOffice(scanner);
                    break;
                case 3:
                    deactivateOffice(scanner);
                    break;
                case 4:
                    return;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
              if(!exit){
                 System.out.println("\nPress Enter to continue...");
                 try {
                    System.in.read();
                 } catch (Exception e) {
                    e.printStackTrace();
                }
             }
        }
    }

    // this is the viewOffice function, working with proper lockings
    private static void viewOffice(Scanner scanner) {
        System.out.print("\nEnter the officeCode to view details: ");
        String officeCode = scanner.nextLine();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("Connection successful.");
            System.out.println("Please wait while we check for ongoing transactions, this may take a while...");
            TimeUnit.SECONDS.sleep(5);

            conn.setAutoCommit(false);
            String query = "SELECT * FROM offices WHERE officeCode = ? FOR SHARE";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, officeCode);
            ResultSet rs = stmt.executeQuery();


            if (rs.next()) {
                System.out.println("\n--- Office Details ---");
                System.out.println("Office Code: " + rs.getString("officeCode"));
                System.out.println("City: " + rs.getString("city"));
                System.out.println("Phone: " + rs.getString("phone"));
                System.out.println("Address Line 1: " + rs.getString("addressLine1"));
                System.out.println("Address Line 2: " + rs.getString("addressLine2"));
                System.out.println("State: " + rs.getString("state"));
                System.out.println("Country: " + rs.getString("country"));
                System.out.println("Postal Code: " + rs.getString("postalCode"));
                System.out.println("Territory: " + rs.getString("territory"));
            } else {
                System.out.println("Office not found.");
            }

            conn.commit();
        } catch (SQLException | InterruptedException e) {
            e.printStackTrace();
        }
    }

    // updateOffice function, working with lockings
    private static void updateOffice(Scanner scanner) {
        System.out.print("\nEnter the officeCode to update: ");
        String officeCode = scanner.nextLine();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("Connection successful.");
            System.out.println("Please wait while we check for ongoing transactions, this may take a while...");
            TimeUnit.SECONDS.sleep(5);

            conn.setAutoCommit(false);
            String checkQuery = "SELECT * FROM offices WHERE officeCode = ? FOR UPDATE";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, officeCode);
            ResultSet rs = checkStmt.executeQuery();


            if (rs.next()) {
                System.out.println("\n--- Select an attribute to update ---");
                System.out.println("1. City");
                System.out.println("2. Phone");
                System.out.println("3. Address Line 1");
                System.out.println("4. Address Line 2");
                System.out.println("5. State");
                System.out.println("6. Country");
                System.out.println("7. Postal Code");
                System.out.println("8. Territory");
                System.out.print("Choose an attribute: ");
                int choice = scanner.nextInt();
                scanner.nextLine();

                String column = null;
                switch (choice) {
                    case 1: column = "city"; break;
                    case 2: column = "phone"; break;
                    case 3: column = "addressLine1"; break;
                    case 4: column = "addressLine2"; break;
                    case 5: column = "state"; break;
                    case 6: column = "country"; break;
                    case 7: column = "postalCode"; break;
                    case 8: column = "territory"; break;
                    default:
                        System.out.println("Invalid choice. Returning to main menu.");
                        conn.rollback();
                        return;
                }

                System.out.print("Enter new value for " + column + ": ");
                String newValue = scanner.nextLine();

                String updateQuery = "UPDATE offices SET " + column + " = ? WHERE officeCode = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                updateStmt.setString(1, newValue);
                updateStmt.setString(2, officeCode);
                int rowsUpdated = updateStmt.executeUpdate();

                if (rowsUpdated > 0) {
                    System.out.println(column + " updated successfully.");
                } else {
                    System.out.println("Update failed.");
                }

                conn.commit();
            } else {
                System.out.println("Office not found.");
                conn.rollback();
            }
        } catch (SQLException | InterruptedException e) {
            e.printStackTrace();
        }
    }

    // deactivateOffice function with proper lockings and error checking
    private static void deactivateOffice(Scanner scanner) {
        System.out.print("\nEnter the officeCode to deactivate: ");
        String officeCode = scanner.nextLine();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("Connection successful.");
            System.out.println("Please wait while we check for ongoing transactions, this may take a while...");
            TimeUnit.SECONDS.sleep(5);

            conn.setAutoCommit(false);

            if ("1".equals(officeCode)) {
                System.out.println("You cannot deactivate the main office.");
                return;
            }

            String checkQuery = "SELECT city FROM offices WHERE officeCode = ? FOR UPDATE";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setString(1, officeCode);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String currentCity = rs.getString("city");


                if (currentCity.contains("Deactivated")) {
                    System.out.println("This office is already deactivated. No further action required.");
                    conn.rollback();
                    return;
                }

                String mainOfficeCode = "1";
                String newCity = currentCity + " - Deactivated";
                String newOfficeCode = "-" + officeCode;

                System.out.println("Relocating employees to the main office and deactivating the office...");


                String updateEmployeesQuery = "UPDATE employees SET officeCode = ? WHERE officeCode = ?";
                PreparedStatement updateEmployeesStmt = conn.prepareStatement(updateEmployeesQuery);
                updateEmployeesStmt.setString(1, mainOfficeCode);
                updateEmployeesStmt.setString(2, officeCode);
                updateEmployeesStmt.executeUpdate();


                String deactivateOfficeQuery = "UPDATE offices SET city = ?, officeCode = ? WHERE officeCode = ?";
                PreparedStatement deactivateOfficeStmt = conn.prepareStatement(deactivateOfficeQuery);
                deactivateOfficeStmt.setString(1, newCity);
                deactivateOfficeStmt.setString(2, newOfficeCode);
                deactivateOfficeStmt.setString(3, officeCode);
                deactivateOfficeStmt.executeUpdate();

                conn.commit();
                System.out.println("Office deactivated and employees relocated successfully.");
            } else {
                System.out.println("Office not found.");
                conn.rollback();
            }
        } catch (SQLException | InterruptedException e) {
            e.printStackTrace();
        }
    }

    // Order Management Menu
    private static void orderManagementMenu(Scanner scanner) {
        while (true) {
            System.out.println("\n=== Order Management Menu ===");
            System.out.println("1. Create Order");
            System.out.println("2. Cancel Order");
            System.out.println("3. Update Order");
            System.out.println("4. Return to Main Menu");
            System.out.print("Enter your choice: ");
            int choice = scanner.nextInt();

            orders orderManager = new orders();
            switch (choice) {
                case 1:
                    orderManager.createOrder();
                    break;
                case 2:
                    orderManager.cancelOrder();
                    break;
                case 3:
                    orderManager.updateOrder();
                    break;
                case 4:
                    return;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        }
    }
}

// Orders class for Order Management
class orders {
    public int createOrder() {
        Scanner sc = new Scanner(System.in);
        Connection conn = null;

        try {
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC&user=root&password=112327ab"
            );
            System.out.println("Connection Successful");

            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);


            String lockOrdersQuery = "SELECT MAX(orderNumber) AS maxOrderNumber FROM orders FOR UPDATE";
            PreparedStatement lockOrdersStmt = conn.prepareStatement(lockOrdersQuery);
            ResultSet orderRs = lockOrdersStmt.executeQuery();

            int newOrderNumber = 1;
            if (orderRs.next()) {
                newOrderNumber = orderRs.getInt("maxOrderNumber") + 1;
            }
            orderRs.close();
            lockOrdersStmt.close();

            System.out.println("Generated Order Number: " + newOrderNumber);


            String orderDate = new java.sql.Date(System.currentTimeMillis()).toString(); // Default to today
            System.out.println("Order Date: " + orderDate);

            System.out.println("Enter Required Date (YYYY-MM-DD):");
            String requiredDate = sc.nextLine();

            String shippedDate = null;
            String status = "In Process";
            System.out.println("Status: " + status);

            System.out.println("Enter Comments (Optional, press ENTER to skip):");
            String comments = sc.nextLine();

            System.out.println("Enter Customer Number:");
            int customerNumber = sc.nextInt();
            sc.nextLine(); // Consume newline


            String insertOrderQuery = "INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement insertOrderStmt = conn.prepareStatement(insertOrderQuery);
            insertOrderStmt.setInt(1, newOrderNumber);
            insertOrderStmt.setString(2, orderDate);
            insertOrderStmt.setString(3, requiredDate);
            insertOrderStmt.setNull(4, java.sql.Types.DATE); // Shipped date is NULL
            insertOrderStmt.setString(5, status);
            insertOrderStmt.setString(6, comments.isEmpty() ? null : comments);
            insertOrderStmt.setInt(7, customerNumber);
            insertOrderStmt.executeUpdate();
            insertOrderStmt.close();

            boolean addingProducts = true;
            int orderLineNumber = 1;

            while (addingProducts) {
                System.out.println("Enter Product Code to Order:");
                String productCode = sc.nextLine();

                String productQuery = "SELECT productCode, quantityInStock, MSRP FROM products WHERE productCode = ? FOR UPDATE";
                PreparedStatement productStmt = conn.prepareStatement(productQuery);
                productStmt.setString(1, productCode);
                ResultSet productRs = productStmt.executeQuery();

                if (productRs.next()) {
                    int quantityInStock = productRs.getInt("quantityInStock");
                    float msrp = productRs.getFloat("MSRP");

                    System.out.println("Enter Quantity to Order (Available: " + quantityInStock + "):");
                    int quantityOrdered = sc.nextInt();
                    sc.nextLine();

                    if (quantityOrdered > quantityInStock) {
                        System.out.println("Error: Quantity ordered exceeds available stock. Try again.");
                        productRs.close();
                        productStmt.close();
                        continue;
                    }

                    System.out.println("Enter Price to Use (MSRP: " + msrp + "):");
                    float priceEach = sc.nextFloat();
                    sc.nextLine();

                    if (priceEach < msrp) {
                        System.out.println("Error: Price is below MSRP. Try again.");
                        productRs.close();
                        productStmt.close();
                        continue;
                    }

                    String insertOrderDetailQuery = "INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber) " +
                            "VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement insertOrderDetailStmt = conn.prepareStatement(insertOrderDetailQuery);
                    insertOrderDetailStmt.setInt(1, newOrderNumber);
                    insertOrderDetailStmt.setString(2, productCode);
                    insertOrderDetailStmt.setInt(3, quantityOrdered);
                    insertOrderDetailStmt.setFloat(4, priceEach);
                    insertOrderDetailStmt.setInt(5, orderLineNumber++);
                    insertOrderDetailStmt.executeUpdate();
                    insertOrderDetailStmt.close();

                    // Update the stock
                    PreparedStatement updateProductStmt = conn.prepareStatement(
                            "UPDATE products SET quantityInStock = quantityInStock - ? WHERE productCode = ?"
                    );
                    updateProductStmt.setInt(1, quantityOrdered);
                    updateProductStmt.setString(2, productCode);
                    updateProductStmt.executeUpdate();
                    updateProductStmt.close();

                    System.out.println("Product added to the order.");
                } else {
                    System.out.println("Error: Product does not exist. Try again.");
                }

                productRs.close();
                productStmt.close();

                System.out.println("Do you want to add another product? (yes/no)");
                String choice = sc.nextLine().trim().toLowerCase();
                addingProducts = choice.equals("yes");
            }

            conn.commit();
            System.out.println("Order successfully created with Order Number: " + newOrderNumber);

        } catch (Exception e) {
            System.out.println("Error occurred: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackException) {
                    System.out.println("Rollback failed: " + rollbackException.getMessage());
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeException) {
                    System.out.println("Failed to close connection: " + closeException.getMessage());
                }
            }
        }

        return 0;
    }

    public int cancelOrder() {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter Order Number to Cancel:");
        int orderNumber = sc.nextInt();
        sc.nextLine(); // Consume the newline

        Connection conn = null;

        try {
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC&user=root&password=112327ab"
            );
            System.out.println("Connection Successful");

            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);


            PreparedStatement checkStmt = conn.prepareStatement(
                    "SELECT status FROM orders WHERE orderNumber = ? FOR UPDATE"
            );
            checkStmt.setInt(1, orderNumber);
            ResultSet rs = checkStmt.executeQuery();
            System.out.println("Please wait for 5 seconds for the check to complete");
            TimeUnit.SECONDS.sleep(5);

            if (rs.next()) {
                String status = rs.getString("status");

                if (!"In Process".equalsIgnoreCase(status)) {
                    System.out.println("Only orders with 'In Process' status can be canceled. Current status: " + status);
                } else {
                    PreparedStatement productStmt = conn.prepareStatement(
                            "SELECT od.productCode, od.quantityOrdered, " +
                                    "p.productName, p.productLine, p.quantityInStock " +
                                    "FROM orderdetails od " +
                                    "JOIN products p ON od.productCode = p.productCode " +
                                    "WHERE od.orderNumber = ? FOR UPDATE"
                    );
                    productStmt.setInt(1, orderNumber);
                    ResultSet productRs = productStmt.executeQuery();

                    System.out.println("Retrieving order details before cancellation...");
                    while (productRs.next()) {
                        String productCode = productRs.getString("productCode");
                        int quantityOrdered = productRs.getInt("quantityOrdered");


                        PreparedStatement updateProductStmt = conn.prepareStatement(
                                "UPDATE products SET quantityInStock = quantityInStock + ? WHERE productCode = ?"
                        );
                        updateProductStmt.setInt(1, quantityOrdered);
                        updateProductStmt.setString(2, productCode);
                        updateProductStmt.executeUpdate();
                        updateProductStmt.close();
                    }
                    productRs.close();
                    productStmt.close();


                    PreparedStatement cancelStmt = conn.prepareStatement(
                            "UPDATE orders SET status = 'Canceled' WHERE orderNumber = ?"
                    );
                    cancelStmt.setInt(1, orderNumber);

                    cancelStmt.executeUpdate();
                    cancelStmt.close();
                    System.out.println("Order successfully canceled.");
                }
            } else {
                System.out.println("No order found with the given number.");
            }

            rs.close();
            checkStmt.close();
            conn.commit();

        } catch (Exception e) {
            System.out.println("Error occurred: " + e.getMessage());
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackException) {
                System.out.println("Rollback failed: " + rollbackException.getMessage());
            }
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException closeException) {
                System.out.println("Failed to close connection: " + closeException.getMessage());
            }
        }

        return 0;
    }

    public int updateOrder() {
        Scanner sc = new Scanner(System.in);

        System.out.println("Enter Order Number to Update:");
        int orderNumber = sc.nextInt();
        sc.nextLine();

        Connection conn = null;

        try {

            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC&user=root&password=112327ab"
            );
            System.out.println("Connection Successful");

            conn.setAutoCommit(false); // Start transaction
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            String checkQuery = "SELECT status FROM orders WHERE orderNumber = ? FOR UPDATE";
            PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
            checkStmt.setInt(1, orderNumber);

            ResultSet rs = checkStmt.executeQuery();
            System.out.println("Please wait for 5 seconds for the check to complete");
            TimeUnit.SECONDS.sleep(5);

            if (rs.next()) {
                String status = rs.getString("status");

                // Check if the current status is "In Process"
                if (!"In Process".equalsIgnoreCase(status)) {
                    System.out.println("Only orders with status 'In Process' can be updated to 'Shipped'. Current status: " + status);
                } else {
                    // Ask user for the new requiredDate
                    System.out.println("Enter the new Required Date (YYYY-MM-DD):");
                    String requiredDate = sc.nextLine();

                    // Update the status to "Shipped" and set the requiredDate
                    String updateQuery = "UPDATE orders SET status = ?, requiredDate = ? WHERE orderNumber = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateQuery);

                    updateStmt.setString(1, "Shipped");
                    updateStmt.setString(2, requiredDate);
                    updateStmt.setInt(3, orderNumber);

                    // Execute the update
                    int rowsAffected = updateStmt.executeUpdate();
                    if (rowsAffected > 0) {
                        System.out.println("Order status updated to 'Shipped'. Required Date set to: " + requiredDate);
                    } else {
                        System.out.println("Failed to update the order.");
                    }

                    updateStmt.close();
                }
            } else {
                System.out.println("No order found with the given number.");
            }

            rs.close();
            checkStmt.close();
            conn.commit();


        } catch (Exception e) {
            System.out.println("Error occurred: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction on error
                } catch (SQLException rollbackException) {
                    System.out.println("Rollback failed: " + rollbackException.getMessage());
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close(); // Close the connection
                } catch (SQLException closeException) {
                    System.out.println("Failed to close connection: " + closeException.getMessage());
                }
            }
        }

        return 0;
    }
}
