<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.primecare.dao.*,com.primecare.model.*,java.util.*" %>
<%
    String patientId = (String) session.getAttribute("patientId");
    String patientName = (String) session.getAttribute("patientName");
    if (patientId == null) {
        response.sendRedirect("patientLogin.jsp"); return;
    }
    PatientDAO patDAO = new PatientDAO();
    Patient patient = patDAO.getPatientById(patientId);
    BillingDAO billingDAO = new BillingDAO();
    LabTestDAO labDAO = new LabTestDAO();
    List<DailyBill> dailyBills = billingDAO.getDailyBillsByPatient(patientId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Detailed Bill - PrimeCare</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .print-bar { display:flex; gap:12px; margin-bottom:20px; }
        .btn-print {
            padding:10px 22px; background:#1a5276; color:white;
            border:none; border-radius:6px; cursor:pointer;
            font-size:0.93rem; font-weight:600; transition:background 0.2s;
        }
        .btn-print:hover { background:#154360; }

        /* ── PRINT STYLES ── */
        @media print {
            .header, .portal-nav, .print-bar, .patient-info-box { display:none !important; }

            body { margin:0; font-family:Arial,sans-serif; color:#000; }

            .print-header { text-align:center; margin-bottom:16px;
                border-bottom:2px solid #1a5276; padding-bottom:10px; }
            .print-header h1 { font-size:1.7rem; color:#1a5276; margin:0; }
            .print-header p  { margin:2px 0; font-size:0.88rem; color:#555; }

            .print-patient-box {
                display:grid; grid-template-columns:repeat(4,1fr); gap:6px;
                background:#f0f7ff !important; padding:10px 14px; border-radius:6px;
                margin-bottom:16px; font-size:0.85rem;
                -webkit-print-color-adjust:exact; print-color-adjust:exact;
            }
            .pi-label { color:#555; font-size:0.75rem; }
            .pi-value { font-weight:700; color:#1a5276; }

            .bill-date-header {
                background:#1a5276 !important; color:white !important;
                padding:7px 12px; font-weight:700;
                -webkit-print-color-adjust:exact; print-color-adjust:exact;
            }
            table { width:100%; border-collapse:collapse; margin-bottom:14px; }
            thead th {
                background:#1a5276 !important; color:white !important;
                padding:7px 10px; text-align:left; font-size:0.82rem;
                -webkit-print-color-adjust:exact; print-color-adjust:exact;
            }
            tbody td { padding:6px 10px; border-bottom:1px solid #ddd; font-size:0.85rem; }
            tfoot td { padding:7px 10px; background:#eaf4fb !important; font-weight:700;
                -webkit-print-color-adjust:exact; print-color-adjust:exact; }
            .card { box-shadow:none !important; border:1px solid #ddd; margin-bottom:12px; }
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">Prime<span>Care</span></div>
    <div class="header-right">
        <%= patientName %> &nbsp;|&nbsp;
        <a href="patientLogout.jsp" style="color:#aed6f1;">Logout</a>
    </div>
</div>

<div style="margin-top:64px;padding:32px 40px;">
    <div class="page-title">My Detailed Bill</div>

    <div class="portal-nav">
        <a href="viewDetailedBill.jsp" class="active">Detailed Bill (Day-wise)</a>
        <a href="viewConsolidatedBill.jsp">Consolidated Bill</a>
    </div>

    <div class="print-bar">
        <button class="btn-print" onclick="window.print()">&#128438; Print Detailed Bill</button>
        <button class="btn-print" onclick="window.location='viewConsolidatedBill.jsp?print=1'"
                style="background:#27ae60;">&#128438; Print Consolidated Bill</button>
    </div>

    <%-- Patient info (hidden when printing) --%>
    <% if (patient != null) { %>
    <div class="patient-info-box">
        <h3>Patient Information</h3>
        <div class="patient-info-grid">
            <div class="patient-info-item"><div class="label">Patient ID</div><div class="value"><%= patient.getPatientId() %></div></div>
            <div class="patient-info-item"><div class="label">Name</div><div class="value"><%= patient.getPatientName() %></div></div>
            <div class="patient-info-item"><div class="label">Age</div><div class="value"><%= patient.getAge() %> years</div></div>
            <div class="patient-info-item"><div class="label">Gender</div><div class="value"><%= patient.getGender() %></div></div>
            <div class="patient-info-item"><div class="label">Contact</div><div class="value"><%= patient.getContactNumber() %></div></div>
        </div>
    </div>
    <% } %>

    <%-- ══ PRINTABLE SECTION ══ --%>
    <div id="printSection">

        <%-- Print-only header (invisible on screen; shown by @media print) --%>
        <div class="print-header" style="display:none;">
            <h1>PrimeCare</h1>
            <p>Hospital Billing &amp; Insurance Management System</p>
            <p><strong>Detailed Bill &mdash; Day-wise Charges</strong></p>
            <% if (patient != null) { %>
            <p style="margin-top:8px;font-size:0.9rem;">
                Patient: <strong><%= patient.getPatientName() %></strong> &nbsp;|&nbsp;
                ID: <strong><%= patient.getPatientId() %></strong> &nbsp;|&nbsp;
                Age: <%= patient.getAge() %> / <%= patient.getGender() %>
            </p>
            <% } %>
        </div>

        <% if (dailyBills.isEmpty()) { %>
            <div class="card">
                <p style="text-align:center;color:#7f8c8d;padding:30px;">No bills found for your account.</p>
            </div>
        <% } else {
            for (DailyBill bill : dailyBills) {
                List<LabTest> labTests = labDAO.getLabTestsByPatientAndDate(patientId, bill.getTreatmentDate());
        %>
        <div class="card" style="margin-bottom:22px;padding:0;overflow:hidden;">
            <div class="bill-date-header">Treatment Date: <%= bill.getTreatmentDate() %></div>
            <div style="padding:16px;">
                <div class="table-wrapper">
                <table>
                    <thead>
                        <tr><th>Description</th><th style="text-align:right;">Amount (&#8377;)</th></tr>
                    </thead>
                    <tbody>
                        <% if (bill.getDoctorFee() > 0) { %>
                        <tr><td>Doctor Fee</td><td style="text-align:right;"><%= String.format("%.2f", bill.getDoctorFee()) %></td></tr>
                        <% } %>
                        <% if (bill.getPharmacyFee() > 0) { %>
                        <tr><td>Pharmacy Charges</td><td style="text-align:right;"><%= String.format("%.2f", bill.getPharmacyFee()) %></td></tr>
                        <% } %>
                        <% if (bill.getRoomCharges() > 0) { %>
                        <tr><td>Room Charges</td><td style="text-align:right;"><%= String.format("%.2f", bill.getRoomCharges()) %></td></tr>
                        <% } %>
                        <% if (bill.getTreatmentCharges() > 0) { %>
                        <tr><td>Treatment Charges</td><td style="text-align:right;"><%= String.format("%.2f", bill.getTreatmentCharges()) %></td></tr>
                        <% } %>
                        <% if (!labTests.isEmpty()) {
                            for (LabTest lt : labTests) { %>
                        <tr>
                            <td>Lab Test: <%= lt.getTestName() %>
                                <span style="color:#7f8c8d;font-size:0.82rem;">(Test Date: <%= lt.getTestDate() %>)</span>
                            </td>
                            <td style="text-align:right;"><%= String.format("%.2f", lt.getCost()) %></td>
                        </tr>
                        <% } } else if (bill.getLabCharges() > 0) { %>
                        <tr><td>Lab Charges</td><td style="text-align:right;"><%= String.format("%.2f", bill.getLabCharges()) %></td></tr>
                        <% } %>
                        <% if (bill.getOtherCharges() > 0) { %>
                        <tr><td>Other Charges</td><td style="text-align:right;"><%= String.format("%.2f", bill.getOtherCharges()) %></td></tr>
                        <% } %>
                    </tbody>
                    <tfoot>
                        <tr class="table-footer">
                            <td><strong>Daily Total</strong></td>
                            <td style="text-align:right;"><strong>&#8377;<%= String.format("%.2f", bill.getTotalAmount()) %></strong></td>
                        </tr>
                    </tfoot>
                </table>
                </div>
            </div>
        </div>
        <% } } %>
    </div><%-- end #printSection --%>
</div>
</body>
</html>
