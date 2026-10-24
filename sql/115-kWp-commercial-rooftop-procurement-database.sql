-- SQL project: 115 kWp commercial rooftop, Islamabad (indicative PKR rates).
-- Two tables, bom and procurement, taken from the Excel project tracker, then seven queries.
-- Written for SQLite and run in DB Browser for SQLite. Run Parts 1 and 2 once, then run each query on its own.

-- Part 1: create the tables
-- (The notes sit above each table rather than inside it, so the saved table definitions stay clean.)

-- bom: one row for each line of the bill of materials.
--   line          the BOM line number, unique for each item (the primary key)
--   budget_pkr    qty x unit rate
--   forecast_pkr  the purchase order value if there is one, otherwise the budget
--   lead_days     working days from order to delivery
--   needed_for    the programme milestone the item is needed for
CREATE TABLE bom (
  line          INTEGER PRIMARY KEY,
  item          TEXT NOT NULL,
  category      TEXT NOT NULL,
  unit          TEXT,
  qty           INTEGER,
  unit_rate_pkr INTEGER,
  budget_pkr    INTEGER,
  forecast_pkr  INTEGER,
  supplier      TEXT,
  lead_days     INTEGER,
  needed_for    TEXT
);

-- procurement: one row for each BOM line, linked to bom by the line number (a foreign key).
--   dates are stored as text in the form YYYY-MM-DD, so they sort in date order
--   po_date       empty (NULL) if there is no purchase order yet
--   days_in_hand  with an order: days from expected delivery to the date the item is needed on site;
--                 with no order yet: days left until the order-by date (status date 21 Sep 2026).
--                 Negative means late.
CREATE TABLE procurement (
  line              INTEGER PRIMARY KEY REFERENCES bom(line),
  required_on_site  TEXT,
  order_by          TEXT,
  po_date           TEXT,
  expected_delivery TEXT,
  delivered         TEXT,
  days_in_hand      INTEGER,
  status            TEXT
);

-- Part 2: load the data
INSERT INTO bom VALUES (1, 'PV module, Jinko JKM580N-72HL4-V 580 W', 'Modules', 'pcs', 198, 15660, 3100680, 3100680, 'Module distributor', 8, 'Module installation start');
INSERT INTO bom VALUES (2, 'Inverter, Huawei SUN2000-100KTL-M2', 'Inverter and monitoring', 'pcs', 1, 1450000, 1450000, 1450000, 'Inverter distributor', 12, 'Electrical installation start');
INSERT INTO bom VALUES (3, 'Monitoring dongle (4G)', 'Inverter and monitoring', 'pcs', 1, 42000, 42000, 42000, 'Inverter distributor', 12, 'Electrical installation start');
INSERT INTO bom VALUES (4, 'Mounting rail, 4.2 m', 'Mounting', 'pcs', 110, 4800, 528000, 559700, 'Mounting supplier', 7, 'Mounting installation start');
INSERT INTO bom VALUES (5, 'Module clamps (mid and end)', 'Mounting', 'pcs', 418, 220, 91960, 97500, 'Mounting supplier', 7, 'Mounting installation start');
INSERT INTO bom VALUES (6, 'Roof attachment (L-foot with fixings)', 'Mounting', 'pcs', 418, 450, 188100, 199400, 'Mounting supplier', 7, 'Mounting installation start');
INSERT INTO bom VALUES (7, 'DC solar cable 6 mm2 (red and black)', 'DC electrical', 'm', 968, 260, 251680, 251680, 'Electrical wholesaler', 4, 'Module installation start');
INSERT INTO bom VALUES (8, 'MC4 connector pair', 'DC electrical', 'pairs', 25, 350, 8750, 8750, 'Electrical wholesaler', 4, 'Module installation start');
INSERT INTO bom VALUES (9, 'Cable tray, galvanised', 'DC electrical', 'm', 60, 1800, 108000, 108000, 'Electrical wholesaler', 5, 'Electrical installation start');
INSERT INTO bom VALUES (10, 'AC cable, 4-core 70 mm2 Cu armoured', 'AC electrical', 'm', 33, 8500, 280500, 269300, 'Electrical wholesaler', 6, 'Electrical installation start');
INSERT INTO bom VALUES (11, 'MCCB 4-pole 200 A', 'AC electrical', 'pcs', 1, 85000, 85000, 85000, 'Electrical wholesaler', 7, 'Electrical installation start');
INSERT INTO bom VALUES (12, 'Surge protection device, Type 2', 'AC electrical', 'pcs', 1, 28000, 28000, 28000, 'Electrical wholesaler', 7, 'Electrical installation start');
INSERT INTO bom VALUES (13, 'Earthing (2 earth pits and 60 m cable)', 'Earthing', 'lot', 1, 104000, 104000, 104000, 'Electrical wholesaler', 3, 'Mounting installation start');
INSERT INTO bom VALUES (14, 'Installation crew', 'Labour and services', 'crew-days', 5, 30000, 150000, 150000, 'Installation subcontractor', 5, 'Mounting installation start');
INSERT INTO bom VALUES (15, 'Electrical crew', 'Labour and services', 'crew-days', 4, 35000, 140000, 140000, 'Installation subcontractor', 5, 'Electrical installation start');
INSERT INTO bom VALUES (16, 'Transport and lifting', 'Labour and services', 'lot', 1, 150000, 150000, 150000, 'Logistics provider', 3, 'Mobilisation');
INSERT INTO bom VALUES (17, 'Access and safety equipment', 'Labour and services', 'lot', 1, 80000, 80000, 80000, 'In-house', 5, 'Mobilisation');
INSERT INTO bom VALUES (18, 'Testing and commissioning', 'Labour and services', 'lot', 1, 120000, 120000, 120000, 'In-house', 5, 'Testing and commissioning');
INSERT INTO bom VALUES (19, 'Net-metering application and meter', 'Approvals', 'lot', 1, 200000, 200000, 200000, 'DISCO', 35, 'Net-metering energisation');

