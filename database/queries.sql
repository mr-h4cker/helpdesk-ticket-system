-- Scenario 1
-- All open tickets with creator, assignee, and category details
SELECT
    t.ticket_id,
    t.title,
    t.status,
    t.priority,
    creator.full_name AS created_by,
    assignee.full_name AS assigned_to,
    c.category_name,
    t.created_at
FROM tickets t
JOIN users creator
    ON t.created_by = creator.user_id
LEFT JOIN users assignee
    ON t.assigned_to = assignee.user_id
JOIN categories c
    ON t.category_id = c.category_id
WHERE t.status = 'open'
ORDER BY t.created_at;


-- Scenario 2
-- Technician workload: active tickets only
SELECT
    u.user_id,
    u.full_name AS technician_name,
    COUNT(t.ticket_id) AS active_ticket_count
FROM users u
LEFT JOIN tickets t
    ON u.user_id = t.assigned_to
   AND t.status IN ('open', 'in_progress')
WHERE u.role = 'technician'
GROUP BY u.user_id, u.full_name
ORDER BY active_ticket_count DESC, technician_name;


-- Scenario 3
-- Categories generating the most high-priority tickets
SELECT
    c.category_name,
    COUNT(t.ticket_id) AS high_priority_ticket_count
FROM categories c
JOIN tickets t
    ON c.category_id = t.category_id
WHERE t.priority = 'high'
GROUP BY c.category_name
ORDER BY high_priority_ticket_count DESC, c.category_name;


-- Scenario 4
-- Open tickets that are still unassigned
SELECT
    t.ticket_id,
    t.title,
    t.priority,
    creator.full_name AS created_by,
    c.category_name,
    t.created_at
FROM tickets t
JOIN users creator
    ON t.created_by = creator.user_id
JOIN categories c
    ON t.category_id = c.category_id
WHERE t.status = 'open'
  AND t.assigned_to IS NULL
ORDER BY t.created_at;


-- Scenario 5
-- Tickets with multiple updates
SELECT
    t.ticket_id,
    t.title,
    COUNT(tu.update_id) AS update_count
FROM tickets t
JOIN ticket_updates tu
    ON t.ticket_id = tu.ticket_id
GROUP BY t.ticket_id, t.title
HAVING COUNT(tu.update_id) > 1
ORDER BY update_count DESC, t.ticket_id;


-- Scenario 6
-- Employees who submitted the most tickets
SELECT
    u.user_id,
    u.full_name AS employee_name,
    COUNT(t.ticket_id) AS submitted_ticket_count
FROM users u
JOIN tickets t
    ON u.user_id = t.created_by
WHERE u.role = 'employee'
GROUP BY u.user_id, u.full_name
ORDER BY submitted_ticket_count DESC, employee_name;


-- Scenario 7
-- Categories with above-average ticket volume
SELECT
    c.category_name,
    COUNT(t.ticket_id) AS total_tickets
FROM categories c
LEFT JOIN tickets t
    ON c.category_id = t.category_id
GROUP BY c.category_id, c.category_name
HAVING COUNT(t.ticket_id) > (
    SELECT AVG(category_ticket_count)
    FROM (
        SELECT COUNT(*) AS category_ticket_count
        FROM tickets
        GROUP BY category_id
    ) AS category_counts
)
ORDER BY total_tickets DESC, c.category_name;


-- Scenario 8
-- Technician who resolved the most tickets
SELECT
    u.user_id,
    u.full_name AS technician_name,
    COUNT(t.ticket_id) AS closed_ticket_count
FROM users u
JOIN tickets t
    ON u.user_id = t.assigned_to
WHERE u.role = 'technician'
  AND t.status = 'closed'
GROUP BY u.user_id, u.full_name
ORDER BY closed_ticket_count DESC, technician_name;


-- Scenario 9
-- Tickets with no updates at all
SELECT
    t.ticket_id,
    t.title,
    t.status,
    t.priority,
    t.created_at
FROM tickets t
LEFT JOIN ticket_updates tu
    ON t.ticket_id = tu.ticket_id
WHERE tu.ticket_id IS NULL
ORDER BY t.created_at;


-- Scenario 10
-- Employees who reported the most security-related issues
SELECT
    u.user_id,
    u.full_name AS employee_name,
    COUNT(t.ticket_id) AS security_ticket_count
FROM users u
JOIN tickets t
    ON u.user_id = t.created_by
JOIN categories c
    ON t.category_id = c.category_id
WHERE u.role = 'employee'
  AND c.category_name = 'Security'
GROUP BY u.user_id, u.full_name
ORDER BY security_ticket_count DESC, employee_name;


-- Scenario 11
-- Current backlog by category (open + in_progress only)
SELECT
    c.category_name,
    COUNT(t.ticket_id) AS backlog_count
FROM categories c
LEFT JOIN tickets t
    ON c.category_id = t.category_id
   AND t.status IN ('open', 'in_progress')
GROUP BY c.category_id, c.category_name
ORDER BY backlog_count DESC, c.category_name;


-- Scenario 12
-- Full ticket update history with ticket title and updater name
SELECT
    t.ticket_id,
    t.title,
    u.full_name AS updated_by,
    tu.update_note,
    tu.updated_at
FROM ticket_updates tu
JOIN tickets t
    ON tu.ticket_id = t.ticket_id
JOIN users u
    ON tu.updated_by = u.user_id
ORDER BY t.ticket_id, tu.updated_at;
