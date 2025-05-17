-- Transaction Frequency Analysis
-- Average number of savings transactions per customer per month, and frequency categories

WITH customer_tx_summary AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        DATEDIFF(MAX(transaction_date), MIN(transaction_date)) / 30.0 AS active_months
    FROM savings_savingsaccount
    WHERE transaction_date IS NOT NULL
    GROUP BY owner_id
), categorized AS (
    SELECT 
        owner_id,
        CASE 
            WHEN active_months < 1 THEN total_transactions
            ELSE total_transactions / active_months
        END AS avg_tx_per_month
    FROM customer_tx_summary
), labels AS (
    SELECT 
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM categorized
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM labels
GROUP BY frequency_category;
