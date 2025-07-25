package database;

import model.Delivery;
import java.util.List;

public interface DeliveryRiderDAO {

    void acceptOrder(int deliveryId, int riderId);
    Delivery getDeliveryById(int deliveryId);
    List<Delivery> getDeliveriesByRiderId(int riderId);
    void updateDeliveryStatus(int deliveryId, String status);
    void assignRider(int deliveryId, int riderId); // Rider accepts an order
    List<Delivery> getAllDeliveries();   // ✅ include this to match implementation
}
