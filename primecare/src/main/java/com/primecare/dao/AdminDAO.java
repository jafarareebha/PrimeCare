package com.primecare.dao;

import com.primecare.model.Admin;
import com.primecare.util.DBConnection;

import java.sql.*;

public class AdminDAO {

    public boolean registerAdmin(Admin admin) {
        String sql = "INSERT INTO admins (username, password) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, admin.getUsername());
            ps.setString(2, admin.getPassword());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Admin login(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean usernameExists(String username) {
        String sql = "SELECT id FROM admins WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
