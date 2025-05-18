-- Identifying users who have at least one funded savings plan and one funded investment plan
-- Becuase multiple tables are being joined, the use of the WITH method making it look clean

WITH savings_funded AS (
    SELECT DISTINCT savings.plan_id, savings.owner_id
    FROM savings_savingsaccount AS savings
    JOIN plans_plan AS plan ON savings.plan_id = plan.id
    WHERE savings.confirmed_amount > 0 AND plan.is_regular_savings = 1
),
investment_funded AS (
    SELECT DISTINCT plan.id AS plan_id, plan.owner_id
    FROM plans_plan AS plan
    WHERE plan.is_a_fund = 1 AND plan.amount > 0
)

SELECT 
    user.id AS owner_id,
    CONCAT(user.first_name, ' ', user.last_name) AS name,
    COUNT(DISTINCT savings_funded.plan_id) AS savings_count,
    COUNT(DISTINCT investment_funded.plan_id) AS investment_count,
    ROUND( -- the round function is used to round off to the desired whole number, in this case 2
        (IFNULL(SUM(savings.confirmed_amount), 0) + IFNULL(SUM(plan.amount), 0)) / 100, -- IFNULL is used to ensure NULL values does not breake the code, there defaulting it to 0
        2
    ) AS total_deposits 
FROM users_customuser AS user
LEFT JOIN savings_funded ON user.id = savings_funded.owner_id
LEFT JOIN savings_savingsaccount AS savings ON savings.plan_id = savings_funded.plan_id
LEFT JOIN investment_funded ON user.id = investment_funded.owner_id
LEFT JOIN plans_plan AS plan ON investment_funded.plan_id = plan.id
GROUP BY user.id, name
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;
