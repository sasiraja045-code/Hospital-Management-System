-- =============================================
-- HOSPITAL MANAGEMENT SYSTEM (Oracle SQL*Plus)
-- =============================================

-- =============================================
-- TABLE 1: PATIENTS
-- =============================================
CREATE TABLE patients (
    patient_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name    VARCHAR2(100) NOT NULL,
    age          NUMBER,
    gender       VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    phone        VARCHAR2(15),
    address      VARCHAR2(500),
    blood_group  VARCHAR2(5),
    registered_date DATE DEFAULT SYSDATE
);

-- =============================================
-- TABLE 2: DOCTORS
-- =============================================
CREATE TABLE doctors (
    doctor_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name        VARCHAR2(100) NOT NULL,
    specialization   VARCHAR2(100),
    phone            VARCHAR2(15),
    email            VARCHAR2(100),
    experience_years NUMBER
);

-- =============================================
-- TABLE 3: APPOINTMENTS
-- =============================================
CREATE TABLE appointments (
    appointment_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id       NUMBER,
    doctor_id        NUMBER,
    appointment_date DATE,
    status           VARCHAR2(20) DEFAULT 'Scheduled'
                     CHECK (status IN ('Scheduled', 'Completed', 'Cancelled')),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id)
);

-- =============================================
-- TABLE 4: MEDICAL RECORDS
-- =============================================
CREATE TABLE medical_records (
    record_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id   NUMBER,
    doctor_id    NUMBER,
    visit_date   DATE,
    diagnosis    VARCHAR2(500),
    treatment    VARCHAR2(500),
    prescription VARCHAR2(500),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id)
);

-- =============================================
-- INSERT SAMPLE DATA
-- =============================================

-- Patients
INSERT INTO patients (full_name, age, gender, phone, address, blood_group)
VALUES ('Arun Kumar', 35, 'Male', '9876543210', 'Chennai', 'A+');

INSERT INTO patients (full_name, age, gender, phone, address, blood_group)
VALUES ('Priya Devi', 28, 'Female', '9123456780', 'Coimbatore', 'B+');

INSERT INTO patients (full_name, age, gender, phone, address, blood_group)
VALUES ('Ramesh S', 52, 'Male', '9988776655', 'Madurai', 'O+');

INSERT INTO patients (full_name, age, gender, phone, address, blood_group)
VALUES ('Kavitha M', 41, 'Female', '9871234560', 'Salem', 'AB+');

-- Doctors
INSERT INTO doctors (full_name, specialization, phone, email, experience_years)
VALUES ('Dr. Senthil Kumar', 'Cardiologist', '9000111222', 'senthil@hospital.com', 15);

INSERT INTO doctors (full_name, specialization, phone, email, experience_years)
VALUES ('Dr. Meena R', 'Dermatologist', '9000333444', 'meena@hospital.com', 8);

INSERT INTO doctors (full_name, specialization, phone, email, experience_years)
VALUES ('Dr. Vijay P', 'Orthopedic', '9000555666', 'vijay@hospital.com', 12);

-- Appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status)
VALUES (1, 1, TO_DATE('2025-07-01', 'YYYY-MM-DD'), 'Scheduled');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, status)
VALUES (2, 2, TO_DATE('2025-07-01', 'YYYY-MM-DD'), 'Scheduled');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, status)
VALUES (3, 3, TO_DATE('2025-07-02', 'YYYY-MM-DD'), 'Completed');

INSERT INTO appointments (patient_id, doctor_id, appointment_date, status)
VALUES (4, 1, TO_DATE('2025-07-03', 'YYYY-MM-DD'), 'Cancelled');

-- Medical Records
INSERT INTO medical_records (patient_id, doctor_id, visit_date, diagnosis, treatment, prescription)
VALUES (3, 3, TO_DATE('2025-07-02', 'YYYY-MM-DD'), 'Knee Pain', 'Physiotherapy', 'Ibuprofen 400mg');

INSERT INTO medical_records (patient_id, doctor_id, visit_date, diagnosis, treatment, prescription)
VALUES (1, 1, TO_DATE('2025-06-15', 'YYYY-MM-DD'), 'High BP', 'Medication & Rest', 'Amlodipine 5mg');

COMMIT;

-- =============================================
-- USEFUL QUERIES
-- =============================================

-- 1. All patients list
SELECT * FROM patients;

-- 2. All doctors list
SELECT * FROM doctors;

-- 3. All appointments with patient & doctor names
SELECT
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date;

-- 4. Specific patient history (patient_id = 1)
SELECT
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    m.visit_date,
    m.diagnosis,
    m.treatment,
    m.prescription
FROM medical_records m
JOIN patients p ON m.patient_id = p.patient_id
JOIN doctors d ON m.doctor_id = d.doctor_id
WHERE p.patient_id = 1;

-- 5. Doctor wise appointment count
SELECT
    d.full_name AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.full_name, d.specialization;

-- 6. Cancelled appointments
SELECT
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.appointment_date
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Cancelled';