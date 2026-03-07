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
    InsuranceDAO insDAO = new InsuranceDAO();
    PaymentDAO payDAO = new PaymentDAO();
    ClaimDAO claimDAO = new ClaimDAO();

    List<DailyBill> dailyBills = billingDAO.getDailyBillsByPatient(patientId);
    FinalBill finalBill = billingDAO.getLatestFinalBillByPatient(patientId);
    Insurance insurance = insDAO.getInsuranceByPatientId(patientId);
    List<Payment> payments = payDAO.getPaymentsByPatient(patientId);
    double totalPaid = payDAO.getTotalPaidByPatient(patientId);
    Claim latestClaim = claimDAO.getClaimByPatient(patientId);

    double totalDoctor = 0, totalPharmacy = 0, totalRoom = 0, totalLab = 0, totalOther = 0, totalTreatment = 0, grandTotal = 0;
    for (DailyBill b : dailyBills) {
        totalDoctor    += b.getDoctorFee();
        totalPharmacy  += b.getPharmacyFee();
        totalRoom      += b.getRoomCharges();
        totalLab       += b.getLabCharges();
        totalOther     += b.getOtherCharges();
        totalTreatment += b.getTreatmentCharges();
        grandTotal     += b.getTotalAmount();
    }
    double insuranceClaim = (finalBill != null) ? finalBill.getInsuranceClaim() : 0;
    double patientPayable = (finalBill != null) ? finalBill.getPatientPayable() : grandTotal;
    double remaining      = patientPayable - totalPaid;

    // Auto-trigger print dialog if redirected from the "Print Consolidated Bill" button
    boolean autoPrint = "1".equals(request.getParameter("print"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Consolidated Bill - PrimeCare</title>
    <link rel="stylesheet" href="css/style.css">
    <style>

        .print-bar {
            display:flex;
            gap:12px;
            margin-bottom:20px;
        }

        .btn-print{
            padding:10px 22px;
            background:#1a5276;
            color:white;
            border:none;
            border-radius:6px;
            cursor:pointer;
            font-size:0.93rem;
            font-weight:600;
        }

        .btn-print:hover{
            background:#154360;
        }


        /* ================= PRINT STYLES ================= */

        @media print{

            body *{
                visibility:hidden;
            }

            #printSection,
            #printSection *{
                visibility:visible;
            }

            #printSection{
                position:absolute;
                left:0;
                top:0;
                width:100%;
            }

            .header,
            .portal-nav,
            .print-bar,
            .patient-info-box{
                display:none !important;
            }

            body{
                margin:0;
                font-family:Arial,sans-serif;
                color:#000;
            }

            /* PRINT HEADER */

            .print-header{
                display:block !important;
                text-align:center;
                margin-bottom:16px;
                border-bottom:2px solid #1a5276;
                padding-bottom:10px;
            }

            .print-header h1{
                font-size:1.7rem;
                color:#1a5276;
                margin:0;
            }

            .print-header p{
                margin:2px 0;
                font-size:0.88rem;
                color:#555;
            }

            table{
                width:100%;
                border-collapse:collapse;
                margin-bottom:14px;
            }

            thead th{
                background:#1a5276 !important;
                color:white !important;
                padding:7px 10px;
                text-align:left;
                font-size:0.82rem;
            }

            tbody td{
                padding:6px 10px;
                border-bottom:1px solid #ddd;
                font-size:0.85rem;
            }

            tfoot td{
                padding:7px 10px;
                background:#eaf4fb !important;
                font-weight:700;
            }

            .card{
                box-shadow:none !important;
                border:1px solid #ddd;
                margin-bottom:12px;
            }

            .summary-row{
                display:flex;
                justify-content:space-between;
                padding:6px 0;
                border-bottom:1px solid #eee;
                font-size:0.9rem;
            }

            .summary-row.total{
                font-weight:700;
                font-size:1rem;
                border-top:2px solid #aed6f1;
                border-bottom:none;
                padding-top:10px;
            }

            .summary-row.discount{
                color:#27ae60;
                font-weight:600;
            }

            /* PRINT PAYABLE SECTION */

            .total-payable{
                display:none !important;
            }

            .total-payable-print{
                display:block !important;
                background:#1a5276 !important;
                color:white !important;
                padding:14px 20px;
                border-radius:8px;
                text-align:center;
                margin:14px 0;
            }

            .total-payable-print .tp-label{
                font-size:0.9rem;
                opacity:0.85;
            }

            .total-payable-print .tp-amount{
                font-size:2rem;
                font-weight:700;
            }

        }

    </style>
</head>
<body>
<%-- ══ SCREEN HEADER ══ --%>
<div class="header">
    <div class="logo">Prime<span>Care</span></div>
    <div class="header-right">
        <%= patientName %> &nbsp;|&nbsp;
        <a href="patientLogout.jsp" style="color:#aed6f1;">Logout</a>
    </div>
</div>

