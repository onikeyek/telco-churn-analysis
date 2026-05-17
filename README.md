#  Telco Customer Churn Analysis

> **Tools:** SQL Server · Power BI &nbsp;|&nbsp; **Dataset:** IBM Telco Customer Churn (Kaggle) &nbsp;|&nbsp; **Records:** 7,043 customers

---

##  Project Overview

This project performs an end-to-end **Exploratory Data Analysis (EDA)** on a telecom company's customer dataset to uncover churn patterns, identify high-risk segments, and deliver actionable business recommendations.

**Churn** means a customer cancelled or stopped using the service. With a churn rate of **26.54%**, understanding *who* leaves and *why* is critical for any retention strategy.

**Workflow:** Data was imported into SQL Server, cleaned and analysed with SQL and  visualized in an interactive Power BI dashboard.

---

##  Dataset

| Attribute | Details |
|---|---|
| Source | [IBM Telco Customer Churn – Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) |
| Records | 7,043 customers |
| Features | 21 columns |
| Target column | `Churn` (Yes / No) |

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL Server (SSMS) | Data cleaning, EDA queries |
| Power BI Desktop | Dashboard and DAX measures |

---

## Data Cleaning

- Imported CSV into SQL Server using the Import Flat File Wizard
- Identified **11 rows** with empty `TotalCharges` — all had `tenure = 0` (new customers with no billing history)
- Set those values to `0.00` rather than dropping the rows
- Confirmed all 7,043 rows loaded correctly before analysis

> Full cleaning script: [`sql/02_data_cleaning.sql`](https://github.com/onikeyek/telco-churn-analysis)

---

## SQL Analysis — Key Snippets

### 1. Overall Churn Rate

A straightforward query to establish the baseline churn rate across all customers.

```sql
SELECT 
    Churn,
    COUNT(*) AS total_customers,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telco_churn), 2) AS DECIMAL(5,2)) AS percentage
FROM telco_churn
GROUP BY Churn;
```

| Churn | Customers | Percentage |
|---|---|---|
| No | 5,174 | 73.46% |
| Yes | 1,869 | **26.54%** |

---

### 2. Churn Rate by Contract Type (Window Function)

This query uses a `PARTITION BY` window function to calculate churn rate *within* each contract group — showing how contract length dramatically affects customer loyalty.

```sql
SELECT 
    Contract,
    Churn,
    COUNT(*) AS total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Contract), 2) AS DECIMAL(5,2)) AS churn_rate
FROM telco_churn
GROUP BY Contract, Churn;
```

| Contract | Churn Rate |
|---|---|
| Month-to-month | **42.71%** 🔴 |
| One year | 11.27% 🟡 |
| Two year | 2.83% 🟢 |

> Month-to-month customers are **15x more likely** to churn than two-year contract holders.

> Full EDA queries: [`sql/03_eda_queries.sql`](sql/03_eda_queries.sql)

---

## Power BI Dashboard

Built an interactive dashboard with slicers for **Contract**, **Internet Service**, and **Payment Method** — allowing dynamic filtering across all visuals.

### DAX Measure — Churn Rate %

```dax
Churn Rate % = 
DIVIDE(
    COUNTROWS(FILTER(telco_churn, telco_churn[Churn] = "Yes")),
    COUNTROWS(telco_churn),
    0
) * 100
```

This measure dynamically recalculates the churn rate based on whatever slicer selections are active — making the dashboard fully interactive.

### Dashboard Visuals
<img width="911" height="508" alt="image" src="https://github.com/user-attachments/assets/22d5509a-fe03-4cdf-b8ea-f0b41dcbcb73" />


| Visual | Chart Type |
|---|---|
| Total customers, churned, retained, avg charges | KPI Cards |
| Churn by contract type | Stacked bar chart |
| Churn by payment method | Stacked bar chart |
| Churn by internet service | Donut chart |
| Avg monthly charges vs churn | Column chart |
| Avg tenure vs churn | Column chart |

---

## Key Findings

| Factor | Highest Risk Group | Churn Rate |
|---|---|---|
| Contract type | Month-to-month | 42.71% |
| Internet service | Fiber optic | 41.89% |
| Payment method | Electronic check | 45.29% |
| Avg tenure | Churned customers | 18 months |
| Avg monthly charges | Churned customers | $74.44 |

**Churned customers paid $13.17 more per month** but left twice as early — a clear sign of a price-to-value disconnect.

---

## ⚠️ High-Risk Customer Profile

A customer matching all three criteria below has an estimated churn probability exceeding **60%:**

- Contract: **Month-to-month**
- Internet service: **Fiber optic**
- Payment method: **Electronic check**

---

## Project Structure

```
telco-churn-analysis/
│
├── data/
│   └── WA_Fn-UseC_-Telco-Customer-Churn.csv
│
├── sql/
│   ├── 01_create_table.sql
│   ├── 02_data_cleaning.sql
│   └── 03_eda_queries.sql
│
├── dashboard/
│   └── Telco_Churn_Analysis.pbix
│
└── README.md
```

---

##  Author

**Naimot Yekini** &nbsp;|&nbsp; 
🔗 [GitHub](https://github.com/onikeyek) &nbsp;·&nbsp;  🔗 [Portfolio](https://onikeyek.github.io/NaimotYekini.github.io/)
