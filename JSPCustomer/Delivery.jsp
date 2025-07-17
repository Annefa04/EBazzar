<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, controller.CartItem" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession currentSession = request.getSession(false);
    List<CartItem> cart = (currentSession != null) ? (List<CartItem>) currentSession.getAttribute("cart") : null;

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("viewCart.jsp");
        return;
    }

    double subtotal = 0.0;
    for (CartItem item : cart) {
        subtotal += item.getPrice() * item.getQuantity();
    }

    // Convert Java cart list to a JavaScript JSON-safe string
    StringBuilder jsCartArray = new StringBuilder("[");
    for (int i = 0; i < cart.size(); i++) {
        CartItem item = cart.get(i);
        jsCartArray.append(String.format(
            "{\"productId\":%d,\"vendorId\":%d,\"productName\":\"%s\",\"productDescription\":\"%s\",\"price\":%.2f,\"quantity\":%d}",
            item.getProductId(), item.getVendorId(),
            item.getProductName().replace("\"", "\\\""),
            item.getProductDescription().replace("\"", "\\\""),
            item.getPrice(), item.getQuantity()
        ));
        if (i < cart.size() - 1) jsCartArray.append(",");
    }
    jsCartArray.append("]");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delivery & Payment</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        label, textarea, select { display: block; margin-top: 10px; }
        textarea { width: 100%; }
    </style>
    <script>
        const BACKEND_BASE_URL = "http://localhost:8080/your-backend-app/api";

        function toggleCardFields() {
            const method = document.querySelector('input[name="paymentMethod"]:checked').value;
            const ccvField = document.getElementById("ccvField");
            const ccvInput = document.getElementById("ccvInput");

            if (method === "card") {
                ccvField.style.display = "block";
                ccvInput.setAttribute("required", "required");
            } else {
                ccvField.style.display = "none";
                ccvInput.removeAttribute("required");
            }
        }

        function calculateTotal() {
            const deliveryType = document.getElementById("deliveryType").value;
            const fee = (deliveryType === "express") ? 5.00 : 2.00;
            document.getElementById("deliveryFee").innerText = fee.toFixed(2);
            const subtotal = parseFloat(document.getElementById("subtotal").value);
            document.getElementById("totalAmount").innerText = (subtotal + fee).toFixed(2);
        }

        async function submitOrder(event) {
            event.preventDefault();

            const address = document.getElementById("address").value.trim();
            const deliveryType = document.getElementById("deliveryType").value;
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            const ccv = document.getElementById("ccvInput").value;
            const subtotal = parseFloat(document.getElementById("subtotal").value);
            const deliveryFee = deliveryType === "express" ? 5.00 : 2.00;
            const total = subtotal + deliveryFee;

            const customerId = sessionStorage.getItem("custId");
            const custName = sessionStorage.getItem("custName");
            const cart = JSON.parse(sessionStorage.getItem("cartSummary") || "[]");

            if (!customerId || cart.length === 0) {
                alert("Session expired or cart is empty.");
                window.location.href = "login.jsp";
                return;
            }

            const payload = {
                custId: customerId,
                address,
                deliveryType,
                paymentMethod,
                ccv,
                subtotal,
                deliveryFee,
                totalAmount: total,
                cartItems: cart
            };

            try {
                const response = await fetch(`${BACKEND_BASE_URL}/order`, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(payload)
                });

                if (response.ok) {
                    // Store confirmation summary
                    sessionStorage.setItem("confirmedAddress", address);
                    sessionStorage.setItem("deliveryType", deliveryType);
                    sessionStorage.setItem("paymentMethod", paymentMethod);
                    sessionStorage.setItem("deliveryFee", deliveryFee.toFixed(2));
                    sessionStorage.setItem("orderTotal", total.toFixed(2));
                    sessionStorage.setItem("cartSummary", JSON.stringify(cart));

                    // Optional: clear cart on success
                    sessionStorage.removeItem("cart");

                    alert("✅ Order placed successfully!");
                    window.location.href = "orderConfirmation.jsp";
                } else {
                    const result = await response.json();
                    alert("❌ Error placing order: " + (result.message || "Unknown error"));
                }

            } catch (err) {
                console.error("Submit order error:", err);
                alert("❌ Could not connect to the backend.");
            }
        }

        window.onload = function () {
            toggleCardFields();
            calculateTotal();
            const cartFromServer = <%= jsCartArray.toString() %>;
            sessionStorage.setItem("cartSummary", JSON.stringify(cartFromServer));
        };
    </script>
</head>
<body>

<h2>🚚 Delivery & 💳 Payment</h2>

<form onsubmit="submitOrder(event)">
    <input type="hidden" id="subtotal" name="subtotal" value="<%= subtotal %>">

    <label><strong>Delivery Address:</strong></label>
    <textarea id="address" name="address" rows="3" required placeholder="Enter your delivery address..."></textarea>

    <label><strong>Delivery Type:</strong></label>
    <select id="deliveryType" name="deliveryType" onchange="calculateTotal()">
        <option value="standard">Standard (RM2.00)</option>
        <option value="express">Express (RM5.00)</option>
    </select>

    <label><strong>Payment Method:</strong></label>
    <label><input type="radio" name="paymentMethod" value="cash" checked onclick="toggleCardFields()"> Cash</label>
    <label><input type="radio" name="paymentMethod" value="card" onclick="toggleCardFields()"> Card</label>

    <div id="ccvField" style="display: none; margin-top: 10px;">
        <label>Enter CCV (3 digits):
            <input type="text" id="ccvInput" name="ccv" maxlength="3" pattern="[0-9]{3}" placeholder="e.g. 123">
        </label>
    </div>

    <hr>

    <p><strong>Subtotal:</strong> RM <%= String.format("%.2f", subtotal) %></p>
    <p><strong>Delivery Fee:</strong> RM <span id="deliveryFee">0.00</span></p>
    <p><strong>Grand Total:</strong> RM <span id="totalAmount">0.00</span></p>

    <br><button type="submit">✅ Place Order</button>
</form>

<br><a href="viewCart.jsp">← Back to Cart</a>

</body>
</html>
