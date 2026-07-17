-- Hospital Patient Outcomes Analysis Queries
-- Dataset: Synthetic Hospital Records

-- 1. Average Length of Stay by Department
SELECT Department, ROUND(AVG(Length_of_Stay), 2) AS Avg_Stay
FROM hospital_patient_data
GROUP BY Department;

-- 2. Readmission Rate per Department
SELECT Department, 
       COUNT(*) AS Total_Patients,
       SUM(CASE WHEN Readmission_Status = 'Yes' THEN 1 ELSE 0 END) AS Readmissions,
       ROUND((SUM(CASE WHEN Readmission_Status = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS Readmission_Rate
FROM hospital_patient_data
GROUP BY Department;

-- 3. Average Satisfaction Score by Treatment Type
SELECT Treatment_Type, ROUND(AVG(Satisfaction_Score), 2) AS Avg_Satisfaction
FROM hospital_patient_data
GROUP BY Treatment_Type
ORDER BY Avg_Satisfaction DESC;

-- 4. Emergency vs Routine Admission Analysis
SELECT Emergency_Status, COUNT(*) AS Patient_Count, ROUND(AVG(Length_of_Stay), 2) AS Avg_Stay
FROM hospital_patient_data
GROUP BY Emergency_Status;
