package com.primecare.servlet;

import com.primecare.dao.*;
//import com.primecare.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
//import java.util.List;

@WebServlet("/PatientLoginServlet")
public class PatientLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientId = request.getParameter("patientId").trim();
        String patientName = request.getParameter("patientName").trim();

        PatientDAO dao = new PatientDAO();
        boolean valid = dao.patientExists(patientId, patientName);

        if (valid) {
            HttpSession session = request.getSession();
            session.setAttribute("patientId", patientId);
            session.setAttribute("patientName", patientName);
            response.sendRedirect("viewDetailedBill.jsp");
        } else {
            request.setAttribute("error", "Invalid Patient ID or Name. Please try again.");
            request.getRequestDispatcher("patientLogin.jsp").forward(request, response);
        }
    }
}
