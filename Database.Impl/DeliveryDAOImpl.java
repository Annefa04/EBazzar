package database.impl;

import database.DeliveryDAO;
import model.Delivery;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeliveryDAOImpl implements DeliveryDAO {
    private final String URL = "jdbc:mysql://localhost:3306/ebazaar?useSSL=false";
    private final String USER = "root";
    private final String PASSWORD = "";

    public DeliveryDAOImpl() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load JDBC driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    @Override
    public int addDelivery(Delivery delivery) {
        String sql = "INSERT INTO delivery (Order_ID, Rider_ID, Delivery_Status, Distance_Km, Delivery_Type, Delivery_Fee, Address, Payment_Method) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        	if (delivery.getOrderId() != null) {
        	    ps.setInt(1, delivery.getOrderId());
        	} else {
        	    ps.setNull(1, Types.INTEGER); // ✅ Allows NULL in database
        	}

            if (delivery.getRiderId() != null) {
                ps.setInt(2, delivery.getRiderId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, delivery.getDeliveryStatus());
            ps.setDouble(4, delivery.getDistanceKm());
            ps.setString(5, delivery.getDeliveryType());
            ps.setDouble(6, delivery.getDeliveryFee());
            ps.setString(7, delivery.getAddress());
            ps.setString(8, delivery.getPaymentMethod());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int deliveryId = rs.getInt(1);
                    delivery.setDeliveryId(deliveryId);
                    return deliveryId; // ✅ RETURN ID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Failed
    }


    @Override
    public Delivery getDeliveryById(int deliveryId) {
        String sql = "SELECT * FROM delivery WHERE Delivery_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, deliveryId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Delivery(
                    rs.getInt("Delivery_ID"),
                    rs.getInt("Order_ID"),
                    rs.getObject("Rider_ID") != null ? rs.getInt("Rider_ID") : null,
                    rs.getString("Delivery_Status"),
                    rs.getDouble("Distance_Km"),
                    rs.getString("Delivery_Type"),
                    rs.getDouble("Delivery_Fee"),
                    rs.getString("Address"),
                    rs.getString("Payment_Method")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Delivery> getAllDeliveries() {
        List<Delivery> deliveries = new ArrayList<>();
        String sql = "SELECT * FROM delivery";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Delivery delivery = new Delivery(
                    rs.getInt("Delivery_ID"),
                    rs.getInt("Order_ID"),
                    rs.getObject("Rider_ID") != null ? rs.getInt("Rider_ID") : null,
                    rs.getString("Delivery_Status"),
                    rs.getDouble("Distance_Km"),
                    rs.getString("Delivery_Type"),
                    rs.getDouble("Delivery_Fee"),
                    rs.getString("Address"),
                    rs.getString("Payment_Method")
                );
                deliveries.add(delivery);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return deliveries;
    }

    @Override
    public void updateDistanceAndFee(int deliveryId, double distanceKm, double fee) {
        String sql = "UPDATE delivery SET Distance_Km = ?, Delivery_Fee = ? WHERE Delivery_ID = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, distanceKm);
            ps.setDouble(2, fee);
            ps.setInt(3, deliveryId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void updateAddressAndPayment(int deliveryId, String address, String paymentMethod) {
        String sql = "UPDATE delivery SET Address = ?, Payment_Method = ? WHERE Delivery_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, address);
            ps.setString(2, paymentMethod);
            ps.setInt(3, deliveryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    @Override
    public void updateDeliveryOrderId(int deliveryId, int orderId) {
        String sql = "UPDATE delivery SET Order_ID = ? WHERE Delivery_ID = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, deliveryId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}
