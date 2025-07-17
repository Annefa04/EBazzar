<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bazaar - Choose a Vendor</title>
    <style>
        body { font-family: Arial; padding: 30px; background-color: #f9f9f9; }
        .vendor {
            padding: 15px;
            margin: 10px 0;
            background: #ffffff;
            border: 1px solid #ccc;
        }
        .vendor a {
            font-weight: bold;
            text-decoration: none;
            color: #007BFF;
        }
        .top-links {
            margin-bottom: 20px;
        }
        .logout-link {
            color: red;
            text-decoration: none;
            font-weight: bold;
            margin-left: 20px;
        }
    </style>
</head>
<body>

<div class="top-links">
    <h2 id="welcomeMessage">Welcome! 👋</h2>
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
    const API_BASE_URL = "http://192.168.0.54:8080/api"; // ✅ Correct backend address

    const custName = sessionStorage.getItem("custName");
    const custEmail = sessionStorage.getItem("custEmail");

    if (!custName || !custEmail) {
        alert("Please login first.");
        window.location.href = "login.jsp";
    } else {
        document.getElementById("welcomeMessage").innerText = `Welcome, ${custName}! 👋`;
    }

    // 🔗 Fetch vendors from backend
    fetch(`${API_BASE_URL}/vendors`)
        .then(response => response.json())
        .then(vendors => {
            const container = document.getElementById("vendorList");
            container.innerHTML = "";

            if (vendors.length === 0) {
                container.innerHTML = "<p>No vendors found.</p>";
            } else {
                vendors.forEach(v => {
                    const div = document.createElement("div");
                    div.className = "vendor";
                    div.innerHTML = `
                        <p><strong>${v.name}</strong></p>
                        <a href="vendorProducts.jsp?vendorId=${v.id}" onclick="sessionStorage.setItem('vendorName', '${v.name}');">
                            View Products
                        </a>
                    `;
                    container.appendChild(div);
                });
            }
        })
        .catch(error => {
            document.getElementById("vendorList").innerHTML =
                `<p style="color:red;">Failed to load vendors. ${error.message}</p>`;
        });

    function logout() {
        sessionStorage.clear();
        window.location.href = "login.jsp";
    }
</script>

</body>
</html>
