-- Customers with at least one funded regular savings plan
-- and at least one funded investment plan

WITH savings_customers AS (
    SELECT 
        s.owner_id,
        COUNT(DISTINCT s.plan_id) AS savings_count,
        SUM(s.confirmed_amount) AS total_deposits
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_regular_savings = 1
      AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),
investment_customers AS (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),
qualified_customers AS (
    SELECT 
        sc.owner_id,
        sc.savings_count,
        ic.investment_count,
        sc.total_deposits
    FROM savings_customers sc
    JOIN investment_customers ic ON sc.owner_id = ic.owner_id
)

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    qc.savings_count,
    qc.investment_count,
    ROUND(qc.total_deposits / 100.0, 2) AS total_deposits
FROM qualified_customers qc
JOIN users_customuser u ON u.id = qc.owner_id
ORDER BY total_deposits DESC;

