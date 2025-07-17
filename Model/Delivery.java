package model;

public class Delivery {
    private int deliveryId;
    private int orderId;
    private Integer riderId;
    private String deliveryStatus;
    private double distanceKm;
    private String deliveryType;
    private double deliveryFee;
    private String address;
    private String paymentMethod;

    // Constructors
    public Delivery() {}

    public Delivery(int deliveryId, int orderId, int riderId, String deliveryStatus,
                    double distanceKm, String deliveryType, double deliveryFee,
                    String address, String paymentMethod) {
        this.deliveryId = deliveryId;
        this.orderId = orderId;
        this.riderId = riderId;
        this.deliveryStatus = deliveryStatus;
        this.distanceKm = distanceKm;
        this.deliveryType = deliveryType;
        this.deliveryFee = deliveryFee;
        this.address = address;
        this.paymentMethod = paymentMethod;
    }

    // Getters and Setters
    public int getDeliveryId() {
        return deliveryId;
    }

    public void setDeliveryId(int deliveryId) {
        this.deliveryId = deliveryId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Integer getRiderId() {
        return riderId;
    }

    public void setRiderId(Integer riderId) {
        this.riderId = riderId;
    }

    public String getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(String deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public String getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(String deliveryType) {
        this.deliveryType = deliveryType;
    }

    public double getDeliveryFee() {
        return deliveryFee;
    }

    public void setDeliveryFee(double deliveryFee) {
        this.deliveryFee = deliveryFee;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
}
