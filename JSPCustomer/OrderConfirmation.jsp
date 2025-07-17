<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <style>
        body { font-family: Arial; padding: 30px; }
        ul { list-style: none; padding: 0; }
        li { margin-bottom: 8px; }
    </style>
</head>
<body>

<h2>✅ Order Confirmed!</h2>
<p>Thank you, <strong id="custName">Customer</strong>. Your order has been placed successfully.</p>

<h3>Order Summary:</h3>
<ul id="cartSummaryList">
    <li>Loading items...</li>
</ul>

<p><strong>Delivery Address:</strong> <span id="address"></span></p>
<p><strong>Delivery Type:</strong> <span id="deliveryType"></span> (RM<span id="deliveryFee"></span>)</p>
<p><strong>Payment Method:</strong> <span id="paymentMethod"></span></p>
<p><strong>Total Paid:</strong> RM<span id="totalPaid"></span></p>

<br><a href="bazaar.jsp">← Back to Bazaar</a>

<script>
    // Load confirmation details from sessionStorage
    document.getElementById("custName").innerText = sessionStorage.getItem("custName") || "Customer";
    document.getElementById("address").innerText = sessionStorage.getItem("confirmedAddress") || "-";
    document.getElementById("deliveryType").innerText = sessionStorage.getItem("deliveryType") || "-";
    document.getElementById("deliveryFee").innerText = parseFloat(sessionStorage.getItem("deliveryFee") || "0").toFixed(2);
    document.getElementById("paymentMethod").innerText = sessionStorage.getItem("paymentMethod") || "-";
    document.getElementById("totalPaid").innerText = parseFloat(sessionStorage.getItem("orderTotal") || "0").toFixed(2);

    // Load cart summary (JSON array) and display it
    const cartSummary = JSON.parse(sessionStorage.getItem("cartSummary") || "[]");
    const cartList = document.getElementById("cartSummaryList");
    cartList.innerHTML = "";

    if (cartSummary.length > 0) {
        cartSummary.forEach(item => {
            const li = document.createElement("li");
            li.innerText = `${item.quantity} x ${item.productName} @ RM${parseFloat(item.price).toFixed(2)} (Vendor ID: ${item.vendorId})`;
            cartList.appendChild(li);
        });
    } else {
        cartList.innerHTML = "<li>(Order item summary not available.)</li>";
    }
</script>

</body>
</html>
