package model;
import java.util.Date;
public class Order {
	private int orderId;
	private int custId;
	private Date orderDate;
	private double totalAmount;
	private String status;
  public Order(int orderId, int custId, Date orderDate, double totalAmount, String status) {
    this.orderId = orderId; this.custId = custId;
    this.orderDate = orderDate; this.totalAmount = totalAmount; this.status = status;
  }
  
  public Order() {}


public int getOrderId() {
	return orderId;
}
public void setOrderId(int orderId) {
	this.orderId = orderId;
}
public int getCustId() {
	return custId;
}
public void setCustId(int custId) {
	this.custId = custId;
}
public Date getOrderDate() {
	return orderDate;
}
public void setOrderDate(Date orderDate) {
	this.orderDate = orderDate;
}
public String getStatus() {
	return status;
}
public void setStatus(String status) {
	this.status = status;
}
public double getTotalAmount() {
	return totalAmount;
}
public void setTotalAmount(double totalAmount) {
	this.totalAmount = totalAmount;
}

}
