import java.sql.*;
import java.util.*;


public class ordering {

    public int orderNumber;
    public String   orderDate;
    public String   requiredDate;
    public String   shippedDate;
    public String      status;
    public String    comments;
    public int    customerNumber;


    public ordering() {}

    public int getInfo()     {
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter Order Number:");
        orderNumber = sc.nextInt();

        try {
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC&user=root&password=p@ssword");
            System.out.println("Connection Successful");
            conn.setAutoCommit(false);

            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM orders WHERE orderNumber=?");
            pstmt.setInt(1, orderNumber);

            System.out.println("Press enter key to start retrieving the data");
            sc.nextLine();

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                orderDate     = rs.getString("orderDate");
                requiredDate     = rs.getString("requiredDate");
                shippedDate = rs.getString("shippedDate");
                status        = rs.getString("status");
                comments            = rs.getString("comments");
                customerNumber            = rs.getInt("customerNumber");
            }

            rs.close();

            System.out.println("orderDate " + orderDate);
            System.out.println("requiredDate: " + requiredDate);
            System.out.println("shippedDate:     " + shippedDate);
            System.out.println("status:    " + status);
            System.out.println("comments:         " + comments);
            System.out.println("customerNumber:         " + customerNumber);

            System.out.println("Press enter key to end transaction");
            sc.nextLine();

            pstmt.close();
            conn.commit();
            conn.close();
            return 1;

        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public int placeOrder() {

        try {
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC&user=admin&password=p@ssword");
            System.out.println("Connection Successful");
            conn.setAutoCommit(false);

            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM orders WHERE orderNumber=?");
            pstmt.setInt(1, orderNumber);

            return 1;
        }

        catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }

    }

    public  static void main(String[] args) {
        ordering o = new ordering();
        o.getInfo();

    }
}



/*
    public int updateInfo() {

        float   incr;
        int		newquantity=0;
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter Product Code:");
        productCode = sc.nextLine();

        try {
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/dbsales?useTimezone=true&serverTimezone=UTC&user=admin&password=DLSU1234!");
            System.out.println("Connection Successful");
            conn.setAutoCommit(false);
            PreparedStatement pstmt = conn.prepareStatement("SELECT productName, productLine, quantityInStock, buyPrice, MSRP FROM products WHERE productCode=?");
            pstmt.setString(1, productCode);

            System.out.println("Press enter key to start retrieving the data");
            sc.nextLine();

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                productName     = rs.getString("productName");
                productLine     = rs.getString("productLine");
                quantityInStock = rs.getInt("quantityInStock");
                buyPrice        = rs.getFloat("buyPrice");
                MSRP            = rs.getFloat("MSRP");
            }

            rs.close();

            System.out.println("Product Name: " + productName);
            System.out.println("Product Line: " + productLine);
            System.out.println("Quantity:     " + quantityInStock);
            System.out.println("Buy Price:    " + buyPrice);
            System.out.println("MSRP:         " + MSRP);

            System.out.println("Press enter key to enter new values for product");
            sc.nextLine();

            System.out.println("Enter percent increase in MSRP: ");
            incr = sc.nextFloat();

            System.out.println("Enter update Quantity ");
            newquantity = sc.nextInt();

            MSRP = MSRP * (1+incr/100);

            pstmt = conn.prepareStatement ("UPDATE products SET MSRP=?, quantityInStock=? WHERE productCode=?");
            pstmt.setFloat(1,  MSRP);
            pstmt.setInt(2,newquantity);
            pstmt.setString(3, productCode);
            pstmt.executeUpdate();

            System.out.println("Update Successful. Press enter key to continue....");
            sc.nextLine();

            pstmt.close();
            conn.commit();
            conn.close();
            return 1;

        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public static void main (String args[]) {
        Scanner sc     = new Scanner (System.in);
        int     choice = 0;


        System.out.println("Press 0 to exit....");
        while ((choice = sc.nextInt()) != 0) {

            // Letting the use choose between the two functions
            System.out.println("Enter [1] Get Product Info  [2] Update Product:");
            choice = sc.nextInt();
            products p = new products();
            if (choice==1) p.getInfo();
            if (choice==2) p.updateInfo();

            System.out.println("Press enter key to continue....");
            sc.nextLine();
        }
    }


*/