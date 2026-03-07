package com.primecare.dao;

import com.primecare.model.DailyBill;
import com.primecare.model.FinalBill;
import com.primecare.model.Treatment;
import com.primecare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillingDAO {

    public boolean addDailyBill(DailyBill bill) {
        String sql = "INSERT INTO daily_bills (patient_id, treatment_date, doctor_fee, pharmacy_fee, room_charges, lab_charges, other_charges, treatment_charges, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bill.getPatientId());
            ps.setDate(2, bill.getTreatmentDate());
            ps.setDouble(3, bill.getDoctorFee());
            ps.setDouble(4, bill.getPharmacyFee());
            ps.setDouble(5, bill.getRoomCharges());
            ps.setDouble(6, bill.getLabCharges());
            ps.setDouble(7, bill.getOtherCharges());
            ps.setDouble(8, bill.getTreatmentCharges());
            ps.setDouble(9, bill.getTotalAmount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addTreatment(Treatment treatment) {
        String sql = "INSERT INTO treatments (patient_id, treatment_name, treatment_cost, treatment_date) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, treatment.getPatientId());
            ps.setString(2, treatment.getTreatmentName());
            ps.setDouble(3, treatment.getTreatmentCost());
            ps.setDate(4, treatment.getTreatmentDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Treatment> getTreatmentsByPatient(String patientId) {
        List<Treatment> treatments = new ArrayList<>();
        String sql = "SELECT * FROM treatments WHERE patient_id = ? ORDER BY treatment_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Treatment t = new Treatment();
                t.setTreatmentId(rs.getInt("treatment_id"));
                t.setPatientId(rs.getString("patient_id"));
                t.setTreatmentName(rs.getString("treatment_name"));
                t.setTreatmentCost(rs.getDouble("treatment_cost"));
                t.setTreatmentDate(rs.getDate("treatment_date"));
                treatments.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return treatments;
    }

    public double getTreatmentCostForDate(String patientId, Date treatmentDate) {
        String sql = "SELECT COALESCE(SUM(treatment_cost), 0) FROM treatments WHERE patient_id = ? AND treatment_date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ps.setDate(2, treatmentDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<DailyBill> getDailyBillsByPatient(String patientId) {
        List<DailyBill> bills = new ArrayList<>();
        String sql = "SELECT * FROM daily_bills WHERE patient_id = ? ORDER BY treatment_date";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bills.add(mapDailyBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    public List<DailyBill> getAllDailyBills() {
        List<DailyBill> bills = new ArrayList<>();
        String sql = "SELECT db.*, p.patient_name FROM daily_bills db JOIN patients p ON db.patient_id = p.patient_id ORDER BY db.treatment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bills.add(mapDailyBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    public FinalBill generateFinalBill(String patientId) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM daily_bills WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double total = rs.getDouble(1);
                FinalBill fb = new FinalBill();
                fb.setPatientId(patientId);
                fb.setTotalBeforeInsurance(total);
                fb.setInsuranceClaim(0);
                fb.setPatientPayable(total);
                return fb;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int saveFinalBill(FinalBill fb) {
        String sql = "INSERT INTO final_bills (patient_id, total_before_insurance, insurance_claim, patient_payable) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fb.getPatientId());
            ps.setDouble(2, fb.getTotalBeforeInsurance());
            ps.setDouble(3, fb.getInsuranceClaim());
            ps.setDouble(4, fb.getPatientPayable());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public FinalBill getLatestFinalBillByPatient(String patientId) {
        String sql = "SELECT * FROM final_bills WHERE patient_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapFinalBill(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateFinalBillInsurance(int billId, double insuranceClaim, double patientPayable) {
        String sql = "UPDATE final_bills SET insurance_claim = ?, patient_payable = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, insuranceClaim);
            ps.setDouble(2, patientPayable);
            ps.setInt(3, billId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private DailyBill mapDailyBill(ResultSet rs) throws SQLException {
        DailyBill b = new DailyBill();
        b.setBillId(rs.getInt("bill_id"));
        b.setPatientId(rs.getString("patient_id"));
        b.setTreatmentDate(rs.getDate("treatment_date"));
        b.setDoctorFee(rs.getDouble("doctor_fee"));
        b.setPharmacyFee(rs.getDouble("pharmacy_fee"));
        b.setRoomCharges(rs.getDouble("room_charges"));
        b.setLabCharges(rs.getDouble("lab_charges"));
        b.setOtherCharges(rs.getDouble("other_charges"));
        b.setTreatmentCharges(rs.getDouble("treatment_charges"));
        b.setTotalAmount(rs.getDouble("total_amount"));
        return b;
    }

    private FinalBill mapFinalBill(ResultSet rs) throws SQLException {
        FinalBill fb = new FinalBill();
        fb.setId(rs.getInt("id"));
        fb.setPatientId(rs.getString("patient_id"));
        fb.setTotalBeforeInsurance(rs.getDouble("total_before_insurance"));
        fb.setInsuranceClaim(rs.getDouble("insurance_claim"));
        fb.setPatientPayable(rs.getDouble("patient_payable"));
        fb.setCreatedAt(rs.getTimestamp("created_at"));
        return fb;
    }
}
