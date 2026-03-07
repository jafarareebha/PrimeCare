package com.primecare.servlet;

import com.primecare.dao.AdminDAO;
import com.primecare.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AdminSignupServlet")
public class AdminSignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("adminSignup.jsp").forward(request, response);
            return;
        }

        AdminDAO dao = new AdminDAO();
        if (dao.usernameExists(username)) {
            request.setAttribute("error", "Username already exists.");
            request.getRequestDispatcher("adminSignup.jsp").forward(request, response);
            return;
        }

        Admin admin = new Admin();
        admin.setUsername(username);
        admin.setPassword(password);

        if (dao.registerAdmin(admin)) {
            request.setAttribute("success", "Account created successfully. Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("adminSignup.jsp").forward(request, response);
        }
    }
}
