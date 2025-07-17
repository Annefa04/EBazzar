package database.impl;

import database.OrderDetailsDAO;
import database.DBConnection;
import model.OrderDetails;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailsDAOImpl implements OrderDetailsDAO {
    @Override
    public List<OrderDetails> getOrderDetailsByCustomerId(int custId) {
        List<OrderDetails> orderDetails = new ArrayList<>();
        String sql = "SELECT c.Cust_ID, c.Cust_name, co.Order_ID, co.Order_date, " +
                "d.Delivery_status, co.Total_amount, p.Prod_name, v.Vend_name, " +
                "oi.Quantity, oi.Item_status " +
                "FROM customer c " +
                "JOIN cust_order co ON c.Cust_ID = co.Cust_ID " +
                "LEFT JOIN delivery d ON co.Order_ID = d.Order_ID " +
                "JOIN order_item oi ON co.Order_ID = oi.Order_ID " +
                "JOIN products p ON oi.Product_ID = p.Prod_ID " +
                "JOIN vendor v ON oi.Vend_ID = v.Vend_ID " +
                "WHERE c.Cust_ID = ? " +
                "ORDER BY co.Order_ID, oi.Order_item_ID";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, custId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderDetails detail = new OrderDetails();
                    detail.setCustId(rs.getInt("Cust_ID"));
                    detail.setCustName(rs.getString("Cust_name"));
                    detail.setOrderId(rs.getInt("Order_ID"));
                    detail.setOrderDate(rs.getString("Order_date"));
                    detail.setDeliveryStatus(rs.getString("Delivery_status"));
                    detail.setTotalAmount(rs.getDouble("Total_amount"));
                    detail.setProductName(rs.getString("Prod_name"));
                    detail.setVendorName(rs.getString("Vend_name"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    detail.setItemStatus(rs.getString("Item_status"));

                    orderDetails.add(detail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderDetails;
    }
}
