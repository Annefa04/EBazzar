package database;

import model.Customer;
import model.Rider;
import model.Vendor;

public interface AuthDAO {
    Customer validateLogin(String email, String password);
    Rider validateRider(String email, String password);
    Vendor validateVendor(String email, String password);
}
