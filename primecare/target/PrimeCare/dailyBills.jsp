<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.primecare.dao.*,com.primecare.model.*,java.util.*" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    BillingDAO dao = new BillingDAO();
    List<DailyBill> bills = dao.getAllDailyBills();
    PatientDAO patDAO = new PatientDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Daily Bills - PrimeCare</title>
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
        <div class="page-title">Daily Bills</div>

        <div class="card">
            <div class="card-title">All Daily Bills</div>
            <% if (bills.isEmpty()) { %>
                <p style="color:#7f8c8d;text-align:center;padding:30px;">No daily bills found.</p>
            <% } else { %>
            <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Patient ID</th>
                        <th>Patient Name</th>
                        <th>Treatment Date</th>
                        <th>Doctor Fee</th>
                        <th>Pharmacy</th>
                        <th>Room</th>
                        <th>Lab</th>
                        <th>Treatment</th>
                        <th>Other</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% double grandTotal = 0; for (DailyBill b : bills) {
                        Patient p = patDAO.getPatientById(b.getPatientId());
                        String name = (p != null) ? p.getPatientName() : "-";
                        grandTotal += b.getTotalAmount();
                    %>
                    <tr>
                        <td>#<%= b.getBillId() %></td>
                        <td><%= b.getPatientId() %></td>
                        <td><%= name %></td>
                        <td><%= b.getTreatmentDate() %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getDoctorFee()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getPharmacyFee()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getRoomCharges()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getLabCharges()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getTreatmentCharges()) %></td>
                        <td>&#8377;<%= String.format("%.2f", b.getOtherCharges()) %></td>
                        <td><strong>&#8377;<%= String.format("%.2f", b.getTotalAmount()) %></strong></td>
                    </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr class="table-footer">
                        <td colspan="10" style="text-align:right;padding-right:20px;"><strong>Grand Total</strong></td>
                        <td><strong>&#8377;<%= String.format("%.2f", grandTotal) %></strong></td>
                    </tr>
                </tfoot>
            </table>
            </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
