package com.primecare.servlet;

import com.primecare.dao.PatientDAO;
import com.primecare.dao.PharmacyDAO;
import com.primecare.model.Patient;
import com.primecare.model.Pharmacy;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.sql.Date;

/**
 * Handles pharmacy record creation with optional prescription file upload.
 * Uses @MultipartConfig to support multipart/form-data submissions.
 */
@WebServlet("/PharmacyServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB — spool to disk threshold
    maxFileSize       = 10 * 1024 * 1024, // 10 MB per file
    maxRequestSize    = 15 * 1024 * 1024  // 15 MB total request
)
public class PharmacyServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/prescriptions";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String patientId      = request.getParameter("patientId").trim();
        String dateStr        = request.getParameter("date");
        String chargesStr     = request.getParameter("pharmacyCharges");

        // ── Validate patient ──────────────────────────────────────────────────
        PatientDAO patientDAO = new PatientDAO();
        Patient patient = patientDAO.getPatientById(patientId);
        if (patient == null) {
            request.setAttribute("error", "Patient ID not found. Please register the patient first.");
            forwardToPharmacy(request, response);
            return;
        }

        double pharmacyCharges;
        try {
            pharmacyCharges = Double.parseDouble(chargesStr);
            if (pharmacyCharges <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter a valid pharmacy charge amount greater than 0.");
            forwardToPharmacy(request, response);
            return;
        }

        // ── Handle optional file upload ───────────────────────────────────────
        String savedFilePath = null;
        Part filePart = request.getPart("prescription");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);
            if (fileName != null && !fileName.isEmpty()) {
                String extension = getExtension(fileName).toLowerCase();
                if (!extension.equals("pdf") && !extension.equals("jpg")
                        && !extension.equals("jpeg") && !extension.equals("png")) {
                    request.setAttribute("error", "Invalid file type. Only PDF, JPG, and PNG files are accepted.");
                    forwardToPharmacy(request, response);
                    return;
                }

                // Build absolute path inside webapp/uploads/prescriptions/
                String appPath   = getServletContext().getRealPath("");
                String uploadPath = appPath + File.separator + UPLOAD_DIR;
                Files.createDirectories(Paths.get(uploadPath));

                // Unique filename: patientId_timestamp_originalName
                String uniqueName = patientId + "_" + System.currentTimeMillis() + "_" + sanitize(fileName);
                String fullPath   = uploadPath + File.separator + uniqueName;
                filePart.write(fullPath);
                savedFilePath = UPLOAD_DIR + "/" + uniqueName;
            }
        }

        // ── Persist record and sync daily_bill ────────────────────────────────
        Pharmacy record = new Pharmacy();
        record.setPatientId(patientId);
        record.setDate(Date.valueOf(dateStr));
        record.setPharmacyCharges(pharmacyCharges);
        record.setPrescriptionPath(savedFilePath);

        PharmacyDAO dao = new PharmacyDAO();
        int result = dao.addPharmacyRecord(record);

        if (result > 0) {
            request.setAttribute("success",
                "Pharmacy record saved for " + patient.getPatientName() +
                ". ₹" + String.format("%.2f", pharmacyCharges) +
                " has been added to the daily bill for " + dateStr + ".");
        } else {
            request.setAttribute("error", "Failed to save pharmacy record. Please try again.");
        }
        forwardToPharmacy(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession().getAttribute("adminUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        forwardToPharmacy(request, response);
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void forwardToPharmacy(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        PharmacyDAO dao = new PharmacyDAO();
        req.setAttribute("pharmacyRecords", dao.getAllRecords());
        req.getRequestDispatcher("pharmacy.jsp").forward(req, resp);
    }

    private String extractFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                String raw = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // Handle both Unix and Windows path separators
                int lastSlash = Math.max(raw.lastIndexOf('/'), raw.lastIndexOf('\\'));
                return lastSlash >= 0 ? raw.substring(lastSlash + 1) : raw;
            }
        }
        return null;
    }

    private String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return dot >= 0 ? fileName.substring(dot + 1) : "";
    }

    /** Remove characters that are unsafe for file-system names. */
    private String sanitize(String fileName) {
        return fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
    }
}
