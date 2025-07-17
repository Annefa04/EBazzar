package database;

import model.Order;
import java.util.List;

public interface OrderDAO {
    int createOrder(Order order);
    List<Order> getOrdersByCustomer(int custId);
    void updateTotalAmount(int orderId, double newAmount); // <-- REQUIRED
    boolean updateOrderStatus(int orderId, String status); // <-- REQUIRED
}
