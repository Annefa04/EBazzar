package database.impl;

import database.AuthDAO;
import model.Customer;
import model.Rider;
import model.Vendor;
import java.sql.*;

public class AuthDAOImpl implements AuthDAO {
    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    @Override
    public Customer validateLogin(String email, String password) {
        Customer customer = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM customer WHERE Cust_email = ? AND Cust_password = ?")) {

                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        customer = new Customer(
                            rs.getInt("Cust_ID"),
                            rs.getString("Cust_name"),
                            rs.getString("Cust_email"),
                            rs.getString("Cust_phone"),
                            rs.getString("Cust_password")
                        );
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Customer Login Error: " + e.getMessage());
        }

        return customer;
    }

    @Override
    public Rider validateRider(String email, String password) {
        Rider rider = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM rider WHERE Rider_email = ? AND Rider_password = ?")) {

                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        rider = new Rider(
                            rs.getInt("Rider_ID"),
                            rs.getString("Rider_name"),
                            rs.getString("Rider_email"),
                            rs.getString("Rider_phone"),
                            rs.getString("Rider_password")
                        );
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Rider Login Error: " + e.getMessage());
        }

        return rider;
    }

    @Override
    public Vendor validateVendor(String email, String password) {
        Vendor vendor = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT * FROM vendor WHERE Vend_email = ? AND Vend_password = ?")) {

                ps.setString(1, email);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        vendor = new Vendor(
                            rs.getInt("Vend_ID"),
                            rs.getString("Vend_name"),
                            rs.getString("Vend_email"),
                            rs.getString("Vend_phone"),
                            rs.getString("Vend_password")
                        );
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Vendor Login Error: " + e.getMessage());
        }

        return vendor;
    }
}
