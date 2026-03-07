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
    <title>Generate Bill - PrimeCare</title>
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
        <div class="page-title">Generate Daily Bill</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="card">
            <div class="card-title">Bill Details</div>
            <form action="BillingServlet" method="post" id="billForm">
                <div class="form-row">
                    <div class="form-group">
                        <label>Patient ID</label>
                        <input type="text" name="patientId" id="patientId" placeholder="Enter Patient ID" required>
                    </div>
                    <div class="form-group">
                        <label>Treatment Date</label>
                        <input type="date" name="treatmentDate" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Doctor Fee (&#8377;)</label>
                        <input type="number" name="doctorFee" id="doctorFee" placeholder="0.00" step="0.01" min="0" value="0" onchange="calcTotal()">
                    </div>
                    <div class="form-group">
                        <label>Pharmacy Fee (&#8377;)</label>
                        <input type="number" name="pharmacyFee" id="pharmacyFee" placeholder="0.00" step="0.01" min="0" value="0" onchange="calcTotal()">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Room Charges (&#8377;)</label>
                        <input type="number" name="roomCharges" id="roomCharges" placeholder="0.00" step="0.01" min="0" value="0" onchange="calcTotal()">
                    </div>
                    <div class="form-group">
                        <label>Lab Charges (&#8377;)</label>
                        <input type="number" name="labCharges" id="labCharges" placeholder="0.00" step="0.01" min="0" value="0" onchange="calcTotal()">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Other Charges (&#8377;)</label>
                        <input type="number" name="otherCharges" id="otherCharges" placeholder="0.00" step="0.01" min="0" value="0" onchange="calcTotal()">
                    </div>
                    <div class="form-group">
                        <label>Estimated Total</label>
                        <input type="text" id="estTotal" value="&#8377; 0.00" readonly style="background:#eaf4fb;font-weight:700;color:#1a5276;">
                    </div>
                </div>
                <div class="alert alert-info" style="margin-bottom:18px;">
                    Treatment costs recorded for the selected date will be automatically included in the bill total.
                </div>
                <button type="submit" class="btn btn-success">Generate Bill</button>
            </form>
        </div>
    </div>
</div>
<script>
function calcTotal() {
    const fields = ['doctorFee','pharmacyFee','roomCharges','labCharges','otherCharges'];
    let total = 0;
    fields.forEach(id => {
        const val = parseFloat(document.getElementById(id).value) || 0;
        total += val;
    });
    document.getElementById('estTotal').value = '₹ ' + total.toFixed(2);
}
</script>
</body>
</html>
