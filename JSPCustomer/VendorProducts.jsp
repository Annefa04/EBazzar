<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vendor Products</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .product {
            border: 1px solid #ccc;
            padding: 12px;
            margin-bottom: 10px;
            background: #f9f9f9;
        }
        a { text-decoration: none; color: #007BFF; }
        input[type="number"] { width: 60px; }
        button { margin-top: 5px; }
    </style>
</head>
<body>

<h2 id="welcomeText">Welcome 👋</h2>
<h3 id="vendorHeader">Browsing Products from: ...</h3>

<div id="productList">
    <p>Loading products...</p>
</div>

<br>
<a href="bazaar.jsp">← Back to Bazaar</a> |
<a href="viewCart.jsp">🛒 View Cart</a>

<script>
    const custName = sessionStorage.getItem("custName");
    const custEmail = sessionStorage.getItem("custEmail");

    if (!custName || !custEmail) {
        alert("Please login first.");
        window.location.href = "login.jsp";
    } else {
        document.getElementById("welcomeText").innerText = `Welcome, ${custName} 👋`;
    }

    const urlParams = new URLSearchParams(window.location.search);
    const vendorId = urlParams.get("vendorId");

    if (!vendorId) {
        alert("No vendor selected.");
        window.location.href = "bazaar.jsp";
    }

    // Load vendor name
    fetch(`http://localhost:8080/backend-api/vendors/${vendorId}`)
        .then(res => res.json())
        .then(vendor => {
            document.getElementById("vendorHeader").innerText = `Browsing Products from: ${vendor.name}`;
        })
        .catch(() => {
            document.getElementById("vendorHeader").innerText = "Failed to load vendor info.";
        });

    // Load product list
    fetch(`http://localhost:8080/backend-api/products?vendorId=${vendorId}`)
        .then(res => res.json())
        .then(products => {
            const container = document.getElementById("productList");
            container.innerHTML = "";

            if (products.length === 0) {
                container.innerHTML = "<p>No products found for this vendor.</p>";
            } else {
                products.forEach(p => {
                    const div = document.createElement("div");
                    div.className = "product";

                    div.innerHTML = `
                        <p><strong>${p.name}</strong> - RM ${p.price.toFixed(2)}</p>
                        <p><em>${p.description}</em></p>
                        Quantity: <input type="number" id="qty-${p.id}" value="1" min="1" />
                        <button onclick="addToCart(${p.id}, '${p.name}', '${p.description}', ${p.price}, ${vendorId})">Add to Cart</button>
                    `;

                    container.appendChild(div);
                });
            }
        })
        .catch(err => {
            document.getElementById("productList").innerHTML = "<p style='color:red;'>Failed to load products.</p>";
            console.error(err);
        });

    function addToCart(productId, productName, productDescription, price, vendorId) {
        const qty = parseInt(document.getElementById(`qty-${productId}`).value);
        if (isNaN(qty) || qty < 1) {
            alert("Please enter a valid quantity.");
            return;
        }

        const cart = JSON.parse(sessionStorage.getItem("cart") || "[]");

        // Check if product already exists in cart
        const index = cart.findIndex(item => item.productId === productId && item.vendorId === vendorId);
        if (index !== -1) {
            cart[index].quantity += qty;
        } else {
            cart.push({
                productId,
                vendorId,
                productName,
                productDescription,
                price,
                quantity: qty
            });
        }

        sessionStorage.setItem("cart", JSON.stringify(cart));
        alert(`${productName} added to cart.`);
    }
</script>

</body>
</html>
