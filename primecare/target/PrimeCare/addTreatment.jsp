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
    <title>Add Treatment - PrimeCare</title>
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
        <div class="page-title">Add Treatment</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="card">
            <div class="card-title">Treatment Details</div>
            <form action="BillingServlet" method="post">
                <input type="hidden" name="action" value="addTreatment">
                <div class="form-row">
                    <div class="form-group">
                        <label>Patient ID</label>
                        <input type="text" name="patientId" placeholder="Enter Patient ID" required>
                    </div>
                    <div class="form-group">
                        <label>Treatment Date</label>
                        <input type="date" name="treatmentDate" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Treatment Name</label>
                        <input type="text" name="treatmentName" placeholder="e.g. Appendectomy, Physiotherapy" required>
                    </div>
                    <div class="form-group">
                        <label>Treatment Cost (&#8377;)</label>
                        <input type="number" name="treatmentCost" placeholder="0.00" step="0.01" min="0" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Save Treatment</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
