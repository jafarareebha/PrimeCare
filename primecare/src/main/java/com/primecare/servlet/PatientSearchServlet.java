package com.primecare.servlet;

import com.primecare.dao.*;
import com.primecare.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/PatientSearchServlet")
public class PatientSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String query = request.getParameter("query");
        String success = request.getParameter("success");
        if (success != null) request.setAttribute("success", success);

        if (query != null && !query.trim().isEmpty()) {
            PatientDAO patientDAO = new PatientDAO();
            List<Patient> patients = patientDAO.searchPatients(query.trim());
            request.setAttribute("patients", patients);
            request.setAttribute("query", query);

            if (patients.size() == 1) {
                Patient p = patients.get(0);
                loadPatientData(request, p.getPatientId());
            }
        }

        request.getRequestDispatcher("searchPatient.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    public static void loadPatientData(HttpServletRequest request, String patientId) {
        BillingDAO billingDAO = new BillingDAO();
        LabTestDAO labTestDAO = new LabTestDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        InsuranceDAO insDAO = new InsuranceDAO();

        List<DailyBill> dailyBills = billingDAO.getDailyBillsByPatient(patientId);
        FinalBill finalBill = billingDAO.getLatestFinalBillByPatient(patientId);
        List<Payment> payments = paymentDAO.getPaymentsByPatient(patientId);
        double totalPaid = paymentDAO.getTotalPaidByPatient(patientId);
        Insurance insurance = insDAO.getInsuranceByPatientId(patientId);

        request.setAttribute("dailyBills", dailyBills);
        request.setAttribute("finalBill", finalBill);
        request.setAttribute("payments", payments);
        request.setAttribute("totalPaid", totalPaid);
        request.setAttribute("insurance", insurance);

        if (finalBill != null) {
            double remaining = finalBill.getPatientPayable() - totalPaid;
            request.setAttribute("remainingBalance", remaining);
        }
    }
}
