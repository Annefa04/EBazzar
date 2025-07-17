<%@ page import="java.net.*, java.io.*, org.json.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String apiUrl = "http://192.168.0.54:8080/eBazaarBackend/api/viewdelivery";

    String riderIdParam = request.getParameter("riderId");
    String riderName = request.getParameter("riderName");

    int riderId = -1;
    if (riderIdParam != null && !riderIdParam.isEmpty()) {
        riderId = Integer.parseInt(riderIdParam);
    }

    // Call backend API
    URL url = new URL(apiUrl);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");

    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    StringBuilder responseBuilder = new StringBuilder();
    String inputLine;
    while ((inputLine = in.readLine()) != null) {
        responseBuilder.append(inputLine);
    }
    in.close();

    JSONArray deliveries = new JSONArray(responseBuilder.toString());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Rider Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f2f2f2;
            padding: 30px;
        }
        .top-bar {
            text-align: right;
            margin-bottom: 20px;
        }
        .logout-link {
            text-decoration: none;
            color: #00a884;
            font-weight: bold;
        }
        h2 {
            margin-bottom: 20px;
        }
        .flex-container {
            display: flex;
            gap: 30px;
        }
        .section {
            flex: 1;
        }
        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .btn {
            background-color: #00a884;
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        iframe {
            width: 100%;
            height: 200px;
            margin-top: 10px;
            border: none;
            border-radius: 8px;
        }
        select {
            width: 100%;
            padding: 8px;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="top-bar">
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<h2>👋 Welcome, <%= riderName %>!</h2>

<div class="flex-container">

    <!-- NEW ORDERS TO ACCEPT -->
    <div class="section">
        <h3>🆕 New Orders to Accept</h3>
        <%
            boolean hasPending = false;
            for (int i = 0; i < deliveries.length(); i++) {
                JSONObject d = deliveries.getJSONObject(i);

                boolean isPending =
                        (d.isNull("riderId") || d.get("riderId").toString().equals("null"))
                        && d.has("deliveryStatus")
                        && d.getString("deliveryStatus").equalsIgnoreCase("Pending");

                if (isPending) {
                    hasPending = true;
                    String address = d.getString("address");
                    String encodedAddress = URLEncoder.encode(address, "UTF-8");
        %>
        <div class="card">
            <b>Order ID:</b> <%= d.getInt("orderId") %><br>
            <b>Address:</b> <%= address %><br><br>

            <button class="btn"
                    onclick="acceptOrder(<%= d.getInt("deliveryId") %>, <%= riderId %>)">
                Accept Order
            </button>

            <iframe src="https://www.google.com/maps?q=<%= encodedAddress %>&output=embed"></iframe>
        </div>
        <% 
                }
            }
            if (!hasPending) {
        %>
        <p>No new orders to accept.</p>
        <% } %>
    </div>

    <!-- MY DELIVERIES -->
    <div class="section">
        <h3>📦 My Deliveries</h3>
        <%
            boolean hasAssigned = false;
            for (int i = 0; i < deliveries.length(); i++) {
                JSONObject d = deliveries.getJSONObject(i);

                boolean isMine =
                        !d.isNull("riderId")
                        && d.getInt("riderId") == riderId
                        && !d.getString("deliveryStatus").equalsIgnoreCase("Pending");

                if (isMine) {
                    hasAssigned = true;
                    String address = d.getString("address");
                    String encodedAddress = URLEncoder.encode(address, "UTF-8");

                    String currentStatus = d.getString("deliveryStatus");
                    boolean isDelivered = currentStatus.equalsIgnoreCase("Delivered");
        %>
        <div class="card">
            <b>Order ID:</b> <%= d.getInt("orderId") %><br>
            <b>Status:</b> <span id="status-<%= d.getInt("deliveryId") %>">
                <%= currentStatus %>
            </span><br>
            <b>Address:</b> <%= address %><br>
            <b>Type:</b> <%= d.getString("deliveryType") %><br>
            <b>Fee:</b> RM <%= d.getDouble("deliveryFee") %><br>
            <b>Payment:</b> <%= d.getString("paymentMethod") %><br>

            <select <%= isDelivered ? "disabled" : "" %>
                    onchange="updateStatus(<%= d.getInt("deliveryId") %>, this.value, <%= riderId %>)">
                <option value="Transit" <%= currentStatus.equals("Transit") ? "selected" : "" %>>Transit</option>
                <option value="Delivered" <%= currentStatus.equals("Delivered") ? "selected" : "" %>>Delivered</option>
            </select>

            <iframe src="https://www.google.com/maps?q=<%= encodedAddress %>&output=embed"></iframe>
        </div>
        <%
                }
            }
            if (!hasAssigned) {
        %>
        <p>No deliveries yet.</p>
        <% } %>
    </div>

</div>

<script>
function acceptOrder(deliveryId, riderId) {
    console.log("Sending acceptOrder for deliveryId:", deliveryId, "riderId:", riderId);
    fetch("http://192.168.0.54:8080/eBazaarBackend/acceptOrder", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body:
            "deliveryId=" + encodeURIComponent(deliveryId) +
            "&riderId=" + encodeURIComponent(riderId),
        credentials: "same-origin"
    })
    .then(response => response.json())
    .then(data => {
        console.log("Response:", data);
        if (data.status === "success") {
            alert("Order accepted successfully!");
            window.location.reload();
        } else {
            alert("Failed to accept order: " + data.message);
        }
    }) 
    .catch(err => {
        console.error(err);
        alert("Error sending request: " + err);
    });
}

function updateStatus(deliveryId, newStatus, riderId) {
    console.log("Updating delivery", deliveryId, "to", newStatus);

    fetch("http://192.168.0.54:8080/eBazaarBackend/updateDeliveryStatus", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: "deliveryId=" + encodeURIComponent(deliveryId) +
              "&newStatus=" + encodeURIComponent(newStatus) +
              "&riderId=" + encodeURIComponent(riderId)
    })
    .then(response => response.json())
    .then(data => {
        console.log("Update response:", data);
        if (data.status === "success") {
            alert("Status updated successfully!");
            document.getElementById("status-" + deliveryId).innerText = newStatus;
        } else {
            alert("Failed to update status: " + data.message);
        }
    })
    .catch(err => {
        console.error(err);
        alert("Error updating status: " + err);
    });
}
</script>

</body>
</html> 
