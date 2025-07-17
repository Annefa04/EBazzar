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
        button { padding: 6px 12px; }
    </style>
</head>
<body>

<h2 id="customerName">Customer's Cart 🛒</h2>

<div id="cartContainer">
    <p>Loading cart...</p>
</div>

<script>
    const custName = sessionStorage.getItem("custName");
    if (!custName) {
        alert("Please login first.");
        window.location.href = "login.jsp";
    } else {
        document.getElementById("customerName").innerText = `${custName}'s Cart 🛒`;
    }

    let cart = JSON.parse(sessionStorage.getItem("cart") || "[]");

    function renderCart() {
        const container = document.getElementById("cartContainer");
        if (cart.length === 0) {
            container.innerHTML = `
                <p>Your cart is empty.</p>
                <a href="bazaar.jsp">← Back to Bazaar</a>
            `;
            return;
        }

        let table = `
            <form onsubmit="event.preventDefault(); updateCart();">
            <table>
                <tr>
                    <th>Product ID</th>
                    <th>Vendor ID</th>
                    <th>Product</th>
                    <th>Price (RM)</th>
                    <th>Quantity</th>
                    <th>Subtotal (RM)</th>
                    <th>Remove</th>
                </tr>
        `;

        let total = 0;
        cart.forEach((item, index) => {
            const subtotal = item.price * item.quantity;
            total += subtotal;

            table += `
                <tr>
                    <td>${item.productId}</td>
                    <td>${item.vendorId}</td>
                    <td>${item.productName}</td>
                    <td>${item.price.toFixed(2)}</td>
                    <td><input type="number" min="1" value="${item.quantity}" onchange="updateQty(${index}, this.value)"></td>
                    <td>${subtotal.toFixed(2)}</td>
                    <td><input type="checkbox" onchange="toggleRemove(${index}, this.checked)"></td>
                </tr>
            `;
        });

        table += `
            <tr>
                <td colspan="5"><strong>Total</strong></td>
                <td><strong>RM ${total.toFixed(2)}</strong></td>
                <td></td>
            </tr>
            </table><br>
            <button type="submit">📝 Update Cart</button>
            </form>
            <br>
            <a href="bazaar.jsp">← Back to Bazaar</a>
            <a href="delivery.jsp">🚚 Proceed to Delivery & Payment</a>
        `;

        container.innerHTML = table;
    }

    // Update quantity
    function updateQty(index, newQty) {
        const qty = parseInt(newQty);
        if (!isNaN(qty) && qty > 0) {
            cart[index].quantity = qty;
        }
    }

    // Mark item for removal
    function toggleRemove(index, checked) {
        if (checked) {
            cart[index].remove = true;
        } else {
            delete cart[index].remove;
        }
    }

    // Finalize cart updates
    function updateCart() {
        cart = cart.filter(item => !item.remove);
        sessionStorage.setItem("cart", JSON.stringify(cart));
        renderCart();
    }

    // Initial render
    renderCart();
</script>

</body>
</html>
