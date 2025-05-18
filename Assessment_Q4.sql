-- Calculating customers lifetime value using tenure and transaction volume

SELECT 
    user.id AS customer_id,
    CONCAT(user.first_name, ' ', user.last_name) AS name,
    TIMESTAMPDIFF(MONTH, user.date_joined, CURDATE()) AS tenure_months,
    COUNT(savings.id) AS total_transactions,
    ROUND( 
        (COUNT(savings.id) / TIMESTAMPDIFF(MONTH, user.date_joined, CURDATE())) 
        * 12 
        * 0.001 
        * (AVG(savings.confirmed_amount) / 100), 
        2
    ) AS estimated_clv
FROM users_customuser AS user
LEFT JOIN savings_savingsaccount AS savings 
    ON user.id = savings.owner_id
GROUP BY user.id, name, tenure_months
HAVING tenure_months > 0
ORDER BY estimated_clv DESC; -- this is used to print the result in decending order
