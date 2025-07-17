package database.impl;

import database.VendorDAO;
import model.Vendor;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VendorDAOImpl implements VendorDAO {
    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    public VendorDAOImpl() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Add this line
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }
    
    @Override
    public List<Vendor> getAllVendors() {
        List<Vendor> vendors = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM vendor")) {
            
            while (rs.next()) {
                vendors.add(new Vendor(
                    rs.getInt("Vend_ID"),
                    rs.getString("Vend_name"),
                    rs.getString("Vend_email"),
                    rs.getString("Vend_phone"),
                    rs.getString("Vend_password")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vendors;
    }

    @Override
    public Vendor getVendorById(int vendId) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM vendor WHERE Vend_ID = ?")) {
            
            ps.setInt(1, vendId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Vendor(
                        rs.getInt("Vend_ID"),
                        rs.getString("Vend_name"),
                        rs.getString("Vend_email"),
                        rs.getString("Vend_phone"),
                        rs.getString("Vend_password")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
