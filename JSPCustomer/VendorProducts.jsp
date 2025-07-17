<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vendor Products</title>
    <style>
        body { font-family: Arial; padding: 20px; background-color: #f9f9f9; }
        .product { border: 1px solid #ccc; padding: 12px; margin-bottom: 10px; background: #fff; }
        a { text-decoration: none; color: #007BFF; }
        input[type="number"] { width: 60px; }
        button {
            margin-top: 5px;
            padding: 5px 10px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover { background-color: #0056b3; }
    </style>
</head>
<body>

<h3 id="vendorHeader">Browsing Products from: ...</h3>

<div id="productList">
    <p>Loading products...</p>
</div>

<br>
<a href="bazaar.jsp">← Back to Bazaar</a> |
<a href="viewCart.jsp">🛒 View Cart</a>

<script>
    function addToCart(productId, productName, productDescription, price, vendorId) {
        const qtyInput = document.getElementById("qty-" + productId);
        const qty = parseInt(qtyInput.value);
        const userData = JSON.parse(localStorage.getItem("userData") || "{}");

        if (!qty || qty < 1) {
            alert("Please enter a valid quantity.");
            return;
        }

        const custId = userData.custId;
        if (!custId) {
            alert("You must be logged in to add items.");
            window.location.href = "login.jsp";
            return;
        }

        // Optional: Store locally
        let cart = JSON.parse(localStorage.getItem("cart") || "[]");
        const index = cart.findIndex(item => item.productId === productId && item.vendorId == vendorId);
        if (index !== -1) {
            cart[index].quantity += qty;
        } else {
            cart.push({ productId, vendorId, productName, productDescription, price, quantity: qty });
        }
        localStorage.setItem("cart", JSON.stringify(cart));

        // ✅ POST to backend
        fetch("http://192.168.0.54:8080/eBazaarBackend/api/cart", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                custId: custId,
                productId: productId,
                quantity: qty
            })
        })
        .then(res => {
            if (!res.ok) throw new Error("Failed to add item to server");
            return res.json();
        })
        .then(data => {
            console.log("[DEBUG] Server responded:", data);
            showPopup(productName + " added to cart ✅");
        })
        .catch(err => {
            console.error("[ERROR] Backend error:", err);
            alert("Something went wrong. Try again.");
        });
    }

    function showPopup(message) {
        const popup = document.createElement("div");
        popup.innerText = message;
        popup.style.position = "fixed";
        popup.style.bottom = "20px";
        popup.style.right = "20px";
        popup.style.backgroundColor = "#28a745";
        popup.style.color = "white";
        popup.style.padding = "10px 20px";
        popup.style.borderRadius = "8px";
        popup.style.boxShadow = "0 0 10px rgba(0,0,0,0.2)";
        popup.style.zIndex = "9999";
        document.body.appendChild(popup);
        setTimeout(() => popup.remove(), 2000);
    }

    window.onload = function () {
        const userData = JSON.parse(localStorage.getItem("userData") || "{}");

        if (!userData.custName || !userData.custId) {
            alert("Please login first.");
            window.location.href = "login.jsp";
            return;
        }

        const urlParams = new URLSearchParams(window.location.search);
        const vendorId = urlParams.get("vendorId");
        const vendorName = urlParams.get("vendorName");

        // ✅ Fix: only set localStorage after vendorId is obtained
        if (vendorId && vendorName) {
            localStorage.setItem("lastVendorId", vendorId);
            localStorage.setItem("lastVendorName", vendorName);
        }

        if (!vendorId || vendorId.trim() === "") {
            alert("❌ No vendor selected.");
            window.location.href = "bazaar.jsp";
            return;
        }

        document.getElementById("vendorHeader").innerText =
            vendorName
            ? "Browsing Products from: " + vendorName
            : "Browsing Products";


        fetch("http://192.168.0.54:8080/eBazaarBackend/api/products?vendorId=" + encodeURIComponent(vendorId))
            .then(res => {
                if (!res.ok) throw new Error("Failed to load products.");
                return res.json();
            })
            .then(products => {
                const container = document.getElementById("productList");
                container.innerHTML = "";

                if (!products || products.length === 0) {
                    container.innerHTML = "<p>No products found for this vendor.</p>";
                    return;
                }

                products.forEach(p => {
                    const escapedName = (p.name || "").replace(/'/g, "\\'");
                    const escapedDesc = (p.description || "").replace(/'/g, "\\'");
                    const price = Number(p.price);

                    const div = document.createElement("div");
                    div.className = "product";

                    div.innerHTML =
                        "<p><strong>" + escapedName + "</strong> - RM " +
                        (!isNaN(price) ? price.toFixed(2) : '0.00') + "</p>" +
                        "<p><em>" + escapedDesc + "</em></p>" +
                        "Quantity: <input type='number' id='qty-" + p.id + "' value='1' min='1' />" +
                        "<button onclick=\"addToCart(" + p.id + ", '" + escapedName + "', '" + escapedDesc + "', " + price + ", '" + vendorId + "')\">Add to Cart</button>";

                    container.appendChild(div);
                });
            })
            .catch(err => {
                document.getElementById("productList").innerHTML =
                    "<p style='color:red;'>Failed to load products.</p>";
                console.error("[ERROR] Fetch failed:", err);
            });
    };

</script>

</body>
</html>
