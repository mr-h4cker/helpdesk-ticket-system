-- =========================================================
-- Help Desk Ticket Management System - Reporting Queries
-- =========================================================

-- Scenario 1
-- All open tickets with full context
SELECT
    ticket.ticket_id,
    ticket.title,
    ticket.status,
    ticket.priority,
    creator_user.full_name AS created_by,
    assigned_technician.full_name AS assigned_to,
    ticket_category.category_name,
    ticket.created_at
FROM tickets AS ticket
JOIN users AS creator_user
    ON ticket.created_by = creator_user.user_id
LEFT JOIN users AS assigned_technician
    ON ticket.assigned_to = assigned_technician.user_id
JOIN categories AS ticket_category
    ON ticket.category_id = ticket_category.category_id
WHERE ticket.status = 'open'
ORDER BY ticket.created_at;


-- Scenario 2
-- Technician workload (active tickets only)
SELECT
    technician.user_id,
    technician.full_name AS technician_name,
    COUNT(active_ticket.ticket_id) AS active_ticket_count
FROM users AS technician
LEFT JOIN tickets AS active_ticket
    ON technician.user_id = active_ticket.assigned_to
   AND active_ticket.status IN ('open', 'in_progress')
WHERE technician.role = 'technician'
GROUP BY technician.user_id, technician.full_name
ORDER BY active_ticket_count DESC, technician_name;


-- Scenario 3
-- Categories generating the most high-priority tickets
SELECT
    ticket_category.category_name,
    COUNT(high_priority_ticket.ticket_id) AS high_priority_ticket_count
FROM categories AS ticket_category
JOIN tickets AS high_priority_ticket
    ON ticket_category.category_id = high_priority_ticket.category_id
WHERE high_priority_ticket.priority = 'high'
GROUP BY ticket_category.category_name
ORDER BY high_priority_ticket_count DESC, ticket_category.category_name;


-- Scenario 4
-- Open tickets that are unassigned
SELECT
    ticket.ticket_id,
    ticket.title,
    ticket.priority,
    creator_user.full_name AS created_by,
    ticket_category.category_name,
    ticket.created_at
FROM tickets AS ticket
JOIN users AS creator_user
    ON ticket.created_by = creator_user.user_id
JOIN categories AS ticket_category
    ON ticket.category_id = ticket_category.category_id
WHERE ticket.status = 'open'
  AND ticket.assigned_to IS NULL
ORDER BY ticket.created_at;


-- Scenario 5
-- Tickets with multiple updates
SELECT
    ticket.ticket_id,
    ticket.title,
    COUNT(ticket_update.update_id) AS total_updates
FROM tickets AS ticket
JOIN ticket_updates AS ticket_update
    ON ticket.ticket_id = ticket_update.ticket_id
GROUP BY ticket.ticket_id, ticket.title
HAVING COUNT(ticket_update.update_id) > 1
ORDER BY total_updates DESC, ticket.ticket_id;


-- Scenario 6
-- Employees who submitted the most tickets
SELECT
    employee.user_id,
    employee.full_name AS employee_name,
    COUNT(submitted_ticket.ticket_id) AS total_submitted_tickets
FROM users AS employee
JOIN tickets AS submitted_ticket
    ON employee.user_id = submitted_ticket.created_by
WHERE employee.role = 'employee'
GROUP BY employee.user_id, employee.full_name
ORDER BY total_submitted_tickets DESC, employee_name;


-- Scenario 7
-- Categories with above-average ticket volume
SELECT
    ticket_category.category_name,
    COUNT(ticket.ticket_id) AS total_ticket_count
FROM categories AS ticket_category
LEFT JOIN tickets AS ticket
    ON ticket_category.category_id = ticket.category_id
GROUP BY ticket_category.category_id, ticket_category.category_name
HAVING COUNT(ticket.ticket_id) > (
    SELECT AVG(category_ticket_count)
    FROM (
        SELECT COUNT(*) AS category_ticket_count
        FROM tickets
        GROUP BY category_id
    ) AS category_counts
)
ORDER BY total_ticket_count DESC, ticket_category.category_name;


-- Scenario 8
-- Technician who resolved the most tickets
SELECT
    technician.user_id,
    technician.full_name AS technician_name,
    COUNT(resolved_ticket.ticket_id) AS closed_ticket_count
FROM users AS technician
JOIN tickets AS resolved_ticket
    ON technician.user_id = resolved_ticket.assigned_to
WHERE technician.role = 'technician'
  AND resolved_ticket.status = 'closed'
GROUP BY technician.user_id, technician.full_name
ORDER BY closed_ticket_count DESC, technician_name;


-- Scenario 9
-- Tickets with no updates
SELECT
    ticket.ticket_id,
    ticket.title,
    ticket.status,
    ticket.priority,
    ticket.created_at
FROM tickets AS ticket
LEFT JOIN ticket_updates AS ticket_update
    ON ticket.ticket_id = ticket_update.ticket_id
WHERE ticket_update.ticket_id IS NULL
ORDER BY ticket.created_at;


-- Scenario 10
-- Employees reporting most security-related issues
SELECT
    employee.user_id,
    employee.full_name AS employee_name,
    COUNT(security_ticket.ticket_id) AS security_ticket_count
FROM users AS employee
JOIN tickets AS security_ticket
    ON employee.user_id = security_ticket.created_by
JOIN categories AS ticket_category
    ON security_ticket.category_id = ticket_category.category_id
WHERE employee.role = 'employee'
  AND ticket_category.category_name = 'Security'
GROUP BY employee.user_id, employee.full_name
ORDER BY security_ticket_count DESC, employee_name;


-- Scenario 11
-- Backlog by category (open + in_progress)
SELECT
    ticket_category.category_name,
    COUNT(backlog_ticket.ticket_id) AS backlog_count
FROM categories AS ticket_category
LEFT JOIN tickets AS backlog_ticket
    ON ticket_category.category_id = backlog_ticket.category_id
   AND backlog_ticket.status IN ('open', 'in_progress')
GROUP BY ticket_category.category_id, ticket_category.category_name
ORDER BY backlog_count DESC, ticket_category.category_name;


-- Scenario 12
-- Full ticket update history
SELECT
    ticket.ticket_id,
    ticket.title,
    updating_user.full_name AS updated_by,
    ticket_update.update_note,
    ticket_update.updated_at
FROM ticket_updates AS ticket_update
JOIN tickets AS ticket
    ON ticket_update.ticket_id = ticket.ticket_id
JOIN users AS updating_user
    ON ticket_update.updated_by = updating_user.user_id
ORDER BY ticket.ticket_id, ticket_update.updated_at;
