package model;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int productId;
    private int vendId;
    private int quantity;
    private double subtotal;
    private String itemStatus;

    public OrderItem() {}

    public OrderItem(int orderItemId, int orderId, int productId, int vendId, int quantity, double subtotal, String itemStatus) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.productId = productId;
        this.vendId = vendId;
        this.quantity = quantity;
        this.subtotal = subtotal;
        this.itemStatus = itemStatus;
    }

    // Getters and Setters
    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getVendId() {
        return vendId;
    }

    public void setVendId(int vendId) {
        this.vendId = vendId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    public String getItemStatus() {
        return itemStatus;
    }

    public void setItemStatus(String itemStatus) {
        this.itemStatus = itemStatus;
    }
}
