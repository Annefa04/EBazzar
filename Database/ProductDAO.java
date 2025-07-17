package database;

import model.Product;
import java.util.List;

public interface ProductDAO {
    List<Product> getAllProducts();
    Product getProductById(int prodId);
    List<Product> getProductsByVendorId(int vendorId);
}
