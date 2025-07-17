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

<p><strong>Order ID:</strong> <span id="orderId">Loading...</span></p>

<h3>Order Summary:</h3>
<ul id="cartSummaryList">
    <li>Loading items...</li>
</ul>

<p><strong>Delivery Address:</strong> <span id="address"></span></p>
<p><strong>Delivery Type:</strong> <span id="deliveryType"></span></p>
<p><strong>Payment Method:</strong> <span id="paymentMethod"></span></p>
<p><strong>Total Paid:</strong> RM<span id="totalPaid"></span></p>

<br><a href="bazaar.jsp">← Back to Bazaar</a>

<script>
    document.getElementById("custName").innerText = localStorage.getItem("custName") || "Customer";
    document.getElementById("address").innerText = localStorage.getItem("confirmedAddress") || "-";
    document.getElementById("deliveryType").innerText = localStorage.getItem("deliveryType") || "-";
    document.getElementById("paymentMethod").innerText = localStorage.getItem("paymentMethod") || "-";
    document.getElementById("totalPaid").innerText = parseFloat(localStorage.getItem("orderTotal") || "0").toFixed(2);

    var orderId = localStorage.getItem("orderId");
    document.getElementById("orderId").innerText = orderId ? "#" + orderId : "(Not available)";

    var cartSummary = JSON.parse(localStorage.getItem("cartSummary") || "[]");
    var cartList = document.getElementById("cartSummaryList");
    cartList.innerHTML = "";

    if (cartSummary.length > 0) {
        for (var i = 0; i < cartSummary.length; i++) {
            var item = cartSummary[i];
            var li = document.createElement("li");
            li.innerText = item.quantity + " x " + item.productName + " @ RM" + 
                parseFloat(item.price).toFixed(2) + " (Vendor ID: " + item.vendorId + ")";
            cartList.appendChild(li);
        }
    } else {
        cartList.innerHTML = "<li>(Order item summary not available.)</li>";
    }

    setTimeout(function () {
        localStorage.removeItem("cartSummary");
        localStorage.removeItem("orderId");
        localStorage.removeItem("confirmedAddress");
        localStorage.removeItem("deliveryType");
        localStorage.removeItem("deliveryFee");
        localStorage.removeItem("paymentMethod");
        localStorage.removeItem("orderTotal");
        localStorage.removeItem("orderSubtotal");
        localStorage.removeItem("grandTotal");
    }, 1000);
</script>

</body>
</html>
