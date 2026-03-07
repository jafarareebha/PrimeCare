package com.primecare.model;

import java.sql.Date;

public class Payment {
    private int paymentId;
    private String patientId;
    private int billId;
    private double amountPaid;
    private Date paymentDate;
    private String notes;

    public Payment() {}

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public String getPatientId() { return patientId; }
    public void setPatientId(String patientId) { this.patientId = patientId; }

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(double amountPaid) { this.amountPaid = amountPaid; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
