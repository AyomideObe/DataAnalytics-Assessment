-- Identifying accounts (savings or investment) with no transaction in the last 365 days

-- Savings accounts
SELECT 
    savings.plan_id AS plan_id,
    savings.owner_id,
    'Savings' AS type,
    MAX(savings.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(savings.created_on)) AS inactivity_days
FROM savings_savingsaccount AS savings
GROUP BY savings.plan_id, savings.owner_id
HAVING inactivity_days > 365

UNION ALL

-- Investment plans
SELECT 
    plan.id AS plan_id,
    plan.owner_id,
    'Investment' AS type,
    MAX(plan.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(plan.created_on)) AS inactivity_days
FROM plans_plan AS plan
WHERE plan.is_a_fund = 1 AND plan.amount > 0
GROUP BY plan.id, plan.owner_id
HAVING inactivity_days > 365;
