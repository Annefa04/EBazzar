<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - eBazaar</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            height: 100vh;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f0f0f0;
        }
        .login-container {
            background-color: #f9f9f9;
            padding: 25px;
            width: 320px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        input[type="text"],
        input[type="password"] {
            width: 95%;
            padding: 8px;
            margin: 5px 0 15px 0;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .error {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Customer Login</h2>

    <form id="loginForm">
        Email: <input type="text" id="email" required><br>
        Password: <input type="password" id="password" required><br>
        <input type="submit" value="Login">
        <div class="error" id="errorMsg"></div>
    </form>
</div>

<script>
    const BACKEND_URL = "http://192.168.0.54:8080/eBazaarBackend/api/login";

    async function login(email, password) {
        try {
            const response = await fetch(BACKEND_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ email, password })
            });

            if (!response.ok) throw new Error("Server error");

            return await response.json();

        } catch (error) {
            return { success: false, message: "Unable to connect to backend." };
        }
    }

    document.getElementById("loginForm").addEventListener("submit", async function (e) {
        e.preventDefault();

        const email = document.getElementById("email").value.trim();
        const password = document.getElementById("password").value.trim();
        const errorMsg = document.getElementById("errorMsg");
        errorMsg.textContent = "";

        if (!email || !password) {
            errorMsg.textContent = "❌ Please fill in both fields.";
            return;
        }

        const result = await login(email, password);

        if (result.success) {
            const userData = {
                custName: result.custName,
                custId: result.custId,
                custEmail: email
            };
            localStorage.setItem("userData", JSON.stringify(userData));
            window.location.href = "bazaar.jsp";
        } else {
            errorMsg.textContent = "❌ " + (result.message || "Invalid credentials.");
        }
    });
</script>

</body>
</html>
