package com.primecare.model;

public class Insurance {
    private int id;
    private String patientId;
    private String insuranceProvider;
    private String policyNumber;
    private double coveragePercentage;
    private double maxCoverageAmount;
    private double coverageUsageLimit;

    public Insurance() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public String getInsuranceProvider() { return insuranceProvider; }
    public void setInsuranceProvider(String insuranceProvider) { this.insuranceProvider = insuranceProvider; }

    public String getPolicyNumber() { return policyNumber; }
    public void setPolicyNumber(String policyNumber) { this.policyNumber = policyNumber; }

    public double getCoveragePercentage() { return coveragePercentage; }
    public void setCoveragePercentage(double coveragePercentage) { this.coveragePercentage = coveragePercentage; }

    public double getMaxCoverageAmount() { return maxCoverageAmount; }
    public void setMaxCoverageAmount(double maxCoverageAmount) { this.maxCoverageAmount = maxCoverageAmount; }

    public double getCoverageUsageLimit() { return coverageUsageLimit; }
    public void setCoverageUsageLimit(double coverageUsageLimit) { this.coverageUsageLimit = coverageUsageLimit; }
}
