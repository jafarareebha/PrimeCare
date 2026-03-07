<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.primecare.dao.*,com.primecare.model.*,java.util.*" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    List<DailyBill> dailyBills = (List<DailyBill>) request.getAttribute("dailyBills");
    FinalBill finalBill = (FinalBill) request.getAttribute("finalBill");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    Double totalPaid = (Double) request.getAttribute("totalPaid");
    Double remainingBalance = (Double) request.getAttribute("remainingBalance");
    Insurance insurance = (Insurance) request.getAttribute("insurance");
    String query = (String) request.getAttribute("query");
    LabTestDAO labDAO = new LabTestDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Patient - PrimeCare</title>
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
        <div class="page-title">Search Patient</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>

        <div class="card">
            <form action="PatientSearchServlet" method="get">
                <div class="search-bar">
                    <input type="text" name="query" placeholder="Search by Patient ID or Name..." value="<%= query != null ? query : "" %>">
                    <button type="submit" class="btn btn-primary">Search</button>
                </div>
            </form>
        </div>

        <% if (patients != null && !patients.isEmpty()) { %>
            <% if (patients.size() > 1) { %>
            <div class="card">
                <div class="card-title">Search Results</div>
                <div class="table-wrapper">
                <table>
                    <thead><tr><th>Patient ID</th><th>Name</th><th>Age</th><th>Gender</th><th>Contact</th><th>View</th></tr></thead>
                    <tbody>
                        <% for (Patient p : patients) { %>
                        <tr>
                            <td><%= p.getPatientId() %></td>
                            <td><%= p.getPatientName() %></td>
                            <td><%= p.getAge() %></td>
                            <td><%= p.getGender() %></td>
                            <td><%= p.getContactNumber() %></td>
                            <td><a href="PatientSearchServlet?query=<%= p.getPatientId() %>" class="btn btn-primary btn-sm">View</a></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                </div>
            </div>
            <% } %>

            <% if (patients.size() == 1 && dailyBills != null) {
                Patient pat = patients.get(0); %>
            <div class="patient-info-box">
                <h3>Patient Information</h3>
                <div class="patient-info-grid">
                    <div class="patient-info-item"><div class="label">Patient ID</div><div class="value"><%= pat.getPatientId() %></div></div>
                    <div class="patient-info-item"><div class="label">Name</div><div class="value"><%= pat.getPatientName() %></div></div>
                    <div class="patient-info-item"><div class="label">Age</div><div class="value"><%= pat.getAge() %> years</div></div>
                    <div class="patient-info-item"><div class="label">Gender</div><div class="value"><%= pat.getGender() %></div></div>
                    <div class="patient-info-item"><div class="label">Contact</div><div class="value"><%= pat.getContactNumber() %></div></div>
                    <% if (insurance != null) { %>
                    <div class="patient-info-item"><div class="label">Insurance</div><div class="value"><%= insurance.getInsuranceProvider() %></div></div>
                    <% } %>
                </div>
            </div>

            <!-- Daily Bills -->
            <div class="card">
                <div class="card-title">Daily Bills</div>
                <% if (dailyBills.isEmpty()) { %>
                    <p style="color:#7f8c8d;text-align:center;padding:20px;">No daily bills found.</p>
                <% } else { %>
                <div class="table-wrapper">
                <table>
                    <thead>
                        <tr><th>Bill ID</th><th>Treatment Date</th><th>Doctor Fee</th><th>Pharmacy</th><th>Room</th><th>Lab</th><th>Treatment</th><th>Other</th><th>Total</th></tr>
                    </thead>
                    <tbody>
                        <% for (DailyBill b : dailyBills) { %>
                        <tr>
                            <td>#<%= b.getBillId() %></td>
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
                </table>
                </div>
                <% } %>
            </div>

            <!-- Consolidated Bill -->
            <% if (finalBill != null) { %>
            <div class="card">
                <div class="card-title">Consolidated Bill (Bill ID: #<%= finalBill.getId() %>)</div>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                    <div>
                        <div class="summary-row"><span>Total Before Insurance</span><span>&#8377;<%= String.format("%.2f", finalBill.getTotalBeforeInsurance()) %></span></div>
                        <% if (insurance != null) { %>
                        <div class="summary-row discount"><span>Insurance Claim (<%= insurance.getInsuranceProvider() %>)</span><span>- &#8377;<%= String.format("%.2f", finalBill.getInsuranceClaim()) %></span></div>
                        <% } %>
                        <div class="summary-row total"><span>Patient Payable</span><span>&#8377;<%= String.format("%.2f", finalBill.getPatientPayable()) %></span></div>
                    </div>
                    <div>
                        <div class="total-payable">
                            <div class="label">Amount Due</div>
                            <div class="amount">&#8377;<%= String.format("%.2f", remainingBalance != null ? remainingBalance : finalBill.getPatientPayable()) %></div>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Record Payment -->
            <div class="card">
                <div class="card-title">Record Payment</div>
                <form action="PaymentServlet" method="post">
                    <input type="hidden" name="patientId" value="<%= pat.getPatientId() %>">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Amount Paid (&#8377;)</label>
                            <input type="number" name="amountPaid" placeholder="0.00" step="0.01" min="0" required>
                        </div>
                        <div class="form-group">
                            <label>Payment Date</label>
                            <input type="date" name="paymentDate" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Notes (optional)</label>
                        <input type="text" name="notes" placeholder="e.g. Cash payment, UPI">
                    </div>
                    <button type="submit" class="btn btn-success">Record Payment</button>
                </form>
            </div>

            <!-- Payment History -->
            <div class="card">
                <div class="card-title">Payment History</div>
                <% if (payments == null || payments.isEmpty()) { %>
                    <p style="color:#7f8c8d;text-align:center;padding:20px;">No payments recorded yet.</p>
                <% } else { %>
                <div class="table-wrapper">
                <table>
                    <thead><tr><th>Payment ID</th><th>Date</th><th>Amount Paid</th><th>Notes</th></tr></thead>
                    <tbody>
                        <% for (Payment pay : payments) { %>
                        <tr>
                            <td>#<%= pay.getPaymentId() %></td>
                            <td><%= pay.getPaymentDate() %></td>
                            <td style="color:#27ae60;font-weight:600;">&#8377;<%= String.format("%.2f", pay.getAmountPaid()) %></td>
                            <td><%= pay.getNotes() != null ? pay.getNotes() : "-" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                    <tfoot>
                        <tr class="table-footer">
                            <td colspan="2" style="text-align:right;"><strong>Total Paid</strong></td>
                            <td style="color:#27ae60;font-weight:700;">&#8377;<%= String.format("%.2f", totalPaid != null ? totalPaid : 0) %></td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
                </div>
                <% } %>
            </div>
            <% } %>
        <% } else if (query != null && !query.isEmpty()) { %>
            <div class="alert alert-error">No patients found matching "<%= query %>".</div>
        <% } %>
    </div>
</div>
</body>
</html>
