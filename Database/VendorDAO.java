package database;

import model.Vendor;
import java.util.List;

public interface VendorDAO {
    List<Vendor> getAllVendors();
    Vendor getVendorById(int vendId);
}
