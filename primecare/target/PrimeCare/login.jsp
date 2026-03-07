<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - PrimeCare</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">Prime<span>Care</span></div>
        <div class="auth-subtitle">Hospital Billing &amp; Insurance Management</div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter your username" required autofocus>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;margin-top:6px;">Login</button>
        </form>

        <div class="auth-link">
            Don't have an account? <a href="adminSignup.jsp">Create Admin Account</a>
        </div>
        <div class="auth-link" style="margin-top:10px;">
            Patient? <a href="patientLogin.jsp">Patient Portal</a>
        </div>
    </div>
</div>
</body>
</html>
