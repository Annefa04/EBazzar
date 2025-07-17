<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bazaar - Choose a Vendor</title>
    <style>
        body { font-family: Arial; padding: 30px; background-color: #f9f9f9; }
        .vendor { padding: 15px; margin: 10px 0; background: #ffffff; border: 1px solid #ccc; }
        .vendor button { font-weight: bold; color: #007BFF; background: none; border: none; cursor: pointer; text-decoration: underline; }
        .top-links { margin-bottom: 20px; }
        .logout-link { color: red; text-decoration: none; font-weight: bold; margin-left: 20px; }
    </style>
</head>
<body>

<div class="top-links">
    <h2 id="welcomeMessage">Welcome, <span id="customerName"></span>! 👋</h2>
    <p>
        <a href="viewCart.jsp">🛒 View Cart</a>
        <a href="#" class="logout-link" onclick="logout()">🚪 Logout</a>
        <a href="viewOrders.jsp">📋 My Orders</a>
    </p>
</div>

<h3>Select a Vendor to Browse Products:</h3>
<div id="vendorList">
    <p>Loading vendors...</p>
</div>

<script>

	localStorage.removeItem("lastVendorId");
	localStorage.removeItem("lastVendorName");

	
    const userData = JSON.parse(localStorage.getItem("userData") || "{}");
    const custName = userData.custName;
    const custId = userData.custId;

    if (!custName || !custId) {
        alert("Please login first.");
        window.location.href = "login.jsp";
    } else {
        document.getElementById("customerName").innerText = custName;
    }

    fetch("http://192.168.0.54:8080/eBazaarBackend/api/vendors")
        .then(res => res.json())
        .then(vendors => {
            const container = document.getElementById("vendorList");
            container.innerHTML = "";

            if (vendors.length === 0) {
                container.innerHTML = "<p>No vendors found.</p>";
                return;
            }

            vendors.forEach(v => {
                console.log("Vendor:", v); // Debug

                const div = document.createElement("div");
                div.className = "vendor";

                const p = document.createElement("p");
                const strong = document.createElement("strong");
                strong.textContent = v.name || "[No Name]";
                p.appendChild(strong);

                const a = document.createElement("a");
                a.href = "vendorProducts.jsp?vendorId=" + encodeURIComponent(v.id) + "&vendorName=" + encodeURIComponent(v.name);

                const button = document.createElement("button");
                button.textContent = "View Products";

                a.appendChild(button);
                div.appendChild(p);
                div.appendChild(a);
                container.appendChild(div);
            });


        })
        .catch(err => {
            document.getElementById("vendorList").innerHTML =
                `<p style="color:red;">Failed to load vendors. ${err}</p>`;
        });

    function logout() {
        localStorage.removeItem("userData");
        window.location.href = "login.jsp";
    }
</script>

</body>
</html>
