<div align="center">

<img src="https://img.shields.io/badge/Amazon-FF6600?style=for-the-badge&logo=amazon&logoColor=white" />
<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" />
<img src="https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />
<img src="https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white" />
<img src="https://img.shields.io/badge/Status-Complete-brightgreen?style=for-the-badge" />

# 🛒 Amazon Sales Analytics Dashboard

### End-to-End Data Analyst Portfolio Project

*SQL · Power BI · Customer Segmentation · Sales Forecasting · A/B Testing · Inventory Analytics*

---

**250 Orders &nbsp;|&nbsp; 9 Months of Data &nbsp;|&nbsp; $243,845 Revenue Analysed &nbsp;|&nbsp; 15+ SQL Queries &nbsp;|&nbsp; 8 Dashboard Visuals**

</div>

---

## 📋 Table of Contents

1. [Project Overview](#-project-overview)
2. [Business Problem](#-business-problem)
3. [Dataset Description](#-dataset-description)
4. [Methodology](#-methodology)
5. [SQL Analysis](#-sql-analysis)
6. [Power BI Dashboard](#-power-bi-dashboard)
7. [Key Findings](#-key-findings)
8. [Customer Segmentation](#-customer-segmentation)
9. [Sales Forecasting](#-sales-forecasting)
10. [Inventory Analytics](#-inventory-analytics)
11. [A/B Testing](#-ab-testing)
12. [Business Recommendations](#-business-recommendations)
13. [Project Structure](#-project-structure)
14. [Tools & Technologies](#-tools--technologies)
15. [How to Run](#-how-to-run)

---

## 🎯 Project Overview

This is a **complete end-to-end data analyst portfolio project** simulating a real-world business intelligence engagement for an Amazon-style e-commerce platform. The project covers the full analyst workflow — from raw data ingestion and SQL querying in MySQL, through interactive Power BI dashboard development, to advanced analytics including customer segmentation, time-series forecasting, inventory risk modelling, and A/B conversion-rate experimentation.

> **Goal:** Transform 250 raw sales transactions into actionable business intelligence that drives revenue growth, reduces churn, and optimises inventory decisions.

---

## 💼 Business Problem

An e-commerce business is experiencing **inconsistent monthly revenue**, a **30.8% order cancellation rate**, and **uncertain inventory levels** across 10 product SKUs. Leadership needs answers to five core questions:

| # | Business Question | Analysis Applied |
|---|---|---|
| 1 | Which products and categories drive the most revenue? | SQL Aggregation + Power BI Bar Charts |
| 2 | Who are our most valuable customers and how do we retain them? | Customer Segmentation + RFM Analysis |
| 3 | Is our revenue trending up or down — and what should we expect next month? | Moving Average + Growth Rate Forecasting |
| 4 | Which products are at risk of going out of stock? | Inventory Risk Classification |
| 5 | Does our new checkout experience convert better than the old one? | A/B Hypothesis Testing |

---

## 📊 Dataset Description

**File:** `amazon_sales_final.csv`  
**Records:** 250 orders &nbsp;|&nbsp; **Period:** March – November 2025 &nbsp;|&nbsp; **Columns:** 14

| Column | Type | Description |
|---|---|---|
| `OrderID` | VARCHAR | Unique order identifier (ORD0001 – ORD0250) |
| `OrderDate` | DATE | Transaction date — normalised from `YYYY/MM/DD` string |
| `Product` | VARCHAR | Product name — 10 distinct SKUs |
| `Category` | VARCHAR | Product category — 5 categories |
| `Price` | INT | Unit selling price (USD) |
| `Quantity` | INT | Units per transaction |
| `TotalSales` | INT | Gross revenue (Price × Quantity) |
| `CustomerName` | VARCHAR | Customer name — 10 unique customers |
| `CustomerLocation` | VARCHAR | US city — 10 cities |
| `PaymentMethod` | VARCHAR | Payment channel — 5 methods |
| `Status` | VARCHAR | `Completed` / `Pending` / `Cancelled` |
| `Profit` | INT | *Engineered:* TotalSales × 0.30 |
| `Inventory_stock` | INT | *Engineered:* Simulated stock level (0–500 units) |
| `Test_group` | VARCHAR | *Engineered:* A/B experiment assignment |

> **Data Engineering Note:** Three columns (`Profit`, `Inventory_stock`, `Test_group`) were created via `ALTER TABLE` + `UPDATE` statements as part of the analysis. The `OrderDate` column was converted from `VARCHAR` to `DATE` format using `STR_TO_DATE()`, and a UTF-8 BOM prefix on `OrderID` was resolved using `RENAME COLUMN`.

---

## 🔬 Methodology

The project follows the **CRISP-DM** (Cross-Industry Standard Process for Data Mining) framework:

```
Business Understanding  ──►  Data Understanding  ──►  Data Preparation
         │                                                    │
   5 core business                14-column schema        STR_TO_DATE()
      questions                   profiling & QA         ALTER + UPDATE
                                                         BOM fix
         ▼                                                    ▼
   Deployment          ◄──   Evaluation          ◄──    Modelling
         │                        │                          │
   Dashboard +           Business impact         SQL queries, segmentation,
  Recommendations       assessment               forecasting, A/B test
```

**Analysis Layers:**

1. **Descriptive Analytics** — What happened? (Revenue, orders, status, regional sales)
2. **Diagnostic Analytics** — Why did it happen? (Category breakdown, payment analysis, cancellation rate)
3. **Predictive Analytics** — What will happen? (Moving average, growth-rate forecasting)
4. **Prescriptive Analytics** — What should we do? (Segmentation actions, inventory reorders, A/B rollout)

---

## 🗄️ SQL Analysis

All queries are in `AMAZON_PROJECT.sql`. Below are the key analytical queries with results.

### Database Setup

```sql
CREATE DATABASE walmart_sales;
USE walmart_sales;

-- Fix UTF-8 BOM prefix on OrderID column
ALTER TABLE amazon_sales
RENAME COLUMN ï»¿OrderID TO OrderID;

-- Normalise date format from VARCHAR to DATE
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon_sales
SET OrderDate = STR_TO_DATE(OrderDate, '%Y/%m/%d');
```

---

### 📌 Query 1 — Total Revenue & Orders

```sql
SELECT SUM(TotalSales) AS Total_revenue FROM amazon_sales;
-- ► $243,845

SELECT COUNT(OrderID) AS Total_orders FROM amazon_sales;
-- ► 250 orders
```

---

### 📌 Query 2 — Top Selling Products

```sql
SELECT Product,
       SUM(TotalSales) AS Revenue
FROM amazon_sales
GROUP BY Product
ORDER BY Revenue DESC;
```

| Rank | Product | Revenue | Share |
|---|---|---|---|
| 🥇 | Refrigerator | $78,000 | 32.0% |
| 🥈 | Laptop | $58,400 | 23.9% |
| 🥉 | Smartphone | $48,500 | 19.9% |
| 4 | Washing Machine | $27,000 | 11.1% |
| 5 | Smartwatch | $15,750 | 6.5% |

> **Insight:** Top 3 products alone account for **75.8%** of total revenue.

---

### 📌 Query 3 — Category-Wise Revenue & Profit

```sql
SELECT Category,
       SUM(TotalSales) AS Revenue
FROM amazon_sales
GROUP BY Category
ORDER BY Revenue DESC;
```

| Category | Revenue | Profit | Margin |
|---|---|---|---|
| Electronics | $129,950 | $38,985 | 30% |
| Home Appliances | $105,000 | $31,500 | 30% |
| Footwear | $4,320 | $1,296 | 30% |
| Clothing | $3,540 | $1,062 | 30% |
| Books | $1,035 | $321 | 30% |

---

### 📌 Query 4 — Payment Method Distribution

```sql
SELECT PaymentMethod,
       COUNT(*) AS Total_transactions
FROM amazon_sales
GROUP BY PaymentMethod
ORDER BY Total_transactions DESC;
```

| Payment Method | Transactions | Share |
|---|---|---|
| PayPal | 60 | 24.0% |
| Credit Card | 54 | 21.6% |
| Debit Card | 53 | 21.2% |
| Gift Card | 42 | 16.8% |
| Amazon Pay | 41 | 16.4% |

---

### 📌 Query 5 — Order Status Analysis

```sql
SELECT Status, COUNT(*) AS Total_orders
FROM amazon_sales
GROUP BY Status;
```

| Status | Count | Rate |
|---|---|---|
| ✅ Completed | 88 | 35.2% |
| ⏳ Pending | 85 | 34.0% |
| ❌ Cancelled | 77 | 30.8% |

> ⚠️ **Red Flag:** A 30.8% cancellation rate represents significant revenue leakage. The 34% pending rate suggests fulfilment pipeline bottlenecks.

---

### 📌 Query 6 — Regional Sales

```sql
SELECT CustomerLocation,
       SUM(TotalSales) AS Revenue
FROM amazon_sales
GROUP BY CustomerLocation
ORDER BY Revenue DESC;
```

| Rank | City | Revenue |
|---|---|---|
| 1 | Miami | $31,700 |
| 2 | Denver | $29,785 |
| 3 | Houston | $28,390 |
| 4 | Dallas | $27,145 |
| 5 | Seattle | $26,890 |
| ... | ... | ... |
| 10 | San Francisco | $16,195 |

---

### 📌 Query 7 — Customer Segmentation

```sql
SELECT CustomerName,
       SUM(TotalSales) AS Total_spending,
       CASE
           WHEN SUM(totalSales) >= 30000 THEN 'VIP'
           WHEN SUM(totalSales) >= 20000 THEN 'Premium'
           WHEN SUM(totalSales) >= 10000 THEN 'Regular'
           ELSE 'Low Value'
       END AS customer_segment
FROM amazon_sales
GROUP BY CustomerName;
```

---

### 📌 Query 8 — Moving Average Forecast (Window Function)

```sql
SELECT month,
       AVG(Monthly_sales) OVER(
           ORDER BY month
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS Moving_average
FROM (
    SELECT MONTH(OrderDate) AS month,
           SUM(TotalSales) AS Monthly_sales
    FROM amazon_sales
    GROUP BY month
) Sales_data;
```

---

### 📌 Query 9 — Growth Rate Forecasting (LAG Function)

```sql
WITH monthly_sales AS (
    SELECT MONTH(OrderDate) AS month,
           SUM(TotalSales) AS Revenue
    FROM amazon_sales
    GROUP BY month
)
SELECT month,
       Revenue,
       LAG(Revenue) OVER(ORDER BY month) AS Previous_month,
       ROUND(
           ((Revenue - LAG(Revenue) OVER(ORDER BY month))
           / LAG(Revenue) OVER(ORDER BY month)) * 100, 2
       ) AS growth_rate
FROM monthly_sales;
```

---

### 📌 Query 10 — A/B Conversion Rate Test

```sql
SELECT Test_group,
       COUNT(*) AS Total_orders,
       SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS Completed_orders,
       ROUND(
           (SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2
       ) AS Conversion_rate
FROM amazon_sales
GROUP BY Test_group;
```

---

## 📈 Power BI Dashboard

**File:** `amazon_sales_dashboard.pbix`

The dashboard contains **8 interactive visual panels** with cross-filter slicers enabling drill-down analysis across any dimension.

### Dashboard Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  SLICERS: Date Range | Category | Region | Order Status         │
├──────────┬──────────┬──────────┬───────────────────────────────┤
│  KPI:    │  KPI:    │  KPI:    │  KPI:                         │
│ $243,845 │  250     │  35.2%   │  $30%                         │
│ Revenue  │ Orders   │ Conv.Rate│  Avg Margin                   │
├──────────┴──────────┴──────────┴───────────────────────────────┤
│                                    │                            │
│  Revenue by Category (Donut)       │  Top Products (Bar Chart)  │
│                                    │                            │
├────────────────────────────────────┴────────────────────────────┤
│                                                                 │
│           Monthly Revenue Trend (Line Chart + Forecast)         │
│                                                                 │
├──────────────────────────┬──────────────────────────────────────┤
│  Regional Map            │  Payment Method Mix (Pie Chart)      │
│  (Filled Map Visual)     │                                      │
├──────────────────────────┼──────────────────────────────────────┤
│  Order Status Funnel     │  Customer Segment Matrix Table       │
└──────────────────────────┴──────────────────────────────────────┘
```

### Key DAX Measures

```dax
-- Total Revenue
Total Revenue = SUM(amazon_sales[TotalSales])

-- Average Order Value
Avg Order Value = DIVIDE([Total Revenue], COUNTROWS(amazon_sales))

-- Completion Rate
Completion Rate % =
    DIVIDE(
        COUNTROWS(FILTER(amazon_sales, amazon_sales[Status] = "Completed")),
        COUNTROWS(amazon_sales)
    ) * 100

-- Month-over-Month Growth
MoM Growth % =
    VAR CurrentMonth = [Total Revenue]
    VAR PrevMonth = CALCULATE([Total Revenue],
        DATEADD(amazon_sales[OrderDate], -1, MONTH))
    RETURN DIVIDE(CurrentMonth - PrevMonth, PrevMonth) * 100
```

---

## 🔍 Key Findings

### 💰 Revenue Findings

| Finding | Detail | Impact |
|---|---|---|
| **Electronics dominates** | 53.3% of all revenue ($129,950) | High dependency risk — diversify |
| **Top 3 products = 76% revenue** | Refrigerator, Laptop, Smartphone | Strong SKU concentration |
| **Miami is top city** | $31,700 vs San Francisco's $16,195 | 2× regional disparity |
| **PayPal leads payments** | 24% of all transactions | Optimise PayPal checkout UX |

### ⚠️ Risk Findings

| Finding | Detail | Severity |
|---|---|---|
| **30.8% cancellation rate** | 77 of 250 orders cancelled | 🔴 HIGH |
| **34% orders pending** | 85 orders unresolved | 🟡 MEDIUM |
| **Running Shoes low stock** | Avg inventory: 210 units | 🟡 MEDIUM |
| **Laptop low stock** | Avg 225 units — high revenue risk | 🔴 HIGH |

### 📅 Seasonal Findings

| Month | Revenue | MoM Growth |
|---|---|---|
| March | $9,420 | — |
| April | $28,660 | +204% ⬆️ |
| May | $36,910 | +29% ⬆️ |
| June | $28,360 | -23% ⬇️ |
| July | $36,605 | +29% ⬆️ |
| August | $35,445 | -3% ➡️ |
| September | $22,740 | -36% ⬇️ |
| October | $31,140 | +37% ⬆️ |
| November | $14,565 | -53% ⬇️ |

> **3-Month Moving Average Band: $22,000 – $33,000** — use this as the baseline for monthly revenue planning.

---

## 👥 Customer Segmentation

Customers were segmented by **lifetime spend** using a CASE-WHEN classification:

```
┌─────────────────────────────────────────────────────┐
│                 CUSTOMER PYRAMID                     │
│                                                     │
│              ▲  VIP  ▲                              │
│           ≥ $30,000   2 customers                   │
│         Olivia Wilson · Jane Smith                   │
│                                                     │
│          ████  PREMIUM  ████                        │
│       $20,000 – $29,999   5 customers               │
│   Emma Clark · John Doe · Emily Johnson             │
│       David Lee · Michael Brown                     │
│                                                     │
│      ██████  REGULAR  ██████                        │
│      $10,000 – $19,999   3 customers                │
│  Daniel Harris · Chris White · Sophia Miller        │
│                                                     │
│    ████████  LOW VALUE  ████████                    │
│            < $10,000   0 customers                  │
└─────────────────────────────────────────────────────┘
```

| Segment | Threshold | Count | Recommended Action |
|---|---|---|---|
| 🏆 VIP | ≥ $30,000 | 2 | Exclusive loyalty programme, personal account manager |
| 💎 Premium | ≥ $20,000 | 5 | Priority shipping, early-access promotions |
| ✅ Regular | ≥ $10,000 | 3 | Upsell bundles, email re-engagement campaigns |
| 📉 Low Value | < $10,000 | 0 | Win-back discounts, frequency incentives |

> **Notable:** 100% repeat-purchase rate — all 10 customers placed multiple orders. This indicates strong brand loyalty within the existing base. Expanding the customer acquisition funnel is the next growth lever.

---

## 📉 Sales Forecasting

Two SQL-based forecasting methods were implemented:

### Method 1 — 3-Month Moving Average
Uses a **window function** (`ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`) to smooth short-term volatility and identify the stable revenue trend band.

```
Month        Revenue    Moving Avg
─────────    ───────    ──────────
Mar            9,420       9,420
Apr           28,660      19,040
May           36,910      24,997    ← Trend establishing
Jun           28,360      31,310
Jul           36,605      33,958    ← Peak stable band
Aug           35,445      33,470
Sep           22,740      31,597
Oct           31,140      29,775
Nov           14,565      22,815
```

### Method 2 — Month-over-Month Growth Rate
Uses the `LAG()` window function to calculate percentage change between consecutive months and identify momentum direction.

**Key forecasting insight:** The 3-month moving average stabilises in the **$22,000 – $34,000** band. Projected December revenue: **$26,000 – $30,000** based on trailing trend.

---

## 📦 Inventory Analytics

Stock levels were simulated using `FLOOR(RAND() * 500)` and analysed by average stock per product:

```sql
SELECT Product,
       ROUND(AVG(Inventory_stock), 0) AS Avg_inventory
FROM amazon_sales
GROUP BY Product
ORDER BY Avg_inventory;
```

### Inventory Risk Classification

| Risk | Threshold | Products | Action |
|---|---|---|---|
| 🔴 HIGH | < 250 units | Running Shoes (210), Laptop (225) | Immediate reorder |
| 🟡 MEDIUM | 250–270 units | Jeans (240), Refrigerator (241), T-Shirt (244) | Weekly monitoring |
| 🟢 LOW | > 270 units | Washing Machine (278), Smartphone (284), Smartwatch (294), Headphones (302) | Quarterly review |

> ⚠️ **Critical Alert:** Laptops score HIGH risk despite generating $58,400 in revenue (2nd highest). Any stockout event would directly impact the second-largest revenue stream.

---

## 🧪 A/B Testing

A randomised experiment was designed to measure checkout conversion rate differences between two user experience variants.

### Experimental Design

```
Population: 250 orders
Assignment: RAND() < 0.5 → Group A (Control) | else → Group B (Variant)
Metric: Conversion Rate = Completed Orders / Total Orders
```

### Results

| Metric | Group A (Control) | Group B (Variant) | Delta |
|---|---|---|---|
| Total Orders | 118 | 132 | +14 |
| Completed Orders | 41 | 47 | +6 |
| **Conversion Rate** | **34.75%** | **35.61%** | **+0.86 pp** |
| Total Revenue | $97,320 | $146,525 | +$49,205 |
| Avg Order Value | $824.75 | $1,110.04 | +$285.29 |

### Statistical Assessment

```
Current Sample Size:  118 (A) vs 132 (B)
Recommended Minimum: 400+ per group for 95% confidence
Current Status:      ⚠️ NOT YET STATISTICALLY SIGNIFICANT
Recommendation:      Continue experiment — do not deploy variant prematurely
```

> **Hypothesis for AOV gap:** Group B's $285 higher average order value suggests the variant may influence selection of higher-ticket items (Laptops, Refrigerators). Investigate whether product recommendation placement differs between groups.

---

## 💡 Business Recommendations

### 🚀 Revenue Growth
- **Double down on Electronics + Home Appliances** — together they represent 96.3% of revenue. A 5% conversion improvement in Electronics alone yields ~$6,500 incremental profit.
- **Develop the long-tail** — Footwear, Clothing, and Books generate only 3.7% of revenue. Introduce bundling or cross-sell incentives.
- **Activate underperforming regions** — San Francisco ($16,195) and Los Angeles ($17,820) lag Miami ($31,700) significantly despite comparable population bases.

### 👥 Customer Retention
- **Launch a VIP programme immediately** for Olivia Wilson ($36,170) and Jane Smith ($31,185) — personalised outreach and exclusive benefits before a competitor captures them.
- **Convert Premium → VIP** — target Emma Clark ($29,700), just $300 shy of VIP threshold, with a strategic offer.
- **Fix the cancellation pipeline** — investigate the 77 cancelled orders. Exit survey data would identify whether cancellations are price-driven, fulfilment-driven, or UX-driven.

### 📦 Inventory Management
- **Set automated low-stock alerts** at 250 units for Running Shoes and Laptops.
- **Buffer stock policy for Laptops** — maintain a minimum safety stock of 300 units given $58,400 revenue dependence.
- **Adopt JIT ordering for Books** — low velocity, low revenue; reduce carrying cost.

### 📊 Analytics Maturity
- **Scale the A/B experiment** to 400+ orders per group before deployment decisions.
- **Build real-time Power BI alerts** for cancellation rate spikes (threshold: >35% in any 7-day window).
- **Implement cohort analysis** to track customer lifetime value evolution over time as the dataset grows.

---

## 📁 Project Structure

```
amazon-sales-analytics/
│
├── 📄 README.md                        ← You are here
│
├── 📊 data/
│   └── amazon_sales_final.csv          ← Source dataset (250 rows, 14 columns)
│
├── 🗄️ sql/
│   └── AMAZON_PROJECT.sql              ← All 15+ SQL queries (MySQL)
│
├── 📈 dashboard/
│   └── amazon_sales_dashboard.pbix     ← Power BI interactive dashboard
│
└── 📝 report/
    └── Amazon_Sales_Analytics_Report.docx  ← Full project report
```

---

## 🛠️ Tools & Technologies

| Tool | Version | Purpose |
|---|---|---|
| **MySQL** | 8.0+ | Relational database, all SQL query engineering |
| **Power BI Desktop** | Latest | Interactive dashboard & DAX measures |
| **Microsoft Excel** | 2019+ | Data validation, CSV inspection |
| **Python / Pandas** | 3.11+ | Data profiling and quality checks |

---

## ▶️ How to Run

### 1. SQL Analysis (MySQL)

```bash
# Connect to MySQL
mysql -u root -p

# Run the full project script
source /path/to/AMAZON_PROJECT.sql
```

> Make sure to import `amazon_sales_final.csv` into your `walmart_sales` database before running the script. Use MySQL Workbench's Table Data Import Wizard or the `LOAD DATA INFILE` command.

### 2. Power BI Dashboard

1. Download and install [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free)
2. Open `amazon_sales_dashboard.pbix`
3. If prompted, update the data source path to point to your local `amazon_sales_final.csv`
4. Click **Refresh** to reload the data

### 3. Reproducing the Data Engineering Steps

The following columns were engineered and must be created before running analytics queries:

```sql
-- Profit column (30% margin)
ALTER TABLE amazon_sales ADD COLUMN Profit INT;
UPDATE amazon_sales SET Profit = TotalSales * 0.30;

-- Inventory simulation
ALTER TABLE amazon_sales ADD COLUMN Inventory_stock INT;
UPDATE amazon_sales SET Inventory_stock = FLOOR(RAND() * 500);

-- A/B test group assignment
ALTER TABLE amazon_sales ADD COLUMN Test_group VARCHAR(10);
UPDATE amazon_sales SET Test_group = CASE WHEN RAND() < 0.5 THEN 'A' ELSE 'B' END;
```

---

## 📬 Connect

If you found this project useful, feel free to ⭐ star the repository and connect!

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com)
[![Portfolio](https://img.shields.io/badge/Portfolio-Visit-FF6600?style=for-the-badge&logo=firefox&logoColor=white)](https://yourportfolio.com)

*Built with 💻 SQL · Power BI · Data Storytelling*

</div>
