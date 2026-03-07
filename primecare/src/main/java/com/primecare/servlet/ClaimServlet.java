package com.primecare.servlet;

import com.primecare.dao.*;
import com.primecare.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ClaimServlet")
public class ClaimServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("generateClaim".equals(action)) {
            handleGenerateClaim(request, response);
        } else if ("approve".equals(action) || "reject".equals(action)) {
            handleClaimDecision(request, response, action);
        }
    }

    private void handleGenerateClaim(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientId = request.getParameter("patientId").trim();

        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientById(patientId);
        if (patient == null) {
            request.setAttribute("error", "Patient not found.");
            loadApprovalPage(request, response);
            return;
        }

        InsuranceDAO insDAO = new InsuranceDAO();
        Insurance ins = insDAO.getInsuranceByPatientId(patientId);
        if (ins == null) {
            request.setAttribute("error", "No insurance found for this patient.");
            loadApprovalPage(request, response);
            return;
        }

        BillingDAO billingDAO = new BillingDAO();
        FinalBill fb = billingDAO.generateFinalBill(patientId);
        if (fb == null || fb.getTotalBeforeInsurance() == 0) {
            request.setAttribute("error", "No bills found for this patient.");
            loadApprovalPage(request, response);
            return;
        }

        // Insurance claim formula
        double totalBill = fb.getTotalBeforeInsurance();
        double rawClaim = (ins.getCoveragePercentage() / 100.0) * totalBill;
        double insuranceClaim = Math.min(rawClaim, ins.getMaxCoverageAmount());

        // Enforce usage limit
        if (insuranceClaim > ins.getCoverageUsageLimit()) {
            request.setAttribute("error", "Insurance claim exceeds coverage usage limit. Claim cannot be processed.");
            loadApprovalPage(request, response);
            return;
        }

        double patientPayable = totalBill - insuranceClaim;
        fb.setInsuranceClaim(insuranceClaim);
        fb.setPatientPayable(patientPayable);

        int billId = billingDAO.saveFinalBill(fb);

        Claim claim = new Claim();
        claim.setPatientId(patientId);
        claim.setFinalBillId(billId);
        claim.setInsuranceId(ins.getId());
        claim.setClaimAmount(insuranceClaim);
        claim.setStatus("PENDING");

        ClaimDAO claimDAO = new ClaimDAO();
        claimDAO.addClaim(claim);

        request.setAttribute("success", "Insurance claim generated. Claim Amount: ₹" + String.format("%.2f", insuranceClaim) + ". Patient Payable: ₹" + String.format("%.2f", patientPayable));
        loadApprovalPage(request, response);
    }

    private void handleClaimDecision(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        int claimId = Integer.parseInt(request.getParameter("claimId"));
        String rejectionReason = request.getParameter("rejectionReason");
        String status = "approve".equals(action) ? "APPROVED" : "REJECTED";

        ClaimDAO claimDAO = new ClaimDAO();
        if (claimDAO.updateClaimStatus(claimId, status, rejectionReason)) {
            request.setAttribute("success", "Claim " + status.toLowerCase() + " successfully.");
        } else {
            request.setAttribute("error", "Failed to update claim status.");
        }
        loadApprovalPage(request, response);
    }

    private void loadApprovalPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ClaimDAO claimDAO = new ClaimDAO();
        request.setAttribute("allClaims", claimDAO.getAllClaims());
        request.getRequestDispatcher("approveInsurance.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        loadApprovalPage(request, response);
    }
}
