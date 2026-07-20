-- ==================================================================================
-- PROJECT: Hospital Patient Outcomes Dashboard
-- SCRIPT: Healthcare Analytics Queries
-- PURPOSE: Extract key performance indicators (KPIs) and insights.
-- ==================================================================================

-- 1. Total Patients & Admissions
SELECT 
    COUNT(DISTINCT Patient_ID) AS Total_Unique_Patients,
    COUNT(*) AS Total_Admissions
FROM patient_data_cleaned;

-- 2. Average Length of Stay (ALOS)
SELECT ROUND(AVG(Length_of_Stay), 2) AS Average_LOS
FROM patient_data_cleaned;

-- 3. Admissions by Department
SELECT Department, COUNT(*) AS Patient_Count
FROM patient_data_cleaned
GROUP BY Department
ORDER BY Patient_Count DESC;

-- 4. Monthly Admissions Trend
SELECT 
    strftime('%Y-%m', Admission_Date) AS Month,
    COUNT(*) AS Monthly_Admissions
FROM patient_data_cleaned
GROUP BY Month
ORDER BY Month;

-- 5. Gender & Age Group Distribution
SELECT 
    Gender, 
    COUNT(*) AS Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patient_data_cleaned), 2) AS Percentage
FROM patient_data_cleaned
GROUP BY Gender;

SELECT 
    CASE 
        WHEN Age < 18 THEN '0-17 (Pediatric)'
        WHEN Age BETWEEN 18 AND 40 THEN '18-40 (Adult)'
        WHEN Age BETWEEN 41 AND 65 THEN '41-65 (Middle Age)'
        ELSE '65+ (Senior)'
    END AS Age_Group,
    COUNT(*) AS Patient_Count
FROM patient_data_cleaned
GROUP BY Age_Group
ORDER BY Age_Group;

-- 6. Clinical Outcomes Distribution
SELECT Outcome, COUNT(*) AS Count
FROM patient_data_cleaned
GROUP BY Outcome;

-- 7. Recovery & Readmission Rates
SELECT 
    ROUND(SUM(CASE WHEN Outcome = 'Recovered' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Recovery_Rate_Percentage,
    ROUND(SUM(CASE WHEN Readmission = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Readmission_Rate_Percentage
FROM patient_data_cleaned;

-- 8. Departmental Performance (Avg LOS and Readmission Rate)
SELECT 
    Department,
    ROUND(AVG(Length_of_Stay), 2) AS Avg_LOS,
    ROUND(SUM(CASE WHEN Readmission = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Readmission_Rate
FROM patient_data_cleaned
GROUP BY Department
ORDER BY Readmission_Rate DESC;
