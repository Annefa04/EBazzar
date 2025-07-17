package database;

import model.CartItem;
import java.util.List;

public interface CartDAO {
	void addToCart(int custId, int prodId, int quantity);
	void removeFromCart(int custId, int prodId);
	List<CartItem> getCartItems(int custId);
	void updateCartItemQuantity(int custId, int prodId, int newQuantity);
	void clearCartByCustomer(int custId);
	double calculateSubtotal(int custId);
}
