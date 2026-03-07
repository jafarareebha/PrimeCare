package com.primecare.dao;

import com.primecare.model.Payment;
import com.primecare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO payments (patient_id, bill_id, amount_paid, payment_date, notes) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, payment.getPatientId());
            ps.setInt(2, payment.getBillId());
            ps.setDouble(3, payment.getAmountPaid());
            ps.setDate(4, payment.getPaymentDate());
            ps.setString(5, payment.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Payment> getPaymentsByPatient(String patientId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE patient_id = ? ORDER BY payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                payments.add(mapPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    public double getTotalPaidByPatient(String patientId) {
        String sql = "SELECT COALESCE(SUM(amount_paid), 0) FROM payments WHERE patient_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setPatientId(rs.getString("patient_id"));
        p.setBillId(rs.getInt("bill_id"));
        p.setAmountPaid(rs.getDouble("amount_paid"));
        p.setPaymentDate(rs.getDate("payment_date"));
        p.setNotes(rs.getString("notes"));
        return p;
    }
}
