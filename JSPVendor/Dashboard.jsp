<%@ page import="java.net.*, java.io.*, org.json.*" %>
<%
    String vendorIdParam = request.getParameter("vendId");
    if (vendorIdParam == null) {
%>
<script>
    const vendorData = JSON.parse(localStorage.getItem("vendorData"));
    if (vendorData && vendorData.vendId) {
        window.location.href = "dashboard.jsp?vendId=" + vendorData.vendId;
    } else {
        alert(" You are not logged in.");
        window.location.href = "login.jsp";
    }
</script>
<%
        return;
    }

    int vendId = Integer.parseInt(vendorIdParam);

    // Fetch orders from backend
    URL url = new URL("http://192.168.0.54:8080/eBazaarBackend/vendor/viewOrderVendor?vendId=" + vendId);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");

    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    StringBuilder responseStr = new StringBuilder();
    String inputLine;
    while ((inputLine = in.readLine()) != null) {
        responseStr.append(inputLine);
    }
    in.close();

    JSONObject jsonResponse = new JSONObject(responseStr.toString());
    JSONArray jsonArr = jsonResponse.getJSONArray("orderItems");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Vendor Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { font-family: Arial; margin: 20px; }
        table { width: 100%; }
        .btn { margin-right: 4px; }
    </style>
</head>
<body>

<h2>Welcome, <span id="vendorName">Vendor</span> (Vendor ID: <span id="vendorId"><%= vendId %></span>)</h2>


<table class="table table-bordered table-striped">
    <thead class="table-dark">
        <tr>
            <th>Order ID</th>
            <th>Product ID</th>
            <th>Quantity</th>
            <th>Subtotal (RM)</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <% for (int i = 0; i < jsonArr.length(); i++) {
            JSONObject obj = jsonArr.getJSONObject(i);
        %>
        <tr>
            <td><%= obj.getInt("orderId") %></td>
            <td><%= obj.getInt("productId") %></td>
            <td><%= obj.getInt("quantity") %></td>
            <td>RM <%= obj.getDouble("subtotal") %></td>
            <td id="status-<%= obj.getInt("orderItemId") %>"><%= obj.getString("itemStatus") %></td>
            <td>
                <button class="btn btn-warning btn-sm" onclick="updateStatus(<%= obj.getInt("orderItemId") %>, 'Preparing')">Preparing</button>
                <button class="btn btn-success btn-sm" onclick="updateStatus(<%= obj.getInt("orderItemId") %>, 'Ready for Pickup')">Ready</button>
                <button class="btn btn-danger btn-sm" onclick="updateStatus(<%= obj.getInt("orderItemId") %>, 'Rejected')">Reject</button>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>

<div class="mt-4">
   <a href="login.jsp" class="btn btn-danger" onclick="logout()">Logout</a>
</div>

<script>
    // Update the vendor name from localStorage
    document.addEventListener("DOMContentLoaded", function () {
    const vendor = JSON.parse(localStorage.getItem("vendorData"));
    if (vendor && vendor.vendName && vendor.vendId) {
        document.getElementById("vendorName").textContent = vendor.vendName;
        document.getElementById("vendId").textContent = vendor.vendId;
    }
});

    function updateStatus(orderItemId, newStatus) {
        const formData = new URLSearchParams();
        formData.append("orderItemId", orderItemId);
        formData.append("status", newStatus);

        fetch("http://192.168.0.54:8080/eBazaarBackend/updateItemStatus", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === "success") {
                alert("Success" + data.message);
                location.reload();
            } else {
                alert("Error " + data.message);
            }
        })
        .catch(err => {
            alert("Warning Error: " + err.message);
        });
    }
    
    function logout() {
        localStorage.removeItem("vendorData");  // Clear login info
    }

</script>

</body>
</html>
