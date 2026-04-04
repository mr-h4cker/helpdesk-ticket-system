# IT Help Desk Ticket Management System

A Java-based console application integrated with PostgreSQL that simulates a real-world IT help desk system for managing support tickets, users, categories, and ticket updates.

This project demonstrates database design, complex SQL queries, and backend application development using JDBC.

---

## 🚀 Features

- Add and manage users (employees, technicians, admins)
- Create and manage support tickets
- Assign tickets to technicians
- Update ticket status (open, in progress, closed)
- Add update notes to tickets
- View detailed ticket history
- Execute advanced SQL queries for reporting and analytics

---

## 🛠️ Tech Stack

- Java (JDBC)
- PostgreSQL
- pgAdmin 4
- BlueJ (IDE)

---

## 🧱 Database Design

The system uses a relational database with the following tables:

- `users` – stores employees, technicians, and admins
- `categories` – ticket categories (Hardware, Software, Network, etc.)
- `tickets` – main ticket data
- `ticket_updates` – history and updates for tickets

### Entity Relationship Diagram

![ER Diagram](docs/Entity-relationshipDiagram.png)

---

## 📊 Sample SQL Queries & Results

### Open Tickets Overview (JOIN)
![Open Tickets](docs/screenshots/scenario1_open_tickets.png)

### Technician Workload (GROUP BY)
![Workload](docs/screenshots/scenario2_workload.png)

### Complex Tickets (Multiple Updates - HAVING)
![Multiple Updates](docs/screenshots/scenario5_multiple_updates.png)

### High Activity Categories (SUBQUERY)
![Above Average](docs/screenshots/scenario7_above_average.png)

### Backlog Analysis (REAL-WORLD REPORT)
![Backlog](docs/screenshots/scenario11_backlog.png)

---

## 💻 Application Screenshots

### Main Menu
![Main Menu](docs/screenshots/app_main_menu.png)

### View All Tickets
![All Tickets](docs/screenshots/app_view_all_tickets.png)

### Ticket Details with Updates
![Ticket Details](docs/screenshots/app_ticket_details.png)

### Create Ticket
![Create Ticket](docs/screenshots/app_create_ticket.png)

### Update Ticket Status
![Update Status](docs/screenshots/app_update_status.png)

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/your-username/helpdesk-ticket-system.git
