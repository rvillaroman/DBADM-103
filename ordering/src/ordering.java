import java.sql.*;
import java.util.*;

public class ordering {

    public int cancelOrder() {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter Order Number to Cancel:");
        int orderNumber = sc.nextInt();
        sc.nextLine(); // Consume newline

        Connection conn = null;

        try {
            // Establish the database connection
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC&user=root&password=112327ab"
            );
            System.out.println("Connection Successful");


            conn.setAutoCommit(false);

            // Set the isolation level to prevent conflicts
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            // Lock the order row to prevent other transactions from accessing it
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT status FROM orders WHERE orderNumber = ? FOR UPDATE"
            );
            checkStmt.setInt(1, orderNumber);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String currentStatus = rs.getString("status");

                if (!"In Process".equalsIgnoreCase(currentStatus)) {
                    System.out.println("Only orders with 'In Process' status can be canceled. Current status: " + currentStatus);
                } else {
                    // Retrieve the products and quantities from the orderdetails table
                    PreparedStatement productStmt = conn.prepareStatement(
                        "SELECT productCode, quantityOrdered FROM orderdetails WHERE orderNumber = ? FOR UPDATE"
                    );
                    productStmt.setInt(1, orderNumber);
                    ResultSet productRs = productStmt.executeQuery();


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

                    // Update the status of the order to "Canceled"
                    PreparedStatement cancelStmt = conn.prepareStatement(
                        "UPDATE orders SET status = 'Canceled' WHERE orderNumber = ?"
                    );
                    cancelStmt.setInt(1, orderNumber);

                    int rowsAffected = cancelStmt.executeUpdate();
                    if (rowsAffected > 0) {
                        System.out.println("Order successfully canceled and product stock updated.");
                    } else {
                        System.out.println("Failed to cancel the order.");
                    }

                    cancelStmt.close();
                }
            } else {
                System.out.println("No order found with the given number.");
            }

            rs.close();
            checkStmt.close();

            // Commit the transaction
            conn.commit();

        } catch (Exception e) {
            System.out.println("Error occurred: " + e.getMessage());

            // Rollback the transaction in case of an error
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackException) {
                System.out.println("Rollback failed: " + rollbackException.getMessage());
            }

        } finally {
            // Ensure the connection is closed
            try {
                if (conn != null) conn.close();
            } catch (SQLException closeException) {
                System.out.println("Failed to close connection: " + closeException.getMessage());
            }
        }

        return 0;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int choice;

        while (true) {
            System.out.println("\nOrder Management System");
            System.out.println("1. Cancel Order");
            System.out.println("0. Exit");
            System.out.print("Enter your choice: ");
            choice = sc.nextInt();

            ordering manager = new ordering();

            switch (choice) {
                case 1:
                    manager.cancelOrder();  // Call cancelOrder to cancel an order
                    break;
                case 0:
                    System.out.println("Exiting...");
                    return;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        }
    }
}
