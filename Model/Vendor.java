package model;

public class Vendor {
    private int vendId;
    private String vendName;
    private String vendEmail;
    private String vendPassword;
    private String vendPhone;

    public Vendor(int vendId, String vendName, String vendEmail, String vendPassword, String vendPhone) {
        this.vendId = vendId;
        this.vendName = vendName;
        this.vendEmail = vendEmail;
        this.vendPassword = vendPassword;
        this.vendPhone = vendPhone;
    }

    public int getVendId() {
        return vendId;
    }

    public void setVendId(int id) {
        this.vendId = id;
    }

    public String getVendName() {
        return vendName;
    }

    public void setVendName(String name) {
        this.vendName = name;
    }

    public String getVendEmail() {
        return vendEmail;
    }

    public void setVendEmail(String email) {
        this.vendEmail = email;
    }

    public String getVendPassword() {
        return vendPassword;
    }

    public void setVendPassword(String password) {
        this.vendPassword = password;
    }

    public String getVendPhone() {
        return vendPhone;
    }

    public void setVendPhone(String phone) {
        this.vendPhone = phone;
    }
}
