# DataAnalytics-Assessment

## Overview

This repository contains solutions to a SQL proficiency assessment aimed at evaluating skills in data retrieval, aggregation, joins, subqueries, and analysis using real-world scenarios. The data comes from customer profiles, savings and investment plans, and transaction records.

---

##  Question 1: High-Value Customers with Multiple Products

###  Scenario
Identify customers who have both a **funded regular savings plan** and a **funded investment plan**. This helps the business identify cross-sell opportunities.

###  Query Summary
- Used two CTEs: one for customers with funded regular savings, one for customers with investment plans.
- Joined these sets to find customers who appear in both.
- Fetched customer ID, full name, number of savings and investment products, and total savings deposits.
- Sorted by total deposit amount (converted from kobo to naira).

###  Output Columns
- `owner_id`, `name`, `savings_count`, `investment_count`, `total_deposits`

---

##  Question 2: Transaction Frequency Analysis

###  Scenario
Classify customers based on how frequently they perform transactions, to enable behavioral segmentation.

###  Query Summary
- Counted total transactions and computed active months per customer.
- Calculated average transactions per month.
- Categorized each customer into:
  - "High Frequency" (≥10/month)
  - "Medium Frequency" (3–9/month)
  - "Low Frequency" (≤2/month)
- Aggregated customer counts and average transaction frequency by category.

###  Output Columns
- `frequency_category`, `customer_count`, `avg_transactions_per_month`

---

##  Question 3: Account Inactivity Alert

###  Scenario
Operations team wants to flag **savings or investment accounts** with **no inflows for more than 365 days**.

###  Query Summary
- Identified last transaction dates for both savings and investment plans.
- Filtered to accounts with the last transaction date older than 1 year.
- Combined savings and investment results using `UNION ALL`.

###  Output Columns
- `plan_id`, `owner_id`, `type`, `last_transaction_date`, `inactivity_days`

---

##  Question 4: Customer Lifetime Value (CLV) Estimation

###  Scenario
Estimate a simplified CLV per customer using:
- Account tenure
- Transaction volume
- Average profit per transaction = 0.1% of transaction value

###  Query Summary
- Calculated tenure in months since `date_joined`
- Counted total transactions and summed confirmed deposit values
- Applied formula:  
  **CLV = (total_tx / tenure_months) × 12 × (avg_profit_per_transaction)**
- Rounded and sorted by estimated CLV descending

###  Output Columns
- `customer_id`, `name`, `tenure_months`, `total_transactions`, `estimated_clv`

---

##  Challenges Encountered

### 1. Missing Fields in Plan Table
Initially referenced a non-existent `confirmed_amount` column in `plans_plan`. Fixed by using only `confirmed_amount` from `savings_savingsaccount`.

### 2. Ambiguity in Account Types
Clarified the difference between:
- Regular savings plans (`is_regular_savings = 1`)
- Investment plans (`is_a_fund = 1`)

### 3. Kobo-to-Naira Conversion
All amount values are stored in kobo. All monetary outputs were divided by 100.0 and rounded for clarity.

### 4. Handling Division by Zero
Used `NULLIF(tenure_months, 0)` to avoid division-by-zero errors in CLV calculation.



