package com.primecare.model;

import java.sql.Date;

public class DailyBill {

    private int billId;
    private String patientId;
    private Date treatmentDate;

    private double doctorFee;
    private double pharmacyFee;
    private double roomCharges;
    private double labCharges;
    private double otherCharges;
    private double treatmentCharges;

    private double totalAmount;

    public DailyBill() {}

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public Date getTreatmentDate() { return treatmentDate; }
    public void setTreatmentDate(Date treatmentDate) { this.treatmentDate = treatmentDate; }

    public double getDoctorFee() { return doctorFee; }
    public void setDoctorFee(double doctorFee) { this.doctorFee = doctorFee; }

    public double getPharmacyFee() { return pharmacyFee; }
    public void setPharmacyFee(double pharmacyFee) { this.pharmacyFee = pharmacyFee; }

    public double getRoomCharges() { return roomCharges; }
    public void setRoomCharges(double roomCharges) { this.roomCharges = roomCharges; }

    public double getLabCharges() { return labCharges; }
    public void setLabCharges(double labCharges) { this.labCharges = labCharges; }

    public double getOtherCharges() { return otherCharges; }
    public void setOtherCharges(double otherCharges) { this.otherCharges = otherCharges; }

    public double getTreatmentCharges() { return treatmentCharges; }
    public void setTreatmentCharges(double treatmentCharges) { this.treatmentCharges = treatmentCharges; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
}