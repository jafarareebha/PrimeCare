package com.primecare.dao;

import com.primecare.model.LabTest;
import com.primecare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for lab_tests table.
 * addLabTest() now also auto-updates lab_charges and total_amount in daily_bills
 * for the same patient + date (Feature 2).
 */
public class LabTestDAO {

    /**
     * Saves a lab test and automatically increments lab_charges / total_amount
     * in the daily_bills row for the same (patient_id, test_date).
     * If no daily_bill row exists for that date, one is created.
     * Both operations run inside a single transaction.
     */
    public boolean addLabTest(LabTest test) {
        String insertSql = "INSERT INTO lab_tests (patient_id, test_name, cost, test_date) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    ps.setString(1, test.getPatientId());
                    ps.setString(2, test.getTestName());
                    ps.setDouble(3, test.getCost());
                    ps.setDate(4, test.getTestDate());
                    ps.executeUpdate();
                }
                syncLabToDailyBill(conn, test.getPatientId(), test.getTestDate(), test.getCost());
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void syncLabToDailyBill(Connection conn, String patientId, Date date, double cost) throws SQLException {
        String checkSql = "SELECT bill_id FROM daily_bills WHERE patient_id = ? AND treatment_date = ?";
        try (PreparedStatement check = conn.prepareStatement(checkSql)) {
            check.setString(1, patientId);
            check.setDate(2, date);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                String updateSql = "UPDATE daily_bills SET lab_charges = lab_charges + ?, total_amount = total_amount + ? " +
                                   "WHERE patient_id = ? AND treatment_date = ?";
                try (PreparedStatement upd = conn.prepareStatement(updateSql)) {
                    upd.setDouble(1, cost);
                    upd.setDouble(2, cost);
                    upd.setString(3, patientId);
                    upd.setDate(4, date);
                    upd.executeUpdate();
                }
            } else {
                String insertBill = "INSERT INTO daily_bills " +
                        "(patient_id, treatment_date, doctor_fee, pharmacy_fee, room_charges, " +
                        " lab_charges, other_charges, treatment_charges, total_amount) " +
                        "VALUES (?, ?, 0, 0, 0, ?, 0, 0, ?)";
                try (PreparedStatement ins = conn.prepareStatement(insertBill)) {
                    ins.setString(1, patientId);
                    ins.setDate(2, date);
                    ins.setDouble(3, cost);
                    ins.setDouble(4, cost);
                    ins.executeUpdate();
                }
            }
        }
    }

    public List<LabTest> getLabTestsByPatient(String patientId) {
        List<LabTest> tests = new ArrayList<>();
        String sql = "SELECT * FROM lab_tests WHERE patient_id = ? ORDER BY test_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { tests.add(mapLabTest(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return tests;
    }

    public double getTotalLabCostByPatient(String patientId) {
        String sql = "SELECT COALESCE(SUM(cost), 0) FROM lab_tests WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getLabCostByPatientAndDate(String patientId, Date testDate) {
        String sql = "SELECT COALESCE(SUM(cost), 0) FROM lab_tests WHERE patient_id = ? AND test_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ps.setDate(2, testDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<LabTest> getLabTestsByPatientAndDate(String patientId, Date testDate) {
        List<LabTest> tests = new ArrayList<>();
        String sql = "SELECT * FROM lab_tests WHERE patient_id = ? AND test_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ps.setDate(2, testDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) { tests.add(mapLabTest(rs)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return tests;
    }

    private LabTest mapLabTest(ResultSet rs) throws SQLException {
        LabTest t = new LabTest();
        t.setId(rs.getInt("id"));
        t.setPatientId(rs.getString("patient_id"));
        t.setTestName(rs.getString("test_name"));
        t.setCost(rs.getDouble("cost"));
        t.setTestDate(rs.getDate("test_date"));
        return t;
    }
}
