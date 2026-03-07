package com.primecare.model;

import java.sql.Timestamp;

public class FinalBill {

    private int id;
    private String patientId;

    private double totalBeforeInsurance;
    private double insuranceClaim;
    private double patientPayable;

    private Timestamp createdAt;

    public FinalBill() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public double getTotalBeforeInsurance() { return totalBeforeInsurance; }
    public void setTotalBeforeInsurance(double totalBeforeInsurance) { this.totalBeforeInsurance = totalBeforeInsurance; }

    public double getInsuranceClaim() { return insuranceClaim; }
    public void setInsuranceClaim(double insuranceClaim) { this.insuranceClaim = insuranceClaim; }

    public double getPatientPayable() { return patientPayable; }
    public void setPatientPayable(double patientPayable) { this.patientPayable = patientPayable; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}