CREATE DATABASE healthcare_db;
USE healthcare_db;

-- Creating table --
-- NOTE :--
-- Admission_Month  -- It will be derived from admission_date

CREATE TABLE health_sector (
    Patient_id INT PRIMARY KEY,
    Age INT,
    Diagnosis VARCHAR(100),
    Admission_Date DATE,
    Discharge_Date DATE,
    Stay_Duration INT,
    Department VARCHAR(50),
    Treatment_cost DECIMAL(10,2),
    Insurance_type VARCHAR(30),
    Blood_pressure VARCHAR(20),
    Heart_rate INT,
    Outcome VARCHAR(20));
    

-- Basic data checking --
 
    SELECT * FROM health_sector;
    SELECT COUNT(*) AS total_records FROM health_sector;    
    
    
-- KPI QUERIES --
-- Total Patients --
SELECT COUNT(Patient_ID) AS total_patients FROM health_sector;

-- Average Length of Stay
SELECT AVG(Stay_Duration) AS avg_Stay_Duration FROM health_sector;

-- Total Treatment Cost --
SELECT SUM(Treatment_Cost) AS Total_treatment_cost FROM health_sector;


                                 -- DEPARTMENT ANALYSIS --


-- Patients per department

SELECT Department,COUNT(*) AS Total_patients from health_sector 
GROUP BY Department ORDER BY Total_patients DESC;

-- cost per department --
SELECT Department,SUM(Treatment_Cost) AS Total_cost
FROM health_sector GROUP BY Department ORDER BY Total_cost DESC;

                            -- INSURANCE ANALYSIS --
					
SELECT Insurance_Type,COUNT(*) AS Patients,
SUM(Treatment_Cost) AS total_cost,AVG(Treatment_Cost) avg_cost
FROM health_sector GROUP BY Insurance_Type;

                                 
                                 -- OUTCOME ANALYSIS --
                                 
			
SELECT Outcome,COUNT(*) AS patients,
AVG(Stay_Duration) AS avg_stay,
AVG(Treatment_Cost) AS avg_cost
FROM health_sector GROUP BY Outcome;

							     
                                 
                                 -- STAY DURATION CATEGORY --
					
SELECT CASE WHEN Stay_Duration<= 3 THEN "Short_stay"
WHEN Stay_Duration BETWEEN 4 AND 7 THEN "Medium_Stay"
ELSE "Long_Stay"

END AS Stay_category,COUNT(*)
AS Patients,SUM(Treatment_Cost) AS total_cost
FROM health_sector GROUP BY Stay_category;

                                                          
                                                          
                                                                     -- MONTHLY TREND ANALYSIS --
                                                                         -- (Derived field) --
                                                                         
                                                                         
                                                                         
 
-- Monthly admissions --
			
            
SELECT 
	MONTHNAME(Admission_Date) AS Admission_Month,
    COUNT(*) AS Admissions,
    SUM(Treatment_Cost) AS Total_Cost FROM health_sector
    GROUP BY MONTH (Admission_Date),MONTHNAME(Admission_Date)
    ORDER BY MONTH(Admission_Date);
    

-- view --

CREATE VIEW healthcare_summary AS
SELECT
    Patient_id,
    Age,
    Department,
    Insurance_type,
    Outcome,
    Stay_Duration,
    Treatment_Cost,
    Admission_Date,
    MONTHNAME(Admission_Date) AS Admission_Month
FROM health_sector;

SELECT * FROM healthcare_summary;

-- TOP COSTLY DEPARTMENT--
SELECT
    Department,
    COUNT(*) AS Patients,
    AVG(Stay_Duration) AS Avg_Stay,
    SUM(Treatment_Cost) AS Total_Cost,
    RANK() OVER (ORDER BY SUM(Treatment_Cost) DESC) AS Cost_Rank
FROM health_sector
GROUP BY Department;

