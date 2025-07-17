 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
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
        e.preventDefault();

        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

        if (!email || !password) {
            errorMsg.textContent = 'Please enter both email and password';
            return;
        }

        loadingSpinner.style.display = 'block';
        errorMsg.textContent = '';
        successMsg.textContent = '';

        try {
            const response = await fetch('http://192.168.0.54:8080/eBazaarBackend/api/loginrider', {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                    "Accept": "application/json"
                },
                body: "email=" + encodeURIComponent(email) +
                      "&password=" + encodeURIComponent(password)
            });

            const data = await response.json();

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
        } finally {
            loadingSpinner.style.display = 'none';
        }
    });
});
</script>
</body>
</html>
