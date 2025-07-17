package database.impl;

import database.DeliveryDAO;
import model.Delivery;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeliveryDAOImpl implements DeliveryDAO {
    private Connection conn;

    public DeliveryDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public void acceptOrder(int deliveryId, int riderId) {
        String sql = "UPDATE delivery SET Delivery_status = 'Transit', Rider_ID = ? WHERE Delivery_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, riderId);
            stmt.setInt(2, deliveryId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    

    @Override
    public Delivery getDeliveryById(int deliveryId) {
        String sql = "SELECT * FROM delivery WHERE Delivery_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, deliveryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDelivery(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting delivery by ID", e);
        }
        return null;
    }

    @Override
    public List<Delivery> getDeliveriesByRiderId(int riderId) {
        List<Delivery> deliveries = new ArrayList<>();
        String sql = "SELECT * FROM delivery WHERE Rider_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, riderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                deliveries.add(mapResultSetToDelivery(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting deliveries by rider ID", e);
        }
        return deliveries;
    }

    @Override
    public void updateDeliveryStatus(int deliveryId, String status) {
        String sql = "UPDATE delivery SET Delivery_status = ? WHERE Delivery_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, deliveryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating delivery status", e);
        }
    }

    
    @Override
    public void assignRider(int deliveryId, int riderId) {
        String sql = "UPDATE delivery SET Rider_ID = ? WHERE Delivery_ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, riderId);
            ps.setInt(2, deliveryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Delivery> getAllDeliveries() {
        List<Delivery> list = new ArrayList<>();
        String sql = "SELECT * FROM delivery";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToDelivery(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving all deliveries", e);
        }

        return list;
    }

    
    

    // Helper method
    private Delivery mapResultSetToDelivery(ResultSet rs) throws SQLException {
        Delivery delivery = new Delivery();
        delivery.setDeliveryId(rs.getInt("Delivery_ID"));
        delivery.setOrderId(rs.getInt("Order_ID"));

        int riderId = rs.getInt("Rider_ID");
        if (rs.wasNull()) {
            delivery.setRiderId(null);
        } else {
            delivery.setRiderId(riderId);
        }

        delivery.setDeliveryStatus(rs.getString("Delivery_status"));
        delivery.setDistanceKm(rs.getDouble("Distance_km"));
        delivery.setDeliveryType(rs.getString("Delivery_type"));
        delivery.setDeliveryFee(rs.getDouble("Delivery_fee"));
        delivery.setAddress(rs.getString("Address"));
        delivery.setPaymentMethod(rs.getString("Payment_method"));
        return delivery;
    }



}
