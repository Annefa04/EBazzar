package database.impl;

import database.ProductDAO;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {
    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    public ProductDAOImpl() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    @Override
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM products")) {
            
            while (rs.next()) {
                products.add(new Product(
                    rs.getInt("Prod_ID"),
                    rs.getInt("Vend_id"),
                    rs.getString("Prod_name"),
                    rs.getString("Prod_desc"),
                    rs.getDouble("Prod_price")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public Product getProductById(int prodId) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM products WHERE Prod_ID = ?")) {
            
            ps.setInt(1, prodId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Product(
                        rs.getInt("Prod_ID"),
                        rs.getInt("Vend_ID"),
                        rs.getString("Prod_name"),
                        rs.getString("Prod_desc"),
                        rs.getDouble("Prod_price")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Product> getProductsByVendorId(int vendorId) {
        List<Product> products = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT * FROM products WHERE Vend_ID = ?")) {
            
            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(new Product(
                        rs.getInt("Prod_ID"),
                        rs.getInt("Vend_ID"),
                        rs.getString("Prod_name"),
                        rs.getString("Prod_desc"),
                        rs.getDouble("Prod_price")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
