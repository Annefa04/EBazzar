package database.impl;

import database.OrderItemVendorDAO;
import model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemVendorDAOImpl implements OrderItemVendorDAO {
    private Connection conn;


    public OrderItemVendorDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<OrderItem> getOrderItemsVendorByVendorId(int vendId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT * FROM order_item WHERE Vend_ID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vendId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("Order_item_ID"));
                item.setOrderId(rs.getInt("Order_ID"));
                item.setProductId(rs.getInt("Product_ID"));
                item.setVendorId(rs.getInt("Vend_ID"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setSubtotal(rs.getDouble("Subtotal"));
                item.setItemStatus(rs.getString("Item_status"));
                orderItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    @Override
    public OrderItem getOrderItemVendorById(int orderItemId) {
        String sql = "SELECT * FROM order_item WHERE Order_item_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderItemId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new OrderItem(
                		rs.getInt("Order_item_ID"),
                        rs.getInt("Order_ID"),
                        rs.getInt("Product_ID"),
                        rs.getInt("Vend_ID"),
                        rs.getInt("Quantity"),
                        rs.getDouble("Subtotal"),
                        rs.getString("Item_status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateOrderItemVendorStatus(int orderItemId, String status) {
        String sql = "UPDATE order_item SET Item_status = ? WHERE Order_item_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderItemId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
