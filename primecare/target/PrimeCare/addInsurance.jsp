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
    <title>Add Insurance - PrimeCare</title>
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
        <div class="page-title">Add Insurance</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="card">
            <div class="card-title">Insurance Information</div>
            <form action="InsuranceServlet" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label>Patient ID</label>
                        <input type="text" name="patientId" placeholder="Enter Patient ID" required>
                    </div>
                    <div class="form-group">
                        <label>Insurance Provider</label>
                        <input type="text" name="insuranceProvider" placeholder="e.g. Star Health, LIC" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Policy Number</label>
                        <input type="text" name="policyNumber" placeholder="Policy number" required>
                    </div>
                    <div class="form-group">
                        <label>Coverage Percentage (%)</label>
                        <input type="number" name="coveragePercentage" placeholder="e.g. 80" step="0.01" min="0" max="100" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Maximum Coverage Amount (&#8377;)</label>
                        <input type="number" name="maxCoverageAmount" placeholder="e.g. 500000" step="0.01" min="0" required>
                    </div>
                    <div class="form-group">
                        <label>Coverage Usage Limit (&#8377;)</label>
                        <input type="number" name="coverageUsageLimit" placeholder="e.g. 300000" step="0.01" min="0" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Save Insurance Record</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
