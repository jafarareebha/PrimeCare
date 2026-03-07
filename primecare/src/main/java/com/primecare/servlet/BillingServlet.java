package com.primecare.servlet;

import com.primecare.dao.BillingDAO;
import com.primecare.dao.PatientDAO;
import com.primecare.model.DailyBill;
import com.primecare.model.Patient;
import com.primecare.model.Treatment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("addTreatment".equals(action)) {
            handleAddTreatment(request, response);
        } else {
            handleGenerateBill(request, response);
        }
    }

    private void handleAddTreatment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientId = request.getParameter("patientId").trim();
        String treatmentName = request.getParameter("treatmentName").trim();
        double treatmentCost = Double.parseDouble(request.getParameter("treatmentCost"));
        Date treatmentDate = Date.valueOf(request.getParameter("treatmentDate"));

        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientById(patientId);
        if (patient == null) {
            request.setAttribute("error", "Patient ID not found.");
            request.getRequestDispatcher("addTreatment.jsp").forward(request, response);
            return;
        }

        Treatment treatment = new Treatment();
        treatment.setPatientId(patientId);
        treatment.setTreatmentName(treatmentName);
        treatment.setTreatmentCost(treatmentCost);
        treatment.setTreatmentDate(treatmentDate);

        BillingDAO dao = new BillingDAO();
        if (dao.addTreatment(treatment)) {
            request.setAttribute("success", "Treatment record saved successfully.");
        } else {
            request.setAttribute("error", "Failed to save treatment record.");
        }
        request.getRequestDispatcher("addTreatment.jsp").forward(request, response);
    }

    private void handleGenerateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientId = request.getParameter("patientId").trim();
        double doctorFee = parseDouble(request.getParameter("doctorFee"));
        double pharmacyFee = parseDouble(request.getParameter("pharmacyFee"));
        double roomCharges = parseDouble(request.getParameter("roomCharges"));
        double otherCharges = parseDouble(request.getParameter("otherCharges"));
        double labCharges = parseDouble(request.getParameter("labCharges"));
        Date treatmentDate = Date.valueOf(request.getParameter("treatmentDate"));

        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientById(patientId);
        if (patient == null) {
            request.setAttribute("error", "Patient ID not found.");
            request.getRequestDispatcher("generateBill.jsp").forward(request, response);
            return;
        }

        BillingDAO billingDAO = new BillingDAO();
        double treatmentCharges = billingDAO.getTreatmentCostForDate(patientId, treatmentDate);

        double total = doctorFee + pharmacyFee + roomCharges + labCharges + otherCharges + treatmentCharges;

        DailyBill bill = new DailyBill();
        bill.setPatientId(patientId);
        bill.setTreatmentDate(treatmentDate);
        bill.setDoctorFee(doctorFee);
        bill.setPharmacyFee(pharmacyFee);
        bill.setRoomCharges(roomCharges);
        bill.setLabCharges(labCharges);
        bill.setOtherCharges(otherCharges);
        bill.setTreatmentCharges(treatmentCharges);
        bill.setTotalAmount(total);

        if (billingDAO.addDailyBill(bill)) {
            request.setAttribute("success", "Bill generated successfully for " + patient.getPatientName() + ". Total: ₹" + String.format("%.2f", total));
        } else {
            request.setAttribute("error", "Failed to generate bill.");
        }
        request.getRequestDispatcher("generateBill.jsp").forward(request, response);
    }

    private double parseDouble(String val) {
        try {
            return (val != null && !val.isEmpty()) ? Double.parseDouble(val) : 0.0;
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
