-- Classifying customers based on transaction frequency using confirmed inflows in savings_savingsaccount

WITH transaction_data AS (
    SELECT
        savings.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(savings.created_on), MAX(savings.created_on)) + 1 AS months_active
    FROM savings_savingsaccount AS savings
    GROUP BY savings.owner_id
),
customer_frequency AS (
    SELECT
        trans.owner_id,
        trans.total_transactions,
        trans.months_active,
        ROUND(trans.total_transactions / trans.months_active, 2) AS avg_txn_per_month,
        CASE
            WHEN trans.total_transactions / trans.months_active >= 10 THEN 'High Frequency'
            WHEN trans.total_transactions / trans.months_active >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM transaction_data AS trans
)

SELECT
    freq.frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(freq.avg_txn_per_month), 2) AS avg_transactions_per_month
FROM customer_frequency AS freq
GROUP BY freq.frequency_category
ORDER BY 
    FIELD(freq.frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency'); -- this is used to rank the output in the desired format
