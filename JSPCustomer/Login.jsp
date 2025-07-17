<<<<<<< HEAD
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
=======
 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
>>>>>>> c9fb014e9f74cb998be44737a7d9823562e8e4ca
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
<<<<<<< HEAD
    <title>Login - eBazaar</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;	
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .login-container h2 {
            margin-top: 0;
            color: #333;
            text-align: center;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }

        button[type="submit"]:hover {
            background-color: #45a049;
        }

        .error {
            color: #d32f2f;
            margin: 10px 0;
            text-align: center;
        }

        .loading-spinner {
            display: none;
            width: 40px;
            height: 40px;
            margin: 20px auto;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    <script src="js/config.js"></script>
</head>
<body>
    <div class="login-container">
        <h2>Customer Login</h2>
        <form id="loginForm">
            <input type="email" id="email" name="email" placeholder="Enter email" required>
            <input type="password" id="password" name="password" placeholder="Enter password" required>
            <button type="submit">Login</button>
            <div class="error" id="errorMsg"></div>
            <div class="loading-spinner" id="loadingSpinner"></div>
        </form>
    </div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const errorMsg = document.getElementById('errorMsg');
    const loadingSpinner = document.getElementById('loadingSpinner');

    loginForm.addEventListener('submit', async function(e) {
=======
    <title>Rider Login</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #00c9a7, #92fe9d);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-box {
            background: #fff;
            padding: 30px 20px;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.3);
            width: 350px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            color: #00a884;
        }

        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        .btn {
            width: 100%;
            background-color: #00a884;
            color: white;
            padding: 12px;
            margin-top: 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            transition: 0.3s ease;
        }

        .btn:hover {
            background-color: #007a63;
        }

        .error {
            color: red;
            margin-top: 15px;
        }

        .success {
            color: green;
            margin-top: 10px;
        }

        .loading-spinner {
            margin-top: 10px;
            display: none;
        }
    </style>
</head>
<body>
<div class="login-box">
    <h2>Rider Login</h2>
    <form id="loginForm">
        <input type="email" id="email" name="email" placeholder="Enter email" required>
        <input type="password" id="password" name="password" placeholder="Enter password" required>
        <button type="submit" class="btn">Login</button>
        <div class="error" id="errorMsg"></div>
        <div class="success" id="successMsg"></div>
        <div class="loading-spinner" id="loadingSpinner">Loading...</div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    const loginForm = document.getElementById('loginForm');
    const errorMsg = document.getElementById('errorMsg');
    const successMsg = document.getElementById('successMsg');
    const loadingSpinner = document.getElementById('loadingSpinner');

    loginForm.addEventListener('submit', async function (e) {
>>>>>>> c9fb014e9f74cb998be44737a7d9823562e8e4ca
        e.preventDefault();

        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

<<<<<<< HEAD
        // ✅ Proper validation check
        if (!email  !password) {
=======
        if (!email || !password) {
>>>>>>> c9fb014e9f74cb998be44737a7d9823562e8e4ca
            errorMsg.textContent = 'Please enter both email and password';
            return;
        }

        loadingSpinner.style.display = 'block';
        errorMsg.textContent = '';
<<<<<<< HEAD

        try {
            const response = await fetch("http://192.168.0.54:8080/eBazaarBackend/api/login", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({
                    email: email,
                    password: password
                })
=======
        successMsg.textContent = '';

        try {
            const response = await fetch('http://192.168.0.171:8080/eBazaar/api/loginrider', {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                    "Accept": "application/json"
                },
                body: "email=" + encodeURIComponent(email) +
                      "&password=" + encodeURIComponent(password)
>>>>>>> c9fb014e9f74cb998be44737a7d9823562e8e4ca
            });

            const data = await response.json();

<<<<<<< HEAD
            // ✅ Proper success check
            if (!response.ok  !data.success) {
                throw new Error(data.message  'Login failed');
            }

            // ✅ Store session data
            sessionStorage.setItem('authToken', data.token  '');
            sessionStorage.setItem('userData', JSON.stringify({
                custId: data.custId,
                custName: data.custName
            }));

            // ✅ Redirect
            window.location.href = 'dashboard.jsp';

        } catch (error) {
            errorMsg.textContent = error.message;
            console.error('Login error:', error);
=======
            if (!response.ok || !data.success) {
                throw new Error(data.message || 'Login failed');
            }

            successMsg.textContent = 'Login successful! Redirecting...';

            // Redirect to dashboard.jsp with riderId and riderName in URL
            setTimeout(() => {
                window.location.href =
                    "dashboard.jsp?riderId=" + encodeURIComponent(data.riderId) +
                    "&riderName=" + encodeURIComponent(data.riderName);
            }, 1500);

        } catch (error) {
            errorMsg.textContent = error.message;
            console.error("Login error:", error);
>>>>>>> c9fb014e9f74cb998be44737a7d9823562e8e4ca
        } finally {
            loadingSpinner.style.display = 'none';
        }
    });
});
</script>
</body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> c9fb014e9f74cb998be44737a7d9823562e8e4ca
