<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.primecare.dao.*,com.primecare.model.*,java.util.*" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    ClaimDAO claimDAO = new ClaimDAO();
    List<Claim> allClaims = (List<Claim>) request.getAttribute("allClaims");
    if (allClaims == null) allClaims = claimDAO.getAllClaims();
    PatientDAO patDAO = new PatientDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Approve Insurance Claims - PrimeCare</title>
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
        <div class="page-title">Approve Insurance Claims</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="card">
            <div class="card-title">Generate Insurance Claim for Patient</div>
            <form action="ClaimServlet" method="post" style="display:flex;gap:12px;align-items:flex-end;">
                <input type="hidden" name="action" value="generateClaim">
                <div class="form-group" style="flex:1;margin:0;">
                    <label>Patient ID</label>
                    <input type="text" name="patientId" placeholder="Enter Patient ID to generate claim">
                </div>
                <button type="submit" class="btn btn-primary">Generate Claim</button>
            </form>
        </div>

        <div class="card">
            <div class="card-title">All Insurance Claims</div>
            <% if (allClaims.isEmpty()) { %>
                <p style="color:#7f8c8d;text-align:center;padding:30px;">No insurance claims found.</p>
            <% } else { %>
            <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Claim ID</th>
                        <th>Patient ID</th>
                        <th>Patient Name</th>
                        <th>Claim Amount</th>
                        <th>Status</th>
                        <th>Rejection Reason</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Claim c : allClaims) {
                        Patient p = patDAO.getPatientById(c.getPatientId());
                        String pName = (p != null) ? p.getPatientName() : "-";
                    %>
                    <tr>
                        <td>#<%= c.getId() %></td>
                        <td><%= c.getPatientId() %></td>
                        <td><%= pName %></td>
                        <td>&#8377;<%= String.format("%.2f", c.getClaimAmount()) %></td>
                        <td>
                            <span class="badge badge-<%= c.getStatus().toLowerCase() %>"><%= c.getStatus() %></span>
                        </td>
                        <td><%= c.getRejectionReason() != null ? c.getRejectionReason() : "-" %></td>
                        <td><%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,10) : "-" %></td>
                        <td>
                            <% if ("PENDING".equals(c.getStatus())) { %>
                            <form action="ClaimServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="claimId" value="<%= c.getId() %>">
                                <button type="submit" class="btn btn-success btn-sm">Approve</button>
                            </form>
                            <button type="button" class="btn btn-danger btn-sm" onclick="showReject(<%= c.getId() %>)">Reject</button>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Reject Modal -->
<div id="rejectModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
    <div style="background:white;border-radius:12px;padding:32px;width:460px;">
        <h3 style="margin-bottom:16px;color:#c0392b;">Reject Insurance Claim</h3>
        <form action="ClaimServlet" method="post">
            <input type="hidden" name="action" value="reject">
            <input type="hidden" name="claimId" id="rejectClaimId">
            <div class="form-group">
                <label>Rejection Reason</label>
                <textarea name="rejectionReason" rows="3" placeholder="Enter reason for rejection..." required style="width:100%;padding:10px;border:1.5px solid #c8d8e8;border-radius:6px;"></textarea>
            </div>
            <div style="display:flex;gap:10px;">
                <button type="submit" class="btn btn-danger">Confirm Rejection</button>
                <button type="button" onclick="closeReject()" class="btn btn-secondary">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
function showReject(id) {
    document.getElementById('rejectClaimId').value = id;
    document.getElementById('rejectModal').style.display = 'flex';
}
function closeReject() {
    document.getElementById('rejectModal').style.display = 'none';
}
</script>
</body>
</html>
