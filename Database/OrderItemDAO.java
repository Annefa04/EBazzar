package database;

import model.OrderItem;
import java.util.List;

public interface OrderItemDAO {
    void createOrderItem(OrderItem item);
    List<OrderItem> getOrderItemsByOrderId(int orderId);
    }
