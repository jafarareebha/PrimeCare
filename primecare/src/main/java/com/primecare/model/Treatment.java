package com.primecare.model;

import java.sql.Date;

public class Treatment {
    private int treatmentId;
    private String patientId;
    private String treatmentName;
    private double treatmentCost;
    private Date treatmentDate;

    public Treatment() {}

    public int getTreatmentId() { return treatmentId; }
    public void setTreatmentId(int treatmentId) { this.treatmentId = treatmentId; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getTreatmentName() { return treatmentName; }
    public void setTreatmentName(String treatmentName) { this.treatmentName = treatmentName; }

    public double getTreatmentCost() { return treatmentCost; }
    public void setTreatmentCost(double treatmentCost) { this.treatmentCost = treatmentCost; }

    public Date getTreatmentDate() { return treatmentDate; }
    public void setTreatmentDate(Date treatmentDate) { this.treatmentDate = treatmentDate; }
}
