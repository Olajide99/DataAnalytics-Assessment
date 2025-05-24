-- Q2: Transaction Frequency Analysis

WITH transactions_per_user AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions
    FROM savings_savingsaccount
    GROUP BY owner_id
),
monthly_avg AS (
    SELECT 
        owner_id,
        total_transactions,
        ROUND(total_transactions / 12.0, 2) AS avg_transactions_per_month
    FROM transactions_per_user
),
categorized AS (
    SELECT 
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_transactions_per_month
    FROM monthly_avg
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category;

