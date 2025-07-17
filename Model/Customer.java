package model;

public class Customer {
    private int custId;
    private String custName;
    private String custEmail;
    private String custPhone;
    private String custPassword;

    public Customer(int custId, String custName, String custEmail, String custPhone, String custPassword) {
        this.custId = custId;
        this.custName = custName;
        this.custEmail = custEmail;
        this.custPhone = custPhone;
        this.custPassword = custPassword;
    }

    public int getCustId() { return custId; }
    public String getCustName() { return custName; }
    public String getCustEmail() { return custEmail; }
    public String getCustPhone() { return custPhone; }
    public String getCustPassword() { return custPassword; }
}
