# 📊 Telecom Customer Churn Analysis  
**End-to-End Data Analytics Project | SQL + Python + Power BI**

---

## 📌 Executive Summary

Customer churn directly impacts revenue, profitability, and Customer Lifetime Value (CLTV).  
This project analyzes churn behavior across **7,043 telecom customers** to identify:

- Key churn drivers  
- High-risk customer segments  
- Revenue at risk  
- Data-driven retention strategies  

The analysis integrates **SQL (business queries), Python (cleaning & EDA), and Power BI (interactive dashboard)**.

---

## 🎯 Business Objective

> Identify the major drivers of churn and quantify financial exposure to support strategic retention planning.

Key focus areas:
- Contract type impact
- Early tenure risk
- Pricing sensitivity
- Service adoption impact
- Revenue exposure by internet type
- Behavioral churn patterns

---

## 🗂 Dataset Overview

| File | Description | Rows |
|------|-------------|------|
| `customers.csv` | Demographics (age, gender, dependents) | 7,043 |
| `services.csv` | Contract, internet type, pricing, add-ons | 7,043 |
| `status.csv` | Churn value, churn reason, CLTV | 7,043 |
| `locations.csv` | Geographic information | 7,043 |

After merging and cleaning:

**Final Dataset: 7,043 rows × 45 columns**

### Key Columns Used

`churn_value` · `contract` · `tenure_in_months` · `monthly_charge` ·  
`internet_type` · `payment_method` · `churn_reason` · `cltv`

---

## 🛠 Tools & Technologies

| Tool | Purpose |
|------|--------|
| **SQL** | Data extraction, KPI aggregation, churn risk profiling (21 business queries) |
| **Python (Pandas)** | Data cleaning, merging, feature engineering |
| **Python (Seaborn / Matplotlib)** | Visualization & churn pattern analysis |
| **Power BI** | 3-page interactive dashboard |
| **DAX** | Churn %, Retention %, Revenue at Risk measures |

---

## 🔄 Analytical Workflow

### Step 1 — Data Cleaning (Python)

- Merged 4 CSV files into unified dataset
- Standardized column names
- Filled missing values in `offer`, `internet_type`, `churn_reason`
- Dropped irrelevant columns
- Ensured consistent data types

---

### Step 2 — Feature Engineering (Python)

Created analytical segments:

- `tenure_group` → 0-12, 12-24, 24-36, 36-60, 60+ months  
- `age_group` → 18-35, 35-50, 50-65, 65-80  
- `reason_bucket` → Competitor, Pricing, Service Quality, Network Issue, Feature Gap, Other  

---

### Step 3 — Exploratory Data Analysis (Python)

- Churn rate by contract type  
- Churn by tenure group  
- Revenue by internet type  
- Service add-on adoption vs churn  
- Payment method risk profiling  
- Correlation between monthly charge and churn  

---

### Step 4 — SQL Business Analysis

- Built `churn_base` view using multi-table joins  
- Wrote 21 business queries covering:
  - Demographic churn risk
  - Tenure analysis
  - Revenue at risk
  - CLTV comparison
  - Multi-factor churn combinations

---

## 📊 Power BI Dashboard

The dashboard was designed for business managers to monitor churn drivers and revenue exposure dynamically.

---
### 🔹 Page 1 — Contract & Tenure Risk

This page shows churn rate by contract type and tenure group.

![Contract & Tenure](dashboard/screenshots/page1_contract_tenure.png)

---

### 🔹 Page 2 — Services & Offers

This page highlights churn by internet type and promotional offers.

![Services & Offers](dashboard/screenshots/page2_services_offers.png)

---

### 🔹 Page 3 — Revenue Risk

This page focuses on revenue at risk and CLTV impact.

![Revenue Risk](dashboard/screenshots/page3_revenue_risk.png)
---

## 📈 Key Business Insights

- **Overall churn rate: 26.54%** (1 in 4 customers)
- Month-to-Month contracts show highest churn
- 0–12 month customers represent highest risk (1,037 churns)
- Competitor (46%) and Pricing (38%) drive 84% of churn
- Fiber Optic segment exposes **$3.0M revenue at risk**
- Customers without premium support churn at 5× higher rate
- Mailed check users represent 43% of churned customers
- Churn drops sharply after 12 months

---

## 💡 Strategic Recommendations

| Priority | Recommendation | Business Rationale |
|----------|---------------|-------------------|
| 🔴 High | Convert Month-to-Month to annual contracts | Primary churn driver |
| 🔴 High | Strengthen first 6-month onboarding | Highest churn segment |
| 🔴 High | Implement competitor counter-offer strategy | 46% churn reason |
| 🟠 Medium | Review Fiber Optic pricing | $3.0M at risk |
| 🟠 Medium | Promote premium support bundles | Reduces churn significantly |
| 🟡 Low | Launch referral rewards | High churn among 0-referral users |
| 🟡 Low | Encourage auto-pay adoption | High churn among mailed check users |

---

## 🚀 Project Value

This project demonstrates:

- Business-focused analytical thinking  
- Revenue-risk quantification  
- SQL + Python + BI integration  
- Executive-level insight communication  
- Strategic decision support  

---

📌 *Built as part of Data Analyst portfolio preparation.*
