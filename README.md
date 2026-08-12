# 📊 RFM Customer Segmentation & Value Analysis

An end-to-end data analytics project leveraging **SQL** to segment an e-commerce customer base using **Recency, Frequency, and Monetary (RFM) modeling**, transforming raw transactional data into targeted marketing strategies.

---

## 🎯 Project Overview

In retail and e-commerce, treating all customers equally can lead to wasted marketing spend and lower retention.

For this project, I engineered a relational data pipeline in **SQL (SQLite)** to:

* Analyze historical purchasing behavior
* Score customers using quintile distributions
* Classify customers into actionable behavioral segments
* Visualize the resulting customer segments

Example segments include:

* Champions
* At-Risk
* Hibernating

The goal of this analysis is to provide marketing teams with data-driven insights to optimize retention campaigns, maximize customer lifetime value (LTV), and target win-back strategies efficiently.

---

## 🗃️ Dataset

**Source:** Online Retail Dataset — UCI Machine Learning Repository via Kaggle

**Scope:** Transaction logs from a UK-based online retail company spanning 2010–2011.

### Key Attributes

* `Invoice Number`
* `Stock Code`
* `Description`
* `Quantity`
* `Invoice Date`
* `Unit Price`
* `Customer ID`
* `Country`

---

## 🛠️ Technologies

`SQL` `SQLite` `Power BI` `RFM Analysis` `Window Functions` `Data Analysis` `Data Visualization`

---

## 🔄 Analysis Workflow

The project transforms transactional customer data into RFM-based customer segments and visualizes the resulting analysis in Power BI.

```text
┌──────────────────────┐
│ Transactional Data   │
│ Customer / Orders    │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│     SQL Cleaning     │
│  & Data Preparation  │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│     RFM Analysis     │
│                      │
│ Recency              │
│ Frequency            │
│ Monetary Value       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Customer Segmentation│
│      NTILE()         │
│   Window Functions   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│      Power BI        │
│ Dashboard & Insights │
└──────────────────────┘
```

### Workflow

1. **Prepare** — Clean and organize transactional customer data using SQL.
2. **Calculate** — Determine Recency, Frequency, and Monetary values for each customer.
3. **Score** — Use SQL window functions to assign RFM scores.
4. **Segment** — Group customers according to their RFM characteristics.
5. **Visualize** — Present the resulting segments and business insights in Power BI.

---

## 🧮 SQL Methodology

The SQL script is structured as a modular, top-to-bottom data transformation pipeline using views to keep computations clean, reproducible, and easy to audit.

### 1. Data Staging & Cleaning — `cleaned_transactions`

* Filtered out null `CustomerID`s to ensure accurate individual tracking.
* Removed anomalous rows, including cancelled orders with negative quantities and erroneous pricing data.
* Calculated total sales per line item using:

```text
Quantity × UnitPrice
```

### 2. Base RFM Aggregation — `base_rfm`

For each customer:

* **Recency:** Number of days between the customer's last purchase and the fixed snapshot date (`2011-12-10`).
* **Frequency:** Total number of unique invoices.
* **Monetary:** Total customer spend.

### 3. Quintile Scoring — `scored_rfm`

The `NTILE(5)` window function partitions customers into five scoring buckets.

```sql
NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
```

The sorting logic accounts for the meaning of each metric:

* **Recency:** Ascending — fewer days since purchase produces a higher score.
* **Frequency:** Descending — more purchases produce a higher score.
* **Monetary:** Descending — higher spending produces a higher score.

### 4. Behavioral Segmentation — `final_customer_segments`

Conditional `CASE` logic combines the individual RFM scores into meaningful business tiers.

---

## 🖼️ Dashboard Preview

![RFM Customer Segmentation Dashboard](dashboard.png)

---

## 💡 Key Findings & Business Insights

### The Pareto Principle in Action

"Champions" — customers with high recency, frequency, and monetary scores — represent a core fraction of the active customer base while driving a disproportionately high percentage of total revenue.

This supports the potential value of targeted VIP loyalty programs.

### The "At-Risk" Segment

The analysis identifies high-value historical buyers who have not made a purchase recently.

This provides marketing teams with a specific segment to target with win-back strategies.

### Dormant Churn

A significant cluster falls into the "Hibernating / Lost" tier, indicating that intervention may be needed earlier in the customer journey to prevent customer drop-off.

---

## 💡 What This Demonstrates

* SQL data cleaning and transformation
* Relational data analysis
* Common Table Expressions and SQL views
* SQL window functions
* `NTILE()` quintile scoring
* RFM analytical methodology
* Customer segmentation
* Quantitative reasoning
* Business-oriented data analysis
* Power BI dashboard development
* Communicating analytical results visually
* Translating technical analysis into actionable business insights

---

## 📂 Repository Structure

```text
RFM_Segmentation/
├── dashboard.png             # Dashboard visualization preview
├── README.md                 # Project documentation
├── rfm_analysis.sql          # Reproducible SQL analysis
├── rfm_dashboard.pbix       # Power BI dashboard
└── scored_rfm_preview.csv   # Sample export of final segment distributions
```

---

## 🚀 How to Run This Project

### 1. Clone the repository

```bash
git clone https://github.com/ZaneRoberts/RFM_Segmentation.git
cd RFM_Segmentation
```

### 2. Obtain the dataset

Download the **Online Retail Dataset** from Kaggle and import it into your SQL environment, such as DBeaver or SQLite.

The source data should be available as a table named:

```text
online_retail
```

### 3. Run the SQL analysis

Open:

```text
rfm_analysis.sql
```

in your SQL environment.

Execute the script from top to bottom to:

1. Clean the transactional data.
2. Build the analytical views.
3. Calculate RFM metrics.
4. Assign RFM scores.
5. Generate customer segments.

Skip the `DROP` statements if they are not needed for your environment.

---

## 📌 Project Purpose

This project demonstrates how raw transactional data can be transformed into a structured customer segmentation analysis:

**Transactional Data → SQL Cleaning → RFM Analysis → Customer Segmentation → Power BI Insights**

The objective is to combine technical SQL skills with business-oriented analytical reasoning to identify customer behaviors that can support targeted marketing and retention strategies.
