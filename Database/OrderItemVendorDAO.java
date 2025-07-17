package database;

import model.OrderItem;
import java.util.List;

public interface OrderItemVendorDAO {
    List<OrderItem> getOrderItemsVendorByVendorId(int vendId);
    OrderItem getOrderItemVendorById(int orderItemId);
    boolean updateOrderItemVendorStatus(int orderItemId, String status);
}
