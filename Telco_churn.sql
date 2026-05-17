CREATE DATABASE churn_analysis;
USE churn_analysis;

CREATE TABLE telco_churn (
    customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(30),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges VARCHAR(20),
    Churn VARCHAR(5)
);

--Check Data
SELECT COUNT(*) FROM [WA_Fn-UseC_-Telco-Customer-Churn];

--Import Data into telco_churn
INSERT INTO telco_churn
SELECT * FROM [WA_Fn-UseC_-Telco-Customer-Churn];

--Check
SELECT COUNT(*) FROM telco_churn;

--Update telco_churn null
UPDATE telco_churn
SET TotalCharges = 0
WHERE TotalCharges IS NULL;

SELECT COUNT(*) FROM telco_churn
WHERE TotalCharges IS NULL;

--EDA
--Overall Churn Rate
SELECT 
    Churn,
    COUNT(*) AS total_customers,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn), 2) AS DECIMAL(5,2)) AS percentage
FROM telco_churn
GROUP BY Churn;

--Churn by Contract Type
SELECT 
    Contract,
    Churn,
    COUNT(*) AS total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Contract), 2) AS DECIMAL(5,2)) AS churn_rate
FROM telco_churn
GROUP BY Contract, Churn;

--Churn by Internet Service
SELECT 
    InternetService,
    Churn,
    COUNT(*) AS total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY InternetService), 2) AS DECIMAL(5,2)) AS churn_rate
FROM telco_churn
GROUP BY InternetService, Churn;

--Average Tenure & Charges by Churn
SELECT 
    Churn,
    CAST(ROUND(AVG(CAST(tenure AS FLOAT)), 1) AS DECIMAL(5,1)) AS avg_tenure_months,
    CAST(ROUND(AVG(MonthlyCharges), 2) AS DECIMAL(8,2)) AS avg_monthly_charges,
    CAST(ROUND(AVG(TotalCharges), 2) AS DECIMAL(10,2)) AS avg_total_charges
FROM telco_churn
GROUP BY Churn;