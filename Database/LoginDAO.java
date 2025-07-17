package database;

import model.Customer;
import java.sql.SQLException;

public interface LoginDAO {
    Customer authenticateCustomer(String email, String password) throws SQLException, ClassNotFoundException;
}
