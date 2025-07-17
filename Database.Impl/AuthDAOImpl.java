package database.impl;

import database.AuthDAO;
import model.Rider;
import model.Vendor;

import java.sql.*;

public class AuthDAOImpl implements AuthDAO {
    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    public AuthDAOImpl() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    @Override
    public Rider validateRider(String email, String password) {
        Rider rider = null;

        String sql = "SELECT * FROM rider WHERE Rider_email = ? AND Rider_password = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
        } catch (SQLException e) {
            System.err.println("Database error in validateRider: " + e.getMessage());
        }

        return rider;
    }

    @Override
    public Vendor validateVendor(String email, String password) {
        Vendor vendor = null;

        String sql = "SELECT * FROM vendor WHERE Vend_email = ? AND Vend_password = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
        } catch (SQLException e) {
            System.err.println("Database error in validateVendor: " + e.getMessage());
        }

        return vendor;
    }
}
