<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.primecare.dao.*,com.primecare.model.*,java.util.*" %>
<%
    if (session.getAttribute("adminUser") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    PatientDAO patDAO = new PatientDAO();
    List<Patient> allPatients = patDAO.getAllPatients();
    BillingDAO billingDAO = new BillingDAO();
    InsuranceDAO insDAO = new InsuranceDAO();
    PaymentDAO payDAO = new PaymentDAO();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Consolidated Bills - PrimeCare</title>
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
        <div class="page-title">Consolidated Bills</div>

        <div class="card">
            <div class="card-title">Generate Consolidated Bill</div>
            <form action="ClaimServlet" method="post" style="display:flex;gap:12px;align-items:flex-end;">
                <input type="hidden" name="action" value="generateClaim">
                <div class="form-group" style="flex:1;margin:0;">
                    <label>Patient ID</label>
                    <input type="text" name="patientId" placeholder="Enter Patient ID" required>
                </div>
                <button type="submit" class="btn btn-success">Generate Insurance Claim</button>
            </form>
        </div>

        <% for (Patient p : allPatients) {
            FinalBill fb = billingDAO.getLatestFinalBillByPatient(p.getPatientId());
            List<DailyBill> dailyBills = billingDAO.getDailyBillsByPatient(p.getPatientId());
            if (dailyBills.isEmpty()) continue;
            Insurance ins = insDAO.getInsuranceByPatientId(p.getPatientId());
            double totalPaid = payDAO.getTotalPaidByPatient(p.getPatientId());
            double grandTotal = 0;
            double totalDoctor = 0, totalPharmacy = 0, totalRoom = 0, totalLab = 0, totalOther = 0, totalTreatment = 0;
            for (DailyBill b : dailyBills) {
                grandTotal += b.getTotalAmount();
                totalDoctor += b.getDoctorFee();
                totalPharmacy += b.getPharmacyFee();
                totalRoom += b.getRoomCharges();
                totalLab += b.getLabCharges();
                totalOther += b.getOtherCharges();
                totalTreatment += b.getTreatmentCharges();
            }
        %>
        <div class="card" style="margin-bottom:28px;">
            <div class="card-title">
                <%= p.getPatientName() %> &nbsp;<span style="color:#7f8c8d;font-weight:400;font-size:0.88rem;">(Patient ID: <%= p.getPatientId() %>)</span>
            </div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                <div>
                    <div class="summary-row"><span>Doctor Fees</span><span>&#8377;<%= String.format("%.2f", totalDoctor) %></span></div>
                    <div class="summary-row"><span>Pharmacy Charges</span><span>&#8377;<%= String.format("%.2f", totalPharmacy) %></span></div>
                    <div class="summary-row"><span>Room Charges</span><span>&#8377;<%= String.format("%.2f", totalRoom) %></span></div>
                    <div class="summary-row"><span>Lab Charges</span><span>&#8377;<%= String.format("%.2f", totalLab) %></span></div>
                    <div class="summary-row"><span>Treatment Charges</span><span>&#8377;<%= String.format("%.2f", totalTreatment) %></span></div>
                    <div class="summary-row"><span>Other Charges</span><span>&#8377;<%= String.format("%.2f", totalOther) %></span></div>
                    <div class="summary-row total"><span>Total Before Insurance</span><span>&#8377;<%= String.format("%.2f", grandTotal) %></span></div>
                    <% if (ins != null) { %>
                    <div class="summary-row discount"><span>Insurance (<%= ins.getInsuranceProvider() %>, <%= String.format("%.0f", ins.getCoveragePercentage()) %>%)</span>
                        <span>- &#8377;<%= fb != null ? String.format("%.2f", fb.getInsuranceClaim()) : "0.00" %></span>
                    </div>
                    <% } %>
                </div>
                <div>
                    <% double payable = (fb != null) ? fb.getPatientPayable() : grandTotal;
                       double remaining = payable - totalPaid; %>
                    <div class="total-payable">
                        <div class="label">Patient Payable</div>
                        <div class="amount">&#8377;<%= String.format("%.2f", payable) %></div>
                    </div>
                    <div style="margin-top:14px;background:#f8fbff;border-radius:8px;padding:14px;">
                        <div class="summary-row"><span>Total Paid</span><span style="color:#27ae60;font-weight:600;">&#8377;<%= String.format("%.2f", totalPaid) %></span></div>
                        <div class="summary-row"><span>Remaining Balance</span><span style="color:<%= remaining > 0 ? "#e74c3c" : "#27ae60" %>;font-weight:700;">&#8377;<%= String.format("%.2f", remaining) %></span></div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