<div style="margin-top:64px;padding:32px 40px;">
    <div class="page-title">My Consolidated Bill</div>

    <div class="portal-nav">
        <a href="viewDetailedBill.jsp">Detailed Bill (Day-wise)</a>
        <a href="viewConsolidatedBill.jsp" class="active">Consolidated Bill</a>
    </div>

    <div class="print-bar">
        <button class="btn-print" onclick="window.location='viewDetailedBill.jsp'">
            &#8592; Back to Detailed Bill
        </button>
        <button class="btn-print" onclick="window.print()" style="background:#27ae60;">
            &#128438; Print Consolidated Bill
        </button>
    </div>

    <% if (patient != null) { %>
    <div class="patient-info-box">
        <h3>Patient Information</h3>
        <div class="patient-info-grid">
            <div class="patient-info-item"><div class="label">Patient ID</div><div class="value"><%= patient.getPatientId() %></div></div>
            <div class="patient-info-item"><div class="label">Name</div><div class="value"><%= patient.getPatientName() %></div></div>
            <div class="patient-info-item"><div class="label">Age</div><div class="value"><%= patient.getAge() %> years</div></div>
            <div class="patient-info-item"><div class="label">Contact</div><div class="value"><%= patient.getContactNumber() %></div></div>
        </div>
    </div>
    <% } %>

    <%-- ══ PRINTABLE SECTION ══ --%>
    <div id="printSection">

        <%-- Print-only header --%>
        <div class="print-header">
            <h1>PrimeCare</h1>
            <p>Hospital Billing &amp; Insurance Management System</p>
            <p><strong>Consolidated Bill</strong></p>
            <% if (patient != null) { %>
            <p style="margin-top:8px;font-size:0.9rem;">
                Patient: <strong><%= patient.getPatientName() %></strong> &nbsp;|&nbsp;
                ID: <strong><%= patient.getPatientId() %></strong> &nbsp;|&nbsp;
                Age: <%= patient.getAge() %> / <%= patient.getGender() %> &nbsp;|&nbsp;
                Contact: <%= patient.getContactNumber() %>
            </p>
            <% } %>
        </div>

        <%-- Bill summary --%>
        <div style="display:grid;grid-template-columns:1.2fr 1fr;gap:24px;">
            <div class="card">
                <div class="card-title">Bill Summary</div>
                <div class="summary-row"><span>Total Doctor Fees</span><span>&#8377;<%= String.format("%.2f", totalDoctor) %></span></div>
                <div class="summary-row"><span>Total Pharmacy Charges</span><span>&#8377;<%= String.format("%.2f", totalPharmacy) %></span></div>
                <div class="summary-row"><span>Total Room Charges</span><span>&#8377;<%= String.format("%.2f", totalRoom) %></span></div>
                <div class="summary-row"><span>Total Lab Charges</span><span>&#8377;<%= String.format("%.2f", totalLab) %></span></div>
                <div class="summary-row"><span>Total Treatment Charges</span><span>&#8377;<%= String.format("%.2f", totalTreatment) %></span></div>
                <div class="summary-row"><span>Other Charges</span><span>&#8377;<%= String.format("%.2f", totalOther) %></span></div>
                <div class="summary-row total"><span>Total Before Insurance</span><span>&#8377;<%= String.format("%.2f", grandTotal) %></span></div>

                <% if (insurance != null) { %>
                <hr class="section-divider">
                <div class="summary-row"><span>Insurance Provider</span><span><%= insurance.getInsuranceProvider() %></span></div>
                <div class="summary-row"><span>Policy Number</span><span><%= insurance.getPolicyNumber() %></span></div>
                <div class="summary-row"><span>Coverage Percentage</span><span><%= String.format("%.0f", insurance.getCoveragePercentage()) %>%</span></div>
                <div class="summary-row discount"><span>Insurance Claimed Amount</span><span>&#8722; &#8377;<%= String.format("%.2f", insuranceClaim) %></span></div>
                <% if (latestClaim != null) { %>
                <div class="summary-row">
                    <span>Claim Status</span>
                    <span><span class="badge badge-<%= latestClaim.getStatus().toLowerCase() %>"><%= latestClaim.getStatus() %></span></span>
                </div>
                <% } %>
                <% } %>
            </div>

            <div>
                <div class="total-payable" style="margin-bottom:16px;">
                    <div class="label">Patient Payable Amount</div>
                    <div class="amount">&#8377;<%= String.format("%.2f", patientPayable) %></div>
                </div>
                <%-- Print version of payable (different style for @media print) --%>
                <div class="total-payable-print">
                    <div class="tp-label">Patient Payable Amount</div>
                    <div class="tp-amount">&#8377;<%= String.format("%.2f", patientPayable) %></div>
                </div>

                <div class="card">
                    <div class="summary-row">
                        <span>Total Paid</span>
                        <span style="color:#27ae60;font-weight:700;">&#8377;<%= String.format("%.2f", totalPaid) %></span>
                    </div>
                    <div class="summary-row total">
                        <span>Remaining Balance</span>
                        <span style="color:<%= remaining > 0 ? "#e74c3c" : "#27ae60" %>;font-weight:700;">
                            &#8377;<%= String.format("%.2f", remaining) %>
                        </span>
                    </div>
                    <% if (remaining <= 0) { %>
                    <div class="alert alert-success" style="margin-top:14px;text-align:center;">Payment Complete</div>
                    <% } %>
                </div>
            </div>
        </div>

        <%-- Payment History --%>
        <div class="card" style="margin-top:24px;">
            <div class="card-title">Payment History</div>
            <% if (payments.isEmpty()) { %>
                <p style="text-align:center;color:#7f8c8d;padding:20px;">No payments recorded yet.</p>
            <% } else { %>
            <div class="table-wrapper">
            <table>
                <thead>
                    <tr><th>Payment ID</th><th>Date</th><th>Amount Paid</th><th>Notes</th></tr>
                </thead>
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
                        <td style="color:#27ae60;font-weight:700;">&#8377;<%= String.format("%.2f", totalPaid) %></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
            </div>
            <% } %>
        </div>
    </div><%-- end #printSection --%>
</div>

<% if (autoPrint) { %>
<script>
window.addEventListener('load', function() { window.print(); });
</script>
<% } %>
</body>
</html>
