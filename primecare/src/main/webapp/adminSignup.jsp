<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Signup - PrimeCare</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">Prime<span>Care</span></div>
        <div class="auth-subtitle">Create Admin Account</div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="AdminSignupServlet" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Choose a username" required autofocus>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Create a password" required>
            </div>
            <div class="form-group">
                <label>Confirm Password</label>
                <input type="password" name="confirmPassword" placeholder="Re-enter your password" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;margin-top:6px;">Create Account</button>
        </form>

        <div class="auth-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>
</div>
</body>
</html>
