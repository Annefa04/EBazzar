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
</head>
<body onload="fetchOrders()">

    <h2>🧾 Order History for <span id="custName">...</span></h2>
    <div id="orders"></div>

    <br><a href="bazaar.jsp">← Back to Bazaar</a>

    <script>
    async function fetchOrders() {
        var userData = JSON.parse(localStorage.getItem("userData") || "{}");
        var custId = userData.custId;
        var custName = userData.custName;

        if (!custId || !custName) {
            alert("Please log in again.");
            window.location.href = "login.jsp";
            return;
        }

        document.getElementById("custName").innerText = custName;

        try {
            const response = await fetch("http://192.168.0.54:8080/eBazaarBackend/api/customer/orders?custId=" + custId);
            const data = await response.json();

            if (!Array.isArray(data) || data.length === 0) {
                document.getElementById("orders").innerHTML = "<p>No order history found.</p>";
                return;
            }

            const groupedOrders = {};
            data.forEach(function(item) {
                if (!groupedOrders[item.orderId]) {
                    groupedOrders[item.orderId] = {
                        orderDate: item.orderDate,
                        deliveryStatus: item.deliveryStatus || "Pending",
                        totalAmount: item.totalAmount,
                        items: []
                    };
                }

                groupedOrders[item.orderId].items.push({
                    productName: item.productName,
                    vendorName: item.vendorName,
                    quantity: item.quantity,
                    itemStatus: item.itemStatus
                });
            });

            var html = "";
            for (var orderId in groupedOrders) {
                var order = groupedOrders[orderId];
                var deliveryClass = "status-" + (order.deliveryStatus.toLowerCase().replace(/\s/g, '') || "pending");

                html += "<div class='order-block'>";
                html += "<h3>🧾 Order #" + orderId + " — " + order.orderDate + " — ";
                html += "<span class='" + deliveryClass + "'>" + order.deliveryStatus + "</span></h3>";
                html += "<p><strong>Total: RM " + parseFloat(order.totalAmount).toFixed(2) + "</strong></p>";
                html += "<table>";
                html += "<tr><th>Product</th><th>Vendor</th><th>Quantity</th><th>Item Status</th></tr>";

                for (var j = 0; j < order.items.length; j++) {
                    var item = order.items[j];
                    var statusClass = "status-" + item.itemStatus.toLowerCase().replace(/\s/g, '');
                    html += "<tr>";
                    html += "<td>" + item.productName + "</td>";
                    html += "<td>" + item.vendorName + "</td>";
                    html += "<td>" + item.quantity + "</td>";
                    html += "<td class='" + statusClass + "'>" + item.itemStatus + "</td>";
                    html += "</tr>";
                }

                html += "</table></div>";
            }

            document.getElementById("orders").innerHTML = html;

        } catch (err) {
            console.error("❌ Error loading orders:", err);
            document.getElementById("orders").innerHTML = "<p style='color:red;'>Failed to load order data.</p>";
        }
    }
</script>


</body>
</html>
