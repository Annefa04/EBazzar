<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <style>
        body { font-family: Arial; padding: 30px; }
        h2 { color: #333; }
        .order-block { border: 1px solid #ccc; margin-bottom: 20px; padding: 15px; background: #f9f9f9; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        .status-pending { color: orange; }
        .status-rejected { color: red; }
        .status-preparing { color: blue; }
        .status-readyforpickup { color: green; }
    </style>
    <script>
        async function fetchOrders() {
            const custId = sessionStorage.getItem("custId");
            const custName = sessionStorage.getItem("custName");
            if (!custId || !custName) {
                alert("Please login.");
                window.location.href = "login.jsp";
                return;
            }
            document.getElementById("custName").innerText = custName;

            try {
                const response = await fetch(`http://localhost:8080/your-backend-app/api/customer/${custId}/orders`);
                const orders = await response.json();

                if (!Array.isArray(orders) || orders.length === 0) {
                    document.getElementById("orders").innerHTML = "<p>No order history available.</p>";
                    return;
                }

                let html = "";
                orders.forEach(order => {
                    html += `<div class='order-block'>
                        <h3>🧾 Order #${order.orderId} — ${order.orderDate} — 
                            <span class='status-${order.status.toLowerCase().replace(/\s/g, '')}'>${order.status}</span>
                        </h3>
                        <p><strong>Total: RM ${order.totalAmount.toFixed(2)}</strong></p>
                        <table>
                            <tr><th>Product</th><th>Vendor</th><th>Quantity</th><th>Item Status</th></tr>`;

                    order.items.forEach(item => {
                        html += `<tr>
                            <td>${item.productName}</td>
                            <td>${item.vendorName}</td>
                            <td>${item.quantity}</td>
                            <td class='status-${item.itemStatus.toLowerCase().replace(/\s/g, '')}'>${item.itemStatus}</td>
                        </tr>`;
                    });

                    html += `</table></div>`;
                });

                document.getElementById("orders").innerHTML = html;

            } catch (error) {
                console.error("Failed to load orders:", error);
                document.getElementById("orders").innerHTML = `<p style='color:red;'>Failed to fetch order data.</p>`;
            }
        }
    </script>
</head>
<body onload="fetchOrders()">
    <h2>🧾 Order History for <span id="custName"></span></h2>
    <div id="orders"></div>
    <br><a href="bazaar.jsp">← Back to Bazaar</a>
</body>
</html>