INSERT INTO procurement VALUES (1, '2026-09-29', '2026-09-16', '2026-09-15', '2026-09-24', NULL, 5, 'On order');
INSERT INTO procurement VALUES (2, '2026-10-01', '2026-09-14', '2026-09-18', '2026-10-02', NULL, -1, 'Late delivery');
INSERT INTO procurement VALUES (3, '2026-10-01', '2026-09-14', '2026-09-18', '2026-10-02', NULL, -1, 'Late delivery');
INSERT INTO procurement VALUES (4, '2026-09-24', '2026-09-12', '2026-09-11', '2026-09-19', '2026-09-19', 5, 'Delivered');
INSERT INTO procurement VALUES (5, '2026-09-24', '2026-09-12', '2026-09-11', '2026-09-19', '2026-09-19', 5, 'Delivered');
INSERT INTO procurement VALUES (6, '2026-09-24', '2026-09-12', '2026-09-11', '2026-09-19', '2026-09-19', 5, 'Delivered');
INSERT INTO procurement VALUES (7, '2026-09-29', '2026-09-21', NULL, NULL, NULL, 0, 'Order due');
INSERT INTO procurement VALUES (8, '2026-09-29', '2026-09-21', NULL, NULL, NULL, 0, 'Order due');
INSERT INTO procurement VALUES (9, '2026-10-01', '2026-09-22', NULL, NULL, NULL, 1, 'Order due');
INSERT INTO procurement VALUES (10, '2026-10-01', '2026-09-21', '2026-09-19', '2026-09-26', NULL, 5, 'On order');
INSERT INTO procurement VALUES (11, '2026-10-01', '2026-09-19', NULL, NULL, NULL, -2, 'Order overdue');
INSERT INTO procurement VALUES (12, '2026-10-01', '2026-09-19', '2026-09-18', '2026-09-26', NULL, 5, 'On order');
INSERT INTO procurement VALUES (13, '2026-09-24', '2026-09-17', '2026-09-16', '2026-09-19', '2026-09-19', 5, 'Delivered');
INSERT INTO procurement VALUES (14, '2026-09-24', '2026-09-15', '2026-09-14', '2026-09-19', NULL, 5, 'On order');
INSERT INTO procurement VALUES (15, '2026-10-01', '2026-09-22', NULL, NULL, NULL, 1, 'Order due');
INSERT INTO procurement VALUES (16, '2026-09-23', '2026-09-16', '2026-09-15', '2026-09-18', NULL, 5, 'On order');
INSERT INTO procurement VALUES (17, '2026-09-23', '2026-09-14', '2026-09-12', '2026-09-18', '2026-09-18', 5, 'Delivered');
INSERT INTO procurement VALUES (18, '2026-10-07', '2026-09-28', NULL, NULL, NULL, 7, 'Not yet due');
INSERT INTO procurement VALUES (19, '2026-10-29', '2026-09-15', '2026-09-10', '2026-10-21', NULL, 8, 'On order');

-- Part 3: the queries (run them one at a time)

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
