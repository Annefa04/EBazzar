<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: center; }
        a, button { text-decoration: none; color: #007BFF; margin-right: 10px; }
        button { padding: 6px 12px; cursor: pointer; }
    </style>
</head>
<body>

<h2 id="customerName">Customer's Cart 🛒</h2>

<div id="cartContainer">
    <p>Loading cart...</p>
</div>

<script>
const userData = JSON.parse(localStorage.getItem("userData") || "{}");
const custId = userData.custId;
const custName = userData.custName;

if (!custName || !custId) {
    alert("Please login first.");
    window.location.href = "login.jsp";
} else {
    document.getElementById("customerName").innerText = custName + "'s Cart 🛒";
}

let cart = [];

function loadCartFromBackend() {
    fetch("http://192.168.0.54:8080/eBazaarBackend/api/cart?custId=" + encodeURIComponent(custId), {
        method: "GET",
        mode: "cors",
        cache: "no-store"
    })
    .then(res => res.json())
    .then(data => {
        cart = data;
        localStorage.setItem("cart", JSON.stringify(cart));
        renderCart();
    })
    .catch(err => {
        console.error("Failed to load cart:", err);
        document.getElementById("cartContainer").innerHTML = "<p style='color:red;'>Failed to load cart.</p>";
    });
}

function renderCart() {
    const container = document.getElementById("cartContainer");

    if (!cart || cart.length === 0) {
        const lastVendorId = localStorage.getItem("lastVendorId");
        const lastVendorName = localStorage.getItem("lastVendorName");

        let backLink = "bazaar.jsp";
        if (lastVendorId && lastVendorName && lastVendorId !== "null" && lastVendorName !== "null") {
            backLink = "vendorProducts.jsp?vendorId=" + encodeURIComponent(lastVendorId) +
                       "&vendorName=" + encodeURIComponent(lastVendorName);
        }

        container.innerHTML = "<p>Your cart is empty.</p><a href='" + backLink + "'>← Back to Bazaar</a>";
        return;
    }

    let tableHTML = "<form onsubmit='event.preventDefault(); updateCart();'>" +
        "<table>" +
        "<tr><th>Product ID</th><th>Vendor ID</th><th>Product</th><th>Price (RM)</th><th>Quantity</th><th>Subtotal (RM)</th><th>Remove</th></tr>";

    let total = 0;

    for (let i = 0; i < cart.length; i++) {
        const item = cart[i];
        const subtotal = item.price * item.quantity;
        total += subtotal;

        tableHTML += "<tr>" +
            "<td>" + item.productId + "</td>" +
            "<td>" + item.vendorId + "</td>" +
            "<td>" + item.productName + "</td>" +
            "<td>" + item.price.toFixed(2) + "</td>" +
            "<td><input type='number' min='1' value='" + item.quantity + "' onchange='updateQty(" + i + ", this.value)' /></td>" +
            "<td>" + subtotal.toFixed(2) + "</td>" +
            "<td><input type='checkbox' onchange='toggleRemove(" + i + ", this.checked)' /></td>" +
            "</tr>";
    }

    tableHTML += "<tr><td colspan='5'><strong>Total</strong></td><td><strong>RM " + total.toFixed(2) + "</strong></td><td></td></tr>";
    tableHTML += "</table><br><button type='submit'>📝 Update Cart</button></form><br>";

    // Generate backLink
    let backLink = "bazaar.jsp";
    const lastVendorId = localStorage.getItem("lastVendorId");
    const lastVendorName = localStorage.getItem("lastVendorName");

    if (lastVendorId && lastVendorName && lastVendorId !== "null" && lastVendorName !== "null") {
        backLink = "vendorProducts.jsp?vendorId=" + encodeURIComponent(lastVendorId) +
                   "&vendorName=" + encodeURIComponent(lastVendorName);
    }

    tableHTML += "<a href='" + backLink + "'>← Back to Bazaar</a> " +
                 "<a href='delivery.jsp'>🚚 Proceed to Delivery & Payment</a>";

    container.innerHTML = tableHTML;
}

function updateQty(index, newQty) {
    const qty = parseInt(newQty);
    if (!isNaN(qty) && qty > 0) {
        cart[index].quantity = qty;
    }
}

function toggleRemove(index, checked) {
    if (checked) {
        cart[index].remove = true;
    } else {
        delete cart[index].remove;
    }
}

async function updateCart() {
    const toRemove = cart.filter(item => item.remove);
    const toUpdate = cart.filter(item => !item.remove);

    for (let item of toRemove) {
        await fetch("http://192.168.0.54:8080/eBazaarBackend/api/cart", {
            method: "DELETE",
            mode: "cors",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify({
                custId: custId,
                productId: item.productId
            })
        })
        .then(async res => {
            const result = await res.json();
            if (!res.ok) {
                console.error("DELETE error:", result);
            }
        })
        .catch(err => console.error("DELETE failed:", err));
    }

    for (let item of toUpdate) {
        await fetch("http://192.168.0.54:8080/eBazaarBackend/api/cart", {
            method: "PUT",
            mode: "cors",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify({
                custId: custId,
                productId: item.productId,
                quantity: item.quantity
            })
        })
        .then(async res => {
            const result = await res.json();
            if (!res.ok) {
                console.error("PUT error:", result);
            }
        })
        .catch(err => console.error("PUT failed:", err));
    }

    loadCartFromBackend();
}

loadCartFromBackend();
</script>

</body>
</html>
