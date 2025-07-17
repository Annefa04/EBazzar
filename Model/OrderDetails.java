package model;

public class OrderDetails {
	private int custId;
    private String custName;
    private int orderId;
    private String orderDate;
    private String deliveryStatus;
    private double totalAmount;
    private String productName;
    private String vendorName;
    private int quantity;
    private String itemStatus;

    // Getters and Setters
    public int getCustId() { return custId; }
    public void setCustId(int custId) { this.custId = custId; }

    public String getCustName() { return custName; }
    public void setCustName(String custName) { this.custName = custName; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getOrderDate() { return orderDate; }
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }

    public String getDeliveryStatus() { return deliveryStatus; }
    public void setDeliveryStatus(String deliveryStatus) { this.deliveryStatus = deliveryStatus; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getVendorName() { return vendorName; }
    public void setVendorName(String vendorName) { this.vendorName = vendorName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getItemStatus() { return itemStatus; }
    public void setItemStatus(String itemStatus) { this.itemStatus = itemStatus; }
}
