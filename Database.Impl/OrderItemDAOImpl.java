package database.impl;

import database.OrderItemDAO;
import model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAOImpl implements OrderItemDAO {
    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    public OrderItemDAOImpl() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    @Override
    
    public void createOrderItem(OrderItem item) {
    	String sql = "INSERT INTO order_item (Order_ID, Product_ID, Vend_ID, Quantity, Subtotal, Item_Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            conn.setAutoCommit(true); // optional
            System.out.println("📦 Inserting OrderItem for Order ID: " + item.getOrderId());

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getVendorId());
            ps.setInt(4, item.getQuantity());
            ps.setDouble(5, item.getSubtotal());
            ps.setString(6, item.getItemStatus());

            int rows = ps.executeUpdate();
            System.out.println("✅ OrderItem rows inserted: " + rows);

        } catch (SQLException e) {
            System.err.println("❌ Error inserting order item: " + e.getMessage());
            e.printStackTrace(); // more helpful
        }
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();

        String sql = "SELECT oi.Order_item_ID, oi.Order_ID, oi.Product_ID, oi.Vend_ID, oi.Quantity, oi.Subtotal, oi.Item_status " +
                     "FROM order_item oi WHERE oi.Order_ID = ? ORDER BY oi.Order_item_ID";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("Order_item_ID"));
                item.setOrderId(rs.getInt("Order_ID"));
                item.setProductId(rs.getInt("Product_ID"));
                item.setVendorId(rs.getInt("Vend_ID"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setSubtotal(rs.getDouble("Subtotal"));
                item.setItemStatus(rs.getString("Item_status"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }
}
