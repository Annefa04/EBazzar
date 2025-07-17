package database;

import model.OrderDetails;
import java.util.List;

public interface OrderDetailsDAO {
    List<OrderDetails> getOrderDetailsByCustomerId(int custId);
}
