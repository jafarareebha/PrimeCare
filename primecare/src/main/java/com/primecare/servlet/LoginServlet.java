package com.primecare.servlet;

import com.primecare.dao.AdminDAO;
import com.primecare.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password");

        AdminDAO dao = new AdminDAO();
        Admin admin = dao.login(username, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminUser", admin.getUsername());
            response.sendRedirect("adminDashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
