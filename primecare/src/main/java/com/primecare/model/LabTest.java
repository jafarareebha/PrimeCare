package com.primecare.model;

import java.sql.Date;

public class LabTest {
    private int id;
    private String patientId;
    private String testName;
    private double cost;
    private Date testDate;

    public LabTest() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getTestName() { return testName; }
    public void setTestName(String testName) { this.testName = testName; }

    public double getCost() { return cost; }
    public void setCost(double cost) { this.cost = cost; }

    public Date getTestDate() { return testDate; }
    public void setTestDate(Date testDate) { this.testDate = testDate; }
}
