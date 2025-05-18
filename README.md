
# Data Analytics SQL Assessment

## Overview
This repository contains solutions to four SQL-based analytical tasks. Each query is designed to extract insights from savings and investment data, aligned with realistic business needs like cross-sell targeting, churn alerts, and customer value estimation.

---

## Per-Question Explanations

### Assessment_Q1.sql – High-Value Customers with Multiple Products
**Approach:**
- Used two CTEs to isolate funded savings and funded investment plans:
  - Savings are detected via `savings_savingsaccount.confirmed_amount > 0` and linked to plans where `is_regular_savings = 1`
  - Investments are found in `plans_plan` where `is_a_fund = 1` and `amount > 0`
- Joined those with users to count unique plans and calculate combined inflow value in naira.
- Final result is sorted by total deposits using a safe `IFNULL + ROUND` pattern.

### Assessment_Q2.sql – Transaction Frequency Analysis
**Approach:**
- Aggregated savings transaction counts per user and calculated transaction activity span in months.
- Derived the average number of transactions per month for each customer.
- Categorized users into:
  - High Frequency (≥10/month)
  - Medium Frequency (3–9/month)
  - Low Frequency (≤2/month)
- Aggregated user counts and average frequency per segment.

### Assessment_Q3.sql – Account Inactivity Alert
**Approach:**
- Queried both savings accounts and investment plans.
- For savings: used `MAX(created_on)` from `savings_savingsaccount`
- For investments: used `MAX(created_on)` from `plans_plan` where `is_a_fund = 1 AND amount > 0`
- Calculated days since last activity and filtered for accounts with inactivity over 365 days.

### Assessment_Q4.sql – Customer Lifetime Value (CLV) Estimation
**Approach:**
- Tenure in months is derived using `TIMESTAMPDIFF` from user signup date.
- Total transaction count pulled from `savings_savingsaccount`.
- Calculated CLV using the formula:

  ```
  CLV = (total_transactions / tenure) * 12 * (0.1% of avg transaction value)
  ```

- Converted transaction value from kobo to naira and rounded it up for clarity.

---

## Challenges

### Questions 1 and 4 Were the Most Intricate
- **Q1 Complexity:** Required a precise understanding of how savings are tracked separately from plan metadata. Initially, attempting to pull all values from `plans_plan` led to errors. Only after integrating both savings and plan tables and interpreting `is_regular_savings` and `is_a_fund` correctly did it align.
- **Q4 Complexity:** The CLV model needed accurate handling of division (tenure could be zero) and a good understanding of inflow normalization (from kobo). Building that calculation without rounding errors was tricky.

To overcome these, I revisited schema diagrams, consulted SQL tutorials (SQLBolt, LeetCode), and validated logic by comparing intermediate aggregates step-by-step.


