-- Find users with at least one funded savings and one funded investment plan
-- and return their ID, name, count of each plan, and total deposits

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 THEN s.plan_id 
    END) AS savings_count,
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 THEN s.plan_id 
    END) AS investment_count,
    ROUND(SUM(CASE 
        WHEN s.confirmed_amount > 0 THEN s.confirmed_amount 
        ELSE 0 
    END) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN savings_savingsaccount s ON s.owner_id = u.id
JOIN plans_plan p ON s.plan_id = p.id
GROUP BY u.id, u.first_name, u.last_name
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;
