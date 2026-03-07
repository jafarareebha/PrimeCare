<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.primecare.dao.*" %>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    PatientDAO pDao = new PatientDAO();
    BillingDAO bDao = new BillingDAO();
    ClaimDAO cDao = new ClaimDAO();
    int totalPatients = pDao.getAllPatients().size();
    int totalBills = bDao.getAllDailyBills().size();
    int pendingClaims = cDao.getPendingClaims().size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - PrimeCare</title>
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
        <div class="page-title">Dashboard</div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= totalPatients %></div>
                <div class="stat-label">Total Patients</div>
            </div>
            <div class="stat-card green">
                <div class="stat-value"><%= totalBills %></div>
                <div class="stat-label">Daily Bills Generated</div>
            </div>
            <div class="stat-card orange">
                <div class="stat-value"><%= pendingClaims %></div>
                <div class="stat-label">Pending Insurance Claims</div>
            </div>
        </div>

        <div class="card">
            <div class="card-title">Quick Actions</div>
            <div style="display:flex;flex-wrap:wrap;gap:12px;">
                <a href="addPatient.jsp" class="btn btn-primary">Register New Patient</a>
                <a href="generateBill.jsp" class="btn btn-success">Generate Bill</a>
                <a href="labTests.jsp" class="btn btn-warning">Add Lab Tests</a>
                <a href="ClaimServlet" class="btn btn-secondary">Manage Insurance Claims</a>
                <a href="searchPatient.jsp" class="btn btn-secondary">Search Patient</a>
            </div>
        </div>

        <div class="card">
            <div class="card-title">Recent Daily Bills</div>
            <%
                List<com.primecare.model.DailyBill> recentBills = bDao.getAllDailyBills();
                if (recentBills.isEmpty()) {
            %>
                <p style="color:#7f8c8d;text-align:center;padding:20px;">No bills generated yet.</p>
            <% } else { %>
            <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Patient ID</th>
                        <th>Treatment Date</th>
                        <th>Doctor Fee</th>
                        <th>Pharmacy</th>
                        <th>Room</th>
                        <th>Lab</th>
                        <th>Other</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% int shown = 0; for (com.primecare.model.DailyBill b : recentBills) { if (shown++ >= 10) break; %>
                    <tr>
                        <td>#<%= b.getBillId() %></td>
                        <td><%= b.getPatientId() %></td>
                        <td><%= b.getTreatmentDate() %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getDoctorFee()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getPharmacyFee()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getRoomCharges()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getLabCharges()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getOtherCharges()) %></td>
                        <td><strong>&#8377;<%= String.format("%.2f", b.getTotalAmount()) %></strong></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
