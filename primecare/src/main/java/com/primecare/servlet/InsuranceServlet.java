package com.primecare.servlet;

import com.primecare.dao.InsuranceDAO;
import com.primecare.dao.PatientDAO;
import com.primecare.model.Insurance;
import com.primecare.model.Patient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/InsuranceServlet")
public class InsuranceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String patientId = request.getParameter("patientId").trim();
        String insuranceProvider = request.getParameter("insuranceProvider").trim();
        String policyNumber = request.getParameter("policyNumber").trim();
        double coveragePercentage = Double.parseDouble(request.getParameter("coveragePercentage"));
        double maxCoverageAmount = Double.parseDouble(request.getParameter("maxCoverageAmount"));
        double coverageUsageLimit = Double.parseDouble(request.getParameter("coverageUsageLimit"));

        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientById(patientId);

        if (patient == null) {
            request.setAttribute("error", "Patient ID not found. Please add the patient first.");
            request.getRequestDispatcher("addInsurance.jsp").forward(request, response);
            return;
        }

        Insurance ins = new Insurance();
        ins.setPatientId(patientId);
        ins.setInsuranceProvider(insuranceProvider);
        ins.setPolicyNumber(policyNumber);
        ins.setCoveragePercentage(coveragePercentage);
        ins.setMaxCoverageAmount(maxCoverageAmount);
        ins.setCoverageUsageLimit(coverageUsageLimit);

        InsuranceDAO dao = new InsuranceDAO();
        if (dao.addInsurance(ins)) {
            request.setAttribute("success", "Insurance record added successfully for patient " + patient.getPatientName() + ".");
        } else {
            request.setAttribute("error", "Failed to add insurance record.");
        }
        request.getRequestDispatcher("addInsurance.jsp").forward(request, response);
    }
}
