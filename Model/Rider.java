package model;

public class Rider {
    private Integer riderId;
    private String riderName;
    private String riderEmail;
    private String riderPassword;
    private String riderPhone;

    public Rider() {}

    public Rider(int riderId, String riderName, String riderEmail, String riderPassword, String riderPhone) {
        this.riderId = riderId;
        this.riderName = riderName;
        this.riderEmail = riderEmail;
        this.riderPassword = riderPassword;
        this.riderPhone = riderPhone;

    }

    // Getters & Setters
    public Integer getRiderId() { return riderId; }
    public void setRiderId(Integer riderId) { this.riderId = riderId; }

    public String getRiderName() { return riderName; }
    public void setRiderName(String riderName) { this.riderName = riderName; }

    public String getRiderEmail() { return riderEmail; }
    public void setRiderEmail(String riderEmail) { this.riderEmail = riderEmail; }

    public String getRiderPassword() { return riderPassword; }
    public void setRiderPassword(String riderPassword) { this.riderPassword = riderPassword; }

    public String getRiderPhone() { return riderPhone; }
    public void setRiderPhone(String riderPhone) { this.riderPhone = riderPhone; }

}
