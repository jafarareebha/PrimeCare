package com.primecare.servlet;

import com.primecare.dao.PatientDAO;
import com.primecare.model.Patient;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddPatientServlet")
public class AddPatientServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String patientId = request.getParameter("patientId").trim();
        String patientName = request.getParameter("patientName").trim();
        int age = Integer.parseInt(request.getParameter("age"));
        String gender = request.getParameter("gender");
        String contactNumber = request.getParameter("contactNumber").trim();

        Patient patient = new Patient(patientId, patientName, age, gender, contactNumber);
        PatientDAO dao = new PatientDAO();

        if (dao.addPatient(patient)) {
            request.setAttribute("success", "Patient " + patientName + " added successfully.");
        } else {
            request.setAttribute("error", "Failed to add patient. Patient ID may already exist.");
        }
        request.getRequestDispatcher("addPatient.jsp").forward(request, response);
    }
}
