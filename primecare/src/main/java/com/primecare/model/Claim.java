package com.primecare.model;

import java.sql.Timestamp;

public class Claim {
    private int id;
    private String patientId;
    private int finalBillId;
    private int insuranceId;
    private double claimAmount;
    private String status;
    private String rejectionReason;
    private Timestamp createdAt;

    public Claim() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public int getFinalBillId() { return finalBillId; }
    public void setFinalBillId(int finalBillId) { this.finalBillId = finalBillId; }

    public int getInsuranceId() { return insuranceId; }
    public void setInsuranceId(int insuranceId) { this.insuranceId = insuranceId; }

    public double getClaimAmount() { return claimAmount; }
    public void setClaimAmount(double claimAmount) { this.claimAmount = claimAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
