-- SQL queries on the 115 kWp rooftop database (solar_project.db).
-- In DB Browser for SQLite: Execute SQL tab, paste one query, then Execute all (Ctrl+Return or F5).

-- 1. See everything in a table
SELECT *
FROM bom;

-- 2. The five most expensive lines
SELECT item, budget_pkr
FROM bom
ORDER BY budget_pkr DESC
LIMIT 5;

-- 3. Only the mounting items
SELECT item, qty, unit, budget_pkr
FROM bom
WHERE category = 'Mounting';

-- 4. Budget by category
SELECT category,
       COUNT(*)        AS lines,
       SUM(budget_pkr) AS budget_pkr
FROM bom
GROUP BY category
ORDER BY budget_pkr DESC;

-- 5. How many lines are at each procurement status
SELECT status, COUNT(*) AS lines
FROM procurement
GROUP BY status
ORDER BY lines DESC;

-- 6. Items that need action, with their names (a JOIN)
SELECT b.item, b.supplier, p.order_by, p.status, p.days_in_hand
FROM procurement AS p
JOIN bom AS b ON b.line = p.line
WHERE p.status IN ('Late delivery', 'Order overdue', 'Order due')
ORDER BY p.days_in_hand;

-- 7. Lines that are over budget (a calculated column)
SELECT item, budget_pkr, forecast_pkr,
       forecast_pkr - budget_pkr AS over_by_pkr
FROM bom
WHERE forecast_pkr > budget_pkr
ORDER BY over_by_pkr DESC;
