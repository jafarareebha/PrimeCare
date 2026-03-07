<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Portal - PrimeCare</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">Prime<span>Care</span></div>
        <div class="auth-subtitle">Patient Portal</div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="PatientLoginServlet" method="post">
            <div class="form-group">
                <label>Patient ID</label>
                <input type="text" name="patientId" placeholder="Enter your Patient ID" required autofocus>
            </div>
            <div class="form-group">
                <label>Patient Name</label>
                <input type="text" name="patientName" placeholder="Enter your full name" required>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%;margin-top:6px;">Access My Bills</button>
        </form>

        <div class="auth-link">
            Hospital Staff? <a href="login.jsp">Admin Login</a>
        </div>
    </div>
</div>
</body>
</html>
