<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.primecare.dao.PharmacyDAO, com.primecare.dao.PatientDAO" %>
<%@ page import="com.primecare.model.Pharmacy, com.primecare.model.Patient" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    PharmacyDAO pharmDAO = new PharmacyDAO();
    PatientDAO patDAO   = new PatientDAO();
    List<Pharmacy> records = (List<Pharmacy>) request.getAttribute("pharmacyRecords");
    if (records == null) records = pharmDAO.getAllRecords();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pharmacy - PrimeCare</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .file-hint { font-size:0.8rem; color:#7f8c8d; margin-top:4px; }
        .prescription-link { color:#2980b9; text-decoration:none; font-size:0.85rem; }
        .prescription-link:hover { text-decoration:underline; }
    </style>
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
        <div class="page-title">Pharmacy</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <%-- Form uses enctype multipart for optional file upload --%>
        <div class="card">
            <div class="card-title">Add Pharmacy Record</div>
            <form action="PharmacyServlet" method="post" enctype="multipart/form-data">
                <div class="form-row">
                    <div class="form-group">
                        <label>Patient ID</label>
                        <input type="text" name="patientId" placeholder="Enter Patient ID" required>
                    </div>
                    <div class="form-group">
                        <label>Date</label>
                        <input type="date" name="date" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Pharmacy Charges (&#8377;)</label>
                        <input type="number" name="pharmacyCharges" placeholder="0.00" step="0.01" min="0.01" required>
                    </div>
                    <div class="form-group">
                        <label>Upload Prescription <span style="color:#7f8c8d;font-weight:400;">(optional)</span></label>
                        <input type="file" name="prescription" accept=".pdf,.jpg,.jpeg,.png"
                               style="padding:8px;background:#fafcfe;">
                        <div class="file-hint">Accepted: PDF, JPG, PNG — max 10 MB</div>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Save Pharmacy Record</button>
            </form>
        </div>

        <div class="card">
            <div class="card-title">Pharmacy Records</div>
            <% if (records.isEmpty()) { %>
                <p style="text-align:center;color:#7f8c8d;padding:28px;">No pharmacy records found.</p>
            <% } else { %>
            <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Patient ID</th>
                        <th>Patient Name</th>
                        <th>Date</th>
                        <th>Pharmacy Charges</th>
                        <th>Prescription</th>
                        <th>Created At</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Pharmacy r : records) {
                        Patient p = patDAO.getPatientById(r.getPatientId());
                        String pName = (p != null) ? p.getPatientName() : "-";
                    %>
                    <tr>
                        <td>#<%= r.getId() %></td>
                        <td><%= r.getPatientId() %></td>
                        <td><%= pName %></td>
                        <td><%= r.getDate() %></td>
                        <td>&#8377;<%= String.format("%.2f", r.getPharmacyCharges()) %></td>
                        <td>
                            <% if (r.getPrescriptionPath() != null && !r.getPrescriptionPath().isEmpty()) { %>
                                <a href="<%= r.getPrescriptionPath() %>" target="_blank" class="prescription-link">View File</a>
                            <% } else { %>
                                <span style="color:#bdc3c7;">None</span>
                            <% } %>
                        </td>
                        <td><%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0,16) : "-" %></td>
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
