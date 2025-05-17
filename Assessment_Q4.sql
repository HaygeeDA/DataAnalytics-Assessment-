-- Estimate CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction (0.1%)

WITH tx_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) / 100.0 AS total_value  -- Convert from kobo to naira
    FROM savings_savingsaccount
    GROUP BY owner_id
),
user_tenure AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT 
        u.customer_id,
        u.name,
        u.tenure_months,
        t.total_transactions,
        ROUND(((t.total_transactions / NULLIF(u.tenure_months, 0)) * 12 * (t.total_value * 0.001)), 2) AS estimated_clv
    FROM user_tenure u
    JOIN tx_summary t ON u.customer_id = t.owner_id
)

SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
