-- PrimeCare Hospital Billing and Insurance Management System
-- MySQL Schema

CREATE DATABASE IF NOT EXISTS primecare_db;
USE primecare_db;

-- Admins table
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patients table
CREATE TABLE IF NOT EXISTS patients (
    patient_id VARCHAR(50) PRIMARY KEY,
    patient_name VARCHAR(200) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(20) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance table
CREATE TABLE IF NOT EXISTS insurance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    insurance_provider VARCHAR(200) NOT NULL,
    policy_number VARCHAR(100) NOT NULL,
    coverage_percentage DECIMAL(5,2) NOT NULL,
    max_coverage_amount DECIMAL(12,2) NOT NULL,
    coverage_usage_limit DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Treatments table
CREATE TABLE IF NOT EXISTS treatments (
    treatment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    treatment_name VARCHAR(200) NOT NULL,
    treatment_cost DECIMAL(12,2) NOT NULL,
    treatment_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Lab tests table
CREATE TABLE IF NOT EXISTS lab_tests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    test_name VARCHAR(200) NOT NULL,
    cost DECIMAL(12,2) NOT NULL,
    test_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Daily bills table
CREATE TABLE IF NOT EXISTS daily_bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    treatment_date DATE NOT NULL,
    doctor_fee DECIMAL(12,2) DEFAULT 0,
    pharmacy_fee DECIMAL(12,2) DEFAULT 0,
    room_charges DECIMAL(12,2) DEFAULT 0,
    lab_charges DECIMAL(12,2) DEFAULT 0,
    other_charges DECIMAL(12,2) DEFAULT 0,
    treatment_charges DECIMAL(12,2) DEFAULT 0,
    total_amount DECIMAL(12,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Final (consolidated) bills table
CREATE TABLE IF NOT EXISTS final_bills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    total_before_insurance DECIMAL(12,2) NOT NULL,
    insurance_claim DECIMAL(12,2) DEFAULT 0,
    patient_payable DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Claims table
CREATE TABLE IF NOT EXISTS claims (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    final_bill_id INT,
    insurance_id INT,
    claim_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (final_bill_id) REFERENCES final_bills(id),
    FOREIGN KEY (insurance_id) REFERENCES insurance(id)
);

-- Payments table
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id VARCHAR(50) NOT NULL,
    bill_id INT,
    amount_paid DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    notes VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (bill_id) REFERENCES final_bills(id)
);

-- Indexes
CREATE INDEX idx_patients_name ON patients(patient_name);
CREATE INDEX idx_daily_bills_patient ON daily_bills(patient_id);
CREATE INDEX idx_lab_tests_patient ON lab_tests(patient_id);
CREATE INDEX idx_treatments_patient ON treatments(patient_id);
CREATE INDEX idx_payments_patient ON payments(patient_id);
CREATE INDEX idx_claims_patient ON claims(patient_id);
