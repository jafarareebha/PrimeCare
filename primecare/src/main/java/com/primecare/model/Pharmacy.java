package com.primecare.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model representing a pharmacy record.
 * Maps to the pharmacy_records table.
 */
public class Pharmacy {
    private int id;
    private String patientId;
    private Date date;
    private double pharmacyCharges;
    private String prescriptionPath;
    private Timestamp createdAt;

    public Pharmacy() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public double getPharmacyCharges() { return pharmacyCharges; }
    public void setPharmacyCharges(double pharmacyCharges) { this.pharmacyCharges = pharmacyCharges; }

    public String getPrescriptionPath() { return prescriptionPath; }
    public void setPrescriptionPath(String prescriptionPath) { this.prescriptionPath = prescriptionPath; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
