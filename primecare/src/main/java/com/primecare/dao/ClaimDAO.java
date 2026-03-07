package com.primecare.dao;

import com.primecare.model.Claim;
import com.primecare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClaimDAO {

    public int addClaim(Claim claim) {
        String sql = "INSERT INTO claims (patient_id, final_bill_id, insurance_id, claim_amount, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, claim.getPatientId());
            ps.setInt(2, claim.getFinalBillId());
            ps.setInt(3, claim.getInsuranceId());
            ps.setDouble(4, claim.getClaimAmount());
            ps.setString(5, claim.getStatus());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateClaimStatus(int claimId, String status, String rejectionReason) {
        String sql = "UPDATE claims SET status = ?, rejection_reason = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, rejectionReason);
            ps.setInt(3, claimId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Claim> getPendingClaims() {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT c.*, p.patient_name FROM claims c JOIN patients p ON c.patient_id = p.patient_id WHERE c.status = 'PENDING' ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                claims.add(mapClaim(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }

    public List<Claim> getAllClaims() {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT c.*, p.patient_name FROM claims c JOIN patients p ON c.patient_id = p.patient_id ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                claims.add(mapClaim(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }

    public Claim getClaimByPatient(String patientId) {
        String sql = "SELECT * FROM claims WHERE patient_id = ? ORDER BY created_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapClaim(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Claim mapClaim(ResultSet rs) throws SQLException {
        Claim c = new Claim();
        c.setId(rs.getInt("id"));
        c.setPatientId(rs.getString("patient_id"));
        c.setFinalBillId(rs.getInt("final_bill_id"));
        c.setInsuranceId(rs.getInt("insurance_id"));
        c.setClaimAmount(rs.getDouble("claim_amount"));
        c.setStatus(rs.getString("status"));
        c.setRejectionReason(rs.getString("rejection_reason"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}
