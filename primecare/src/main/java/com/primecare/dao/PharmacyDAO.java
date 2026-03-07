package com.primecare.dao;

import com.primecare.model.Pharmacy;
import com.primecare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for pharmacy_records table.
 * Also handles auto-updating pharmacy_fee and total_amount in daily_bills.
 */
public class PharmacyDAO {

    /**
     * Saves a pharmacy record and auto-updates the matching daily_bill row.
     * If a daily_bill exists for (patient_id, date), its pharmacy_fee and total_amount
     * are incremented. If no daily_bill row exists for that date, one is created.
     *
     * @return the generated id, or -1 on failure
     */
    public int addPharmacyRecord(Pharmacy record) {
        String insertSql = "INSERT INTO pharmacy_records (patient_id, date, pharmacy_charges, prescription_path) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Insert pharmacy record
                int generatedId;
                try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, record.getPatientId());
                    ps.setDate(2, record.getDate());
                    ps.setDouble(3, record.getPharmacyCharges());
                    ps.setString(4, record.getPrescriptionPath());
                    ps.executeUpdate();
                    ResultSet keys = ps.getGeneratedKeys();
                    generatedId = keys.next() ? keys.getInt(1) : -1;
                }

                // 2. Sync to daily_bills — update if exists, insert if not
                syncPharmacyToDailyBill(conn, record.getPatientId(), record.getDate(), record.getPharmacyCharges());

                conn.commit();
                return generatedId;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * If a daily_bill row exists for (patientId, date), increment its pharmacy_fee
     * and total_amount. Otherwise insert a new daily_bill row for that date.
     */
    private void syncPharmacyToDailyBill(Connection conn, String patientId, Date date, double charges) throws SQLException {
        String checkSql = "SELECT bill_id FROM daily_bills WHERE patient_id = ? AND treatment_date = ?";
        try (PreparedStatement check = conn.prepareStatement(checkSql)) {
            check.setString(1, patientId);
            check.setDate(2, date);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                // Row exists — increment pharmacy_fee and total_amount
                String updateSql = "UPDATE daily_bills SET pharmacy_fee = pharmacy_fee + ?, total_amount = total_amount + ? " +
                                   "WHERE patient_id = ? AND treatment_date = ?";
                try (PreparedStatement upd = conn.prepareStatement(updateSql)) {
                    upd.setDouble(1, charges);
                    upd.setDouble(2, charges);
                    upd.setString(3, patientId);
                    upd.setDate(4, date);
                    upd.executeUpdate();
                }
            } else {
                // No daily_bill for this date — create one
                String insertBill = "INSERT INTO daily_bills (patient_id, treatment_date, doctor_fee, pharmacy_fee, " +
                                    "room_charges, lab_charges, other_charges, treatment_charges, total_amount) " +
                                    "VALUES (?, ?, 0, ?, 0, 0, 0, 0, ?)";
                try (PreparedStatement ins = conn.prepareStatement(insertBill)) {
                    ins.setString(1, patientId);
                    ins.setDate(2, date);
                    ins.setDouble(3, charges);
                    ins.setDouble(4, charges);
                    ins.executeUpdate();
                }
            }
        }
    }

    public List<Pharmacy> getRecordsByPatient(String patientId) {
        List<Pharmacy> list = new ArrayList<>();
        String sql = "SELECT * FROM pharmacy_records WHERE patient_id = ? ORDER BY date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRecord(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Pharmacy> getAllRecords() {
        List<Pharmacy> list = new ArrayList<>();
        String sql = "SELECT * FROM pharmacy_records ORDER BY date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRecord(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Pharmacy mapRecord(ResultSet rs) throws SQLException {
        Pharmacy p = new Pharmacy();
        p.setId(rs.getInt("id"));
        p.setPatientId(rs.getString("patient_id"));
        p.setDate(rs.getDate("date"));
        p.setPharmacyCharges(rs.getDouble("pharmacy_charges"));
        p.setPrescriptionPath(rs.getString("prescription_path"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
