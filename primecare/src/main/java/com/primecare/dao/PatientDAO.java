package com.primecare.dao;

import com.primecare.model.Patient;
import com.primecare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    public boolean addPatient(Patient patient) {
        String sql = "INSERT INTO patients (patient_id, patient_name, age, gender, contact_number) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patient.getPatientId());
            ps.setString(2, patient.getPatientName());
            ps.setInt(3, patient.getAge());
            ps.setString(4, patient.getGender());
            ps.setString(5, patient.getContactNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Patient getPatientById(String patientId) {
        String sql = "SELECT * FROM patients WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapPatient(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Patient> searchPatients(String keyword) {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients WHERE patient_id LIKE ? OR patient_name LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                patients.add(mapPatient(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients ORDER BY patient_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                patients.add(mapPatient(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    private Patient mapPatient(ResultSet rs) throws SQLException {
        Patient p = new Patient();
        p.setPatientId(rs.getString("patient_id"));
        p.setPatientName(rs.getString("patient_name"));
        p.setAge(rs.getInt("age"));
        p.setGender(rs.getString("gender"));
        p.setContactNumber(rs.getString("contact_number"));
        return p;
    }

    public boolean patientExists(String patientId, String patientName) {
        String sql = "SELECT patient_id FROM patients WHERE patient_id = ? AND patient_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ps.setString(2, patientName);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
