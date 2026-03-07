<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Patient - PrimeCare</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="header">
    <div class="logo">Prime<span>Care</span></div>

    <div class="header-right">
        Welcome, <%= session.getAttribute("adminUser") %> &nbsp;|&nbsp; Hospital Staff
        &nbsp;&nbsp;
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>
</div>
<div class="layout">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="page-title">Add New Patient</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="card">
            <div class="card-title">Patient Registration</div>
            <form action="AddPatientServlet" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label>Patient ID</label>
                        <input type="text" name="patientId" placeholder="e.g. P001" required>
                    </div>
                    <div class="form-group">
                        <label>Patient Name</label>
                        <input type="text" name="patientName" placeholder="Full name" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Age</label>
                        <input type="number" name="age" placeholder="Age" min="0" max="150" required>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <select name="gender" required>
                            <option value="">-- Select Gender --</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="text" name="contactNumber" placeholder="10-digit mobile number">
                </div>
                <button type="submit" class="btn btn-primary">Register Patient</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
