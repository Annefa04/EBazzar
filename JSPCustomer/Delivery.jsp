<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
    function showPopup(message, type = "success") {
        const popup = document.createElement("div");
        popup.innerText = message;
        popup.style.position = "fixed";
        popup.style.bottom = "20px";
        popup.style.right = "20px";
        popup.style.backgroundColor = (type === "error") ? "#dc3545" : "#28a745";
        popup.style.color = "white";
        popup.style.padding = "10px 20px";
        popup.style.borderRadius = "8px";
        popup.style.boxShadow = "0 0 10px rgba(0,0,0,0.2)";
        popup.style.zIndex = "9999";
        popup.style.fontWeight = "bold";
        document.body.appendChild(popup);
        setTimeout(() => popup.remove(), 3000);
    }

    function toggleCardFields() {
        const method = document.querySelector('input[name="paymentMethod"]:checked')?.value;
        const ccvField = document.getElementById("ccvField");
        const ccvInput = document.getElementById("ccvInput");
        if (method === "Card") {
            ccvField.style.display = "block";
            ccvInput.setAttribute("required", "required");
        } else {
            ccvField.style.display = "none";
            ccvInput.removeAttribute("required");
        }
    }

    async function checkDeliveryFee() {
        const address = document.getElementById("address").value.trim();
        const deliveryType = document.getElementById("deliveryType").value;
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked')?.value;
        const userData = JSON.parse(localStorage.getItem("userData"));

        if (!address || !userData?.custId) {
            showPopup("⚠️ Fill in address or login again", "error");
            return;
        }

        const deliveryPayload = {
            address,
            deliveryType,
            paymentMethod,
            custId: userData.custId
        };

        try {
            const response = await fetch("http://192.168.0.54:8080/eBazaarBackend/api/delivery", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(deliveryPayload)
            });

            const result = await response.json();
            if (!result.deliveryId) throw new Error("Invalid delivery response");

            sessionStorage.setItem("deliveryId", result.deliveryId);
            localStorage.setItem("orderSubtotal", result.subtotal);
            localStorage.setItem("deliveryFee", result.deliveryFee);
            localStorage.setItem("grandTotal", result.grandTotal);

            document.getElementById("subtotalDisplay").innerText = result.subtotal;
            document.getElementById("deliveryFee").innerText = result.deliveryFee;
            document.getElementById("totalAmount").innerText = result.grandTotal;
            document.getElementById("subtotal").value = result.subtotal;

            showPopup("✅ Delivery fee calculated!");
        } catch (err) {
            showPopup("❌ Failed to calculate delivery fee", "error");
        }
    }

    async function submitOrder(event) {
        event.preventDefault();

        const userData = JSON.parse(localStorage.getItem("userData"));
        const deliveryId = sessionStorage.getItem("deliveryId");
        const address = document.getElementById("address").value.trim();
        const deliveryType = document.getElementById("deliveryType").value;
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked')?.value;

        if (!userData?.custId || !deliveryId) {
            showPopup("⚠️ Missing customer or delivery data", "error");
            return;
        }

        try {
            // Save cart before placing order
            const cartRes = await fetch("http://192.168.0.54:8080/eBazaarBackend/api/cart?custId=" + userData.custId);
            const cartItems = await cartRes.json();
            localStorage.setItem("cartSummary", JSON.stringify(cartItems));

            // Save order info to localStorage
            localStorage.setItem("confirmedAddress", address);
            localStorage.setItem("deliveryType", deliveryType);
            localStorage.setItem("paymentMethod", paymentMethod);

            const orderResponse = await fetch("http://192.168.0.54:8080/eBazaarBackend/api/order", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    custId: userData.custId,
                    deliveryId: parseInt(deliveryId)
                })
            });

            const orderResult = await orderResponse.json();

            if (orderResponse.ok && orderResult.orderId) {
                localStorage.setItem("orderId", orderResult.orderId);
                const grandTotal = localStorage.getItem("grandTotal") || "0.00";
                localStorage.setItem("orderTotal", grandTotal);
                localStorage.setItem("custName", userData.custName || "Customer");

                sessionStorage.removeItem("deliveryId");

                showPopup("✅ Order placed!");
                setTimeout(() => {
                    window.location.href = "orderConfirmation.jsp";
                }, 2000);
            } else {
                showPopup("❌ Order failed", "error");
            }
        } catch (err) {
            showPopup("❌ Could not connect to server", "error");
        }
    }

    window.onload = async function () {
        toggleCardFields();
        const userData = JSON.parse(localStorage.getItem("userData"));
        if (!userData?.custId) {
            showPopup("⚠️ Session expired. Login again.", "error");
            window.location.href = "login.jsp";
            return;
        }

        try {
            const res = await fetch("http://192.168.0.54:8080/eBazaarBackend/api/cart?custId=" + userData.custId);
            const cartItems = await res.json();
            let subtotal = 0;
            cartItems.forEach(item => subtotal += item.price * item.quantity);

            const deliveryFee = localStorage.getItem("deliveryFee") || "0.00";
            const grandTotal = (subtotal + parseFloat(deliveryFee)).toFixed(2);

            localStorage.setItem("orderSubtotal", subtotal.toFixed(2));
            localStorage.setItem("grandTotal", grandTotal);

            document.getElementById("subtotalDisplay").innerText = subtotal.toFixed(2);
            document.getElementById("deliveryFee").innerText = deliveryFee;
            document.getElementById("totalAmount").innerText = grandTotal;
            document.getElementById("subtotal").value = subtotal.toFixed(2);

        } catch (err) {
            showPopup("❌ Could not load cart", "error");
        }
    };
    </script>
</head>
<body>

<h2>🚚 Delivery & 💳 Payment</h2>

<form onsubmit="submitOrder(event)">
    <input type="hidden" id="subtotal" name="subtotal" value="0.00">

    <label><strong>Delivery Address:</strong></label>
    <textarea id="address" rows="3" required placeholder="Enter your delivery address..."></textarea>

    <label><strong>Delivery Type:</strong></label>
    <select id="deliveryType">
        <option value="Standard">Standard</option>
        <option value="Express">Express</option>
    </select>

    <label><strong>Payment Method:</strong></label>
    <label><input type="radio" name="paymentMethod" value="Cash" checked onclick="toggleCardFields()"> Cash</label>
    <label><input type="radio" name="paymentMethod" value="Card" onclick="toggleCardFields()"> Card</label>

    <div id="ccvField" style="display: none;">
        <label>Enter CCV:
            <input type="text" id="ccvInput" maxlength="3" pattern="[0-9]{3}">
        </label>
    </div>

    <br><button type="button" onclick="checkDeliveryFee()">🚚 Check Delivery Fee</button>
    <hr>
    <p><strong>Subtotal:</strong> RM <span id="subtotalDisplay">0.00</span></p>
    <p><strong>Delivery Fee:</strong> RM <span id="deliveryFee">0.00</span></p>
    <p><strong>Grand Total:</strong> RM <span id="totalAmount">0.00</span></p>
    <br><button type="submit">✅ Place Order</button>
</form>

<br><a href="viewCart.jsp">← Back to Cart</a>

</body>
</html>
