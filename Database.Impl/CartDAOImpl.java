package database.impl;

import database.CartDAO;
import model.CartItem;
import model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAOImpl implements CartDAO {
    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    public CartDAOImpl() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL driver
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    @Override
    public void addToCart(int custId, int prodId, int quantity) {
        String checkSQL = "SELECT Quantity FROM cart WHERE Cust_ID = ? AND Prod_ID = ?";
        String updateSQL = "UPDATE cart SET Quantity = ? WHERE Cust_ID = ? AND Prod_ID = ?";
        String insertSQL = "INSERT INTO cart (Cust_ID, Prod_ID, Quantity) VALUES (?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            // Check if item already in cart
            try (PreparedStatement psCheck = conn.prepareStatement(checkSQL)) {
                psCheck.setInt(1, custId);
                psCheck.setInt(2, prodId);
                ResultSet rs = psCheck.executeQuery();

                if (rs.next()) {
                    int existingQty = rs.getInt("Quantity");
                    int newQty = existingQty + quantity;

                    try (PreparedStatement psUpdate = conn.prepareStatement(updateSQL)) {
                        psUpdate.setInt(1, newQty);
                        psUpdate.setInt(2, custId);
                        psUpdate.setInt(3, prodId);
                        psUpdate.executeUpdate();
                    }
                } else {
                    try (PreparedStatement psInsert = conn.prepareStatement(insertSQL)) {
                        psInsert.setInt(1, custId);
                        psInsert.setInt(2, prodId);
                        psInsert.setInt(3, quantity);
                        psInsert.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void removeFromCart(int custId, int prodId) {
        String sql = "DELETE FROM cart WHERE Cust_ID = ? AND Prod_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, custId);
            ps.setInt(2, prodId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<CartItem> getCartItems(int custId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT p.*, c.Quantity FROM products p JOIN cart c ON p.Prod_ID = c.Prod_ID WHERE c.Cust_ID = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, custId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product product = new Product(
                    rs.getInt("Prod_ID"),
                    rs.getInt("Vend_ID"),
                    rs.getString("Prod_name"),
                    rs.getString("Prod_desc"),
                    rs.getDouble("Prod_price")
                );

                int quantity = rs.getInt("Quantity");
                cartItems.add(new CartItem(product, quantity));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItems;
    }

    @Override
    public void updateCartItemQuantity(int custId, int prodId, int newQuantity) {
        String sql = "UPDATE cart SET Quantity = ? WHERE Cust_ID = ? AND Prod_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, custId);
            ps.setInt(3, prodId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void clearCartByCustomer(int custId) {
        String sql = "DELETE FROM cart WHERE Cust_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, custId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public double calculateSubtotal(int custId) {
        String sql = "SELECT SUM(p.Prod_price * c.Quantity) AS subtotal " +
                     "FROM cart c JOIN products p ON c.Prod_ID = p.Prod_ID " +
                     "WHERE c.Cust_ID = ?";
        double subtotal = 0.0;

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, custId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                subtotal = rs.getDouble("subtotal");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return subtotal;
    }

}
