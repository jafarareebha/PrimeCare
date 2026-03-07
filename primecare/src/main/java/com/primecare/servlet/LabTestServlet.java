package com.primecare.servlet;

import com.primecare.dao.LabTestDAO;
import com.primecare.dao.PatientDAO;
import com.primecare.model.LabTest;
import com.primecare.model.Patient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/LabTestServlet")
public class LabTestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String patientId = request.getParameter("patientId").trim();
        String testDate = request.getParameter("testDate");
        String[] testNames = request.getParameterValues("testName");
        String[] testCosts = request.getParameterValues("testCost");

        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientById(patientId);
        if (patient == null) {
            request.setAttribute("error", "Patient ID not found.");
            request.getRequestDispatcher("labTests.jsp").forward(request, response);
            return;
        }

        LabTestDAO dao = new LabTestDAO();
        int saved = 0;
        if (testNames != null) {
            for (int i = 0; i < testNames.length; i++) {
                String name = testNames[i];
                double cost = 0;
                try { cost = Double.parseDouble(testCosts[i]); } catch (Exception ignored) {}

                if (name != null && !name.trim().isEmpty()) {
                    LabTest test = new LabTest();
                    test.setPatientId(patientId);
                    test.setTestName(name.trim());
                    test.setCost(cost);
                    test.setTestDate(Date.valueOf(testDate));
                    if (dao.addLabTest(test)) saved++;
                }
            }
        }

        if (saved > 0) {
            request.setAttribute("success", saved + " lab test(s) saved for " + patient.getPatientName() + ".");
        } else {
            request.setAttribute("error", "No lab tests were saved. Please add at least one test.");
        }
        request.getRequestDispatcher("labTests.jsp").forward(request, response);
    }
}
