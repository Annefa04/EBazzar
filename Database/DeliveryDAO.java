package database;

import model.Delivery;
import java.util.List;

public interface DeliveryDAO {
    
	int addDelivery(Delivery delivery);
    Delivery getDeliveryById(int deliveryId);
    List<Delivery> getAllDeliveries();
    void updateDistanceAndFee(int deliveryId, double distanceKm, double fee);
    void updateAddressAndPayment(int deliveryId, String address, String paymentMethod);
    void updateDeliveryOrderId(int deliveryId, int orderId);
}
