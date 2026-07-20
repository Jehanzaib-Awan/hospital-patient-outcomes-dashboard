-- ==================================================================================
-- PROJECT: Hospital Patient Outcomes Dashboard
-- SCRIPT: Data Cleaning and Standardization
-- PURPOSE: Clean and prepare raw patient data for analysis.
-- ==================================================================================

-- 1. Create a Staging Table to preserve raw data
DROP TABLE IF EXISTS patient_data_cleaned;
CREATE TABLE patient_data_cleaned AS SELECT * FROM raw_patient_data;

-- 2. Remove Duplicate Records
-- Identify and delete duplicates based on Patient_ID and Admission_Date
DELETE FROM patient_data_cleaned
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM patient_data_cleaned
    GROUP BY Patient_ID, Admission_Date
);

-- 3. Handling NULL Values
-- Standardize missing outcomes to 'Pending' or 'Unknown'
UPDATE patient_data_cleaned
SET Outcome = 'Unknown'
WHERE Outcome IS NULL OR Outcome = '';

-- 4. Formatting Dates
-- Ensure dates are in YYYY-MM-DD format (Standard SQL)
-- Note: Depending on the SQL dialect (SQLite, PostgreSQL, MySQL), the syntax varies.
-- Here we assume standard string format for consistency.

-- 5. Standardizing Text Values (Case Normalization)
UPDATE patient_data_cleaned
SET Gender = CASE 
    WHEN LOWER(Gender) = 'male' THEN 'Male'
    WHEN LOWER(Gender) = 'female' THEN 'Female'
    ELSE 'Other'
END;

UPDATE patient_data_cleaned
SET Department = CASE 
    WHEN LOWER(Department) = 'cardiology' THEN 'Cardiology'
    WHEN LOWER(Department) = 'emergency' THEN 'Emergency'
    WHEN LOWER(Department) = 'general medicine' THEN 'General Medicine'
    WHEN LOWER(Department) = 'orthopedics' THEN 'Orthopedics'
    WHEN LOWER(Department) = 'pediatrics' THEN 'Pediatrics'
    WHEN LOWER(Department) = 'surgery' THEN 'Surgery'
    ELSE Department
END;

-- 6. Data Validation
-- Remove records where Discharge Date is before Admission Date (Logical error)
DELETE FROM patient_data_cleaned
WHERE Discharge_Date < Admission_Date;

-- Ensure Length of Stay is consistent with dates
UPDATE patient_data_cleaned
SET Length_of_Stay = julianday(Discharge_Date) - julianday(Admission_Date);

-- 7. Final Check
SELECT COUNT(*) AS total_records FROM patient_data_cleaned;
