<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="sidebar" style="height:100vh; overflow-y:auto;">
    <ul>
        <li><a href="adminDashboard.jsp">Dashboard</a></li>
        <li><a href="addPatient.jsp">Add Patient</a></li>
        <li><a href="addInsurance.jsp">Add Insurance</a></li>
        <li><a href="addTreatment.jsp">Add Treatment</a></li>
        <li><a href="generateBill.jsp">Generate Bill</a></li>
        <li><a href="labTests.jsp">Lab Tests</a></li>
        <li><a href="PharmacyServlet">Pharmacy</a></li>

        <li class="sep"></li>

        <li><a href="dailyBills.jsp">Daily Bills</a></li>
        <li><a href="consolidatedBills.jsp">Consolidated Bills</a></li>
        <li><a href="ClaimServlet">Approve Insurance Claims</a></li>
        <li><a href="searchPatient.jsp">Search Patient</a></li>

        <li class="sep"></li>

        <li><a href="LogoutServlet" class="logout">Logout</a></li>
    </ul>
</div>