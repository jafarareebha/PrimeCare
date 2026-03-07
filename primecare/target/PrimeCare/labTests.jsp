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
    <title>Lab Tests - PrimeCare</title>
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
        <div class="page-title">Lab Tests</div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="card">
            <div class="card-title">Add Lab Tests for Patient</div>
            <form action="LabTestServlet" method="post" id="labForm">
                <div class="form-row">
                    <div class="form-group">
                        <label>Patient ID</label>
                        <input type="text" name="patientId" placeholder="Enter Patient ID" required>
                    </div>
                    <div class="form-group">
                        <label>Test Date</label>
                        <input type="date" name="testDate" required>
                    </div>
                </div>

                <div id="testContainer">
                    <div class="lab-test-row" id="testRow0">
                        <div class="form-group" style="margin:0;">
                            <label>Select Test or Enter Custom</label>
                            <select onchange="fillCost(this, 0)" class="testSelect">
                                <option value="">-- Select Predefined Test --</option>
                                <option value="Blood Test|500">Blood Test</option>
                                <option value="Urine Test|300">Urine Test</option>
                                <option value="X-Ray|800">X-Ray</option>
                                <option value="MRI Scan|5000">MRI Scan</option>
                                <option value="CT Scan|3500">CT Scan</option>
                                <option value="ECG|700">ECG</option>
                                <option value="Ultrasound|1200">Ultrasound</option>
                                <option value="Thyroid Test|900">Thyroid Test</option>
                                <option value="Liver Function Test|1100">Liver Function Test</option>
                                <option value="Kidney Function Test|1000">Kidney Function Test</option>
                                <option value="COVID Test|600">COVID Test</option>
                                <option value="Cholesterol Test|750">Cholesterol Test</option>
                                <option value="custom">Custom Test</option>
                            </select>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label>Test Name</label>
                            <input type="text" name="testName" class="testName" placeholder="Test name" required>
                        </div>
                        <div class="form-group" style="margin:0;">
                            <label>Cost (&#8377;)</label>
                            <input type="number" name="testCost" class="testCost" placeholder="0.00" step="0.01" min="0" required>
                        </div>
                        <div style="padding-top:22px;">
                            <button type="button" onclick="removeTest(this)" class="btn btn-danger btn-sm">Remove</button>
                        </div>
                    </div>
                </div>

                <div style="margin:14px 0;">
                    <button type="button" onclick="addTest()" class="add-test-btn">+ Add Another Test</button>
                </div>

                <button type="submit" class="btn btn-primary">Save Lab Tests</button>
            </form>
        </div>
    </div>
</div>

<script>
let testCount = 1;

const predefined = {
    'Blood Test': 500, 'Urine Test': 300, 'X-Ray': 800, 'MRI Scan': 5000,
    'CT Scan': 3500, 'ECG': 700, 'Ultrasound': 1200, 'Thyroid Test': 900,
    'Liver Function Test': 1100, 'Kidney Function Test': 1000, 'COVID Test': 600,
    'Cholesterol Test': 750
};

function fillCost(sel, idx) {
    const val = sel.value;
    const row = sel.closest('.lab-test-row');
    const nameInput = row.querySelector('.testName');
    const costInput = row.querySelector('.testCost');
    if (val === 'custom' || val === '') {
        nameInput.value = '';
        costInput.value = '';
        nameInput.readOnly = false;
        costInput.readOnly = false;
    } else {
        const parts = val.split('|');
        nameInput.value = parts[0];
        costInput.value = parts[1];
        nameInput.readOnly = true;
        costInput.readOnly = false;
    }
}

function addTest() {
    const container = document.getElementById('testContainer');
    const div = document.createElement('div');
    div.className = 'lab-test-row';
    div.innerHTML = `
        <div class="form-group" style="margin:0;">
            <label>Select Test or Enter Custom</label>
            <select onchange="fillCost(this, ${testCount})" class="testSelect">
                <option value="">-- Select Predefined Test --</option>
                <option value="Blood Test|500">Blood Test</option>
                <option value="Urine Test|300">Urine Test</option>
                <option value="X-Ray|800">X-Ray</option>
                <option value="MRI Scan|5000">MRI Scan</option>
                <option value="CT Scan|3500">CT Scan</option>
                <option value="ECG|700">ECG</option>
                <option value="Ultrasound|1200">Ultrasound</option>
                <option value="Thyroid Test|900">Thyroid Test</option>
                <option value="Liver Function Test|1100">Liver Function Test</option>
                <option value="Kidney Function Test|1000">Kidney Function Test</option>
                <option value="COVID Test|600">COVID Test</option>
                <option value="Cholesterol Test|750">Cholesterol Test</option>
                <option value="custom">Custom Test</option>
            </select>
        </div>
        <div class="form-group" style="margin:0;">
            <label>Test Name</label>
            <input type="text" name="testName" class="testName" placeholder="Test name" required>
        </div>
        <div class="form-group" style="margin:0;">
            <label>Cost (&#8377;)</label>
            <input type="number" name="testCost" class="testCost" placeholder="0.00" step="0.01" min="0" required>
        </div>
        <div style="padding-top:22px;">
            <button type="button" onclick="removeTest(this)" class="btn btn-danger btn-sm">Remove</button>
        </div>`;
    container.appendChild(div);
    testCount++;
}

function removeTest(btn) {
    const rows = document.querySelectorAll('.lab-test-row');
    if (rows.length > 1) {
        btn.closest('.lab-test-row').remove();
    }
}
</script>
</body>
</html>
