-- Active savings or investment plans with no inflow transaction in the last 365 days

WITH savings_last_tx AS (
    SELECT 
        s.plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1
    GROUP BY s.plan_id, s.owner_id
),
investment_last_tx AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        'Investment' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM plans_plan p
    JOIN savings_savingsaccount s ON s.plan_id = p.id
    WHERE p.is_a_fund = 1
    GROUP BY p.id, p.owner_id
),
combined AS (
    SELECT * FROM savings_last_tx
    UNION
    SELECT * FROM investment_last_tx
)

SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM combined
WHERE last_transaction_date IS NOT NULL
  AND DATEDIFF(CURDATE(), last_transaction_date) > 365;
