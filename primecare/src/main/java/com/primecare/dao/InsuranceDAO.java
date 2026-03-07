package com.primecare.dao;

import com.primecare.model.Insurance;
import com.primecare.util.DBConnection;

import java.sql.*;

public class InsuranceDAO {

    public boolean addInsurance(Insurance ins) {
        String sql = "INSERT INTO insurance (patient_id, insurance_provider, policy_number, coverage_percentage, max_coverage_amount, coverage_usage_limit) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ins.getPatientId());
            ps.setString(2, ins.getInsuranceProvider());
            ps.setString(3, ins.getPolicyNumber());
            ps.setDouble(4, ins.getCoveragePercentage());
            ps.setDouble(5, ins.getMaxCoverageAmount());
            ps.setDouble(6, ins.getCoverageUsageLimit());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Insurance getInsuranceByPatientId(String patientId) {
        String sql = "SELECT * FROM insurance WHERE patient_id = ? ORDER BY id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, patientId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Insurance ins = new Insurance();
                ins.setId(rs.getInt("id"));
                ins.setPatientId(rs.getString("patient_id"));
                ins.setInsuranceProvider(rs.getString("insurance_provider"));
                ins.setPolicyNumber(rs.getString("policy_number"));
                ins.setCoveragePercentage(rs.getDouble("coverage_percentage"));
                ins.setMaxCoverageAmount(rs.getDouble("max_coverage_amount"));
                ins.setCoverageUsageLimit(rs.getDouble("coverage_usage_limit"));
                return ins;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
