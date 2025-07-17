package database.impl;

import database.OrderDAO;
import model.Order;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    public OrderDAOImpl() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    @Override
    public int createOrder(Order order) {
        String sql = "INSERT INTO cust_order (Cust_ID, Order_date, Status, Total_amount) VALUES (?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            java.sql.Date sqlDate = new java.sql.Date(order.getOrderDate().getTime());
            ps.setInt(1, order.getCustId());
            ps.setDate(2, sqlDate);
            ps.setString(3, order.getStatus());
            ps.setDouble(4, order.getTotalAmount());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("Error creating order: " + e.getMessage());
        }

        return -1;
    }

    @Override
    public List<Order> getOrdersByCustomer(int custId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.Order_ID, o.Cust_ID, o.Order_Date, o.Total_amount, o.Status " +
                     "FROM cust_order o " +
                     "WHERE o.Cust_ID = ? ORDER BY o.Order_ID DESC";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, custId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("Order_ID"));
                order.setCustId(rs.getInt("Cust_ID"));
                order.setOrderDate(rs.getDate("Order_Date"));
                order.setTotalAmount(rs.getDouble("Total_amount"));
                order.setStatus(rs.getString("Status"));
                orders.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public void updateTotalAmount(int orderId, double newAmount) {
        String sql = "UPDATE cust_order SET Total_amount = ? WHERE Order_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, newAmount);
            ps.setInt(2, orderId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE cust_order SET Status = ? WHERE Order_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    
}
