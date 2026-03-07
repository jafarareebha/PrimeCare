package com.primecare.servlet;

import com.primecare.dao.*;
import com.primecare.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String patientId = request.getParameter("patientId").trim();
        double amountPaid = Double.parseDouble(request.getParameter("amountPaid"));
        String paymentDate = request.getParameter("paymentDate");
        String notes = request.getParameter("notes");

        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientById(patientId);
        if (patient == null) {
            request.setAttribute("error", "Patient not found.");
            request.getRequestDispatcher("searchPatient.jsp").forward(request, response);
            return;
        }

        BillingDAO billingDAO = new BillingDAO();
        FinalBill fb = billingDAO.getLatestFinalBillByPatient(patientId);

        Payment payment = new Payment();
        payment.setPatientId(patientId);
        payment.setBillId(fb != null ? fb.getId() : 0);
        payment.setAmountPaid(amountPaid);
        payment.setPaymentDate(Date.valueOf(paymentDate));
        payment.setNotes(notes);

        PaymentDAO dao = new PaymentDAO();
        if (dao.addPayment(payment)) {
            response.sendRedirect("PatientSearchServlet?query=" + patientId + "&success=Payment+recorded+successfully");
        } else {
            request.setAttribute("error", "Failed to record payment.");
            request.getRequestDispatcher("searchPatient.jsp").forward(request, response);
        }
    }
}
