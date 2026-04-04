# IT Help Desk Ticket Management System

This project is a Java-based console application connected to a PostgreSQL database that simulates how an IT help desk system works in a real organization.

I built this project because I wanted to go beyond writing small Java programs or isolated SQL queries and actually create something complete. I wanted something where the database, SQL queries, and Java application all work together in a meaningful way.

---

## Purpose of the Project

The goal of this project was to strengthen my skills in:

- designing relational databases with proper relationships  
- writing SQL beyond basic CRUD operations  
- using joins, grouping, filtering, and subqueries  
- connecting Java applications to PostgreSQL using JDBC  
- structuring code in a clean and understandable way  
- building a complete, runnable project for GitHub  

I also wanted a project I could confidently talk about in interviews and explain how everything connects.

---

## What the Application Does

This application simulates a basic IT help desk workflow.

It allows you to:

- add and manage users (employees, technicians, admins)  
- add and manage categories (hardware, software, network, etc.)  
- create support tickets  
- assign tickets to technicians  
- update ticket status (open, in progress, closed)  
- add update notes to tickets  
- view all tickets  
- view open tickets  
- view detailed ticket history with updates  

---

## Tech Stack

- Java  
- JDBC  
- PostgreSQL  
- pgAdmin 4  
- BlueJ  

---

## Database Design

The system uses four main tables:

- users  
- categories  
- tickets  
- ticket_updates  

### Relationships

- users create tickets  
- technicians are assigned to tickets  
- each ticket belongs to a category  
- each ticket can have multiple updates over time  

### Entity Relationship Diagram

![ER Diagram](docs/Entity-relationshipDiagram.png)

---

## Why I Added Reporting Scenarios

I didn’t want this to be just another CRUD project.

In real systems, data is used to answer questions like:

- Who is overloaded with work?  
- Which types of issues are most common?  
- Which tickets are becoming complex?  
- Where is the backlog building up?  

So I added realistic scenarios and wrote SQL queries for them. This helps show that I can handle more than just basic operations and actually work with meaningful data.

---

## Reporting Scenarios

The project includes:

1. View all open tickets with full details  
2. Identify which technician has the highest workload  
3. Find categories with the most high-priority tickets  
4. Find open tickets that are not assigned  
5. Find tickets with multiple updates  
6. Identify users who submit the most tickets  
7. Find categories with above-average ticket volume  
8. Identify which technician resolved the most tickets  
9. Find tickets with no updates  
10. Find users reporting the most security issues  
11. Analyze backlog by category  
12. View full update history of tickets  

Scenarios are in:  
`database/scenarios.md`  

Queries are in:  
`database/queries.sql`  

---

## SQL Query Examples

### Open Tickets Overview  
![Open Tickets](docs/screenshots/scenario1_open_tickets.png)

### Technician Workload  
![Workload](docs/screenshots/scenario2_workload.png)

### Tickets with Multiple Updates  
![Multiple Updates](docs/screenshots/scenario5_multiple_updates.png)

### Categories with Above-Average Activity  
![Above Average](docs/screenshots/scenario7_above_average.png)

### Backlog by Category  
![Backlog](docs/screenshots/scenario11_backlog.png)

---

## Application Screenshots

### Main Menu  
![Main Menu](docs/screenshots/app_main_menu.png)

### View All Tickets  
![All Tickets](docs/screenshots/app_view_all_tickets.png)

### Ticket Details  
![Ticket Details](docs/screenshots/app_ticket_details.png)

### Create Ticket  
![Create Ticket](docs/screenshots/app_create_ticket.png)

### Update Ticket Status  
![Update Status](docs/screenshots/app_update_status.png)

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/mr-h4cker/helpdesk-ticket-system
```

---

### 2. Install PostgreSQL

Make sure PostgreSQL is installed and running.

You can use pgAdmin 4 to manage the database.

---

### 3. Create the database

```sql
CREATE DATABASE helpdesk_db;
```

---

### 4. Run database scripts

Run in order:

1. `database/schema.sql`  
2. `database/seed.sql`  

---

### 5. Add PostgreSQL JDBC Driver

Java cannot connect to PostgreSQL without a driver.

Download it from:  
https://jdbc.postgresql.org/download/

If you're using BlueJ:

1. Open your project  
2. Go to Tools → Preferences → Libraries  
3. Click Add  
4. Select the `.jar` file  
5. Restart BlueJ  

---

### 6. Configure database connection

Open `DatabaseConnection.java` and update:

```java
private static final String URL = "jdbc:postgresql://localhost:5432/helpdesk_db";
private static final String USER = "postgres";
private static final String PASSWORD = "YOUR_PASSWORD";
```

---

### 7. Run the application

Run `Main.java`.

---

## Project Structure

```
helpdesk-ticket-system/
├── README.md
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   ├── queries.sql
│   └── scenarios.md
├── docs/
│   ├── Entity-relationshipDiagram.png
│   └── screenshots/
├── src/
│   ├── Main.java
│   ├── DatabaseConnection.java
│   ├── User.java
│   ├── Category.java
│   ├── Ticket.java
│   ├── TicketUpdate.java
│   ├── UserDAO.java
│   ├── CategoryDAO.java
│   ├── TicketDAO.java
│   └── TicketUpdateDAO.java
```

---

## What I Learned

Through this project, I learned how to:

- design relational databases properly  
- use foreign keys and constraints  
- write meaningful SQL queries  
- use joins, grouping, and subqueries  
- connect Java to PostgreSQL using JDBC  
- structure backend code using DAO classes  
- build a complete project from scratch  

This project really helped me understand how data and application logic come together in real systems.

---

## Future Improvements

- add a JavaFX GUI  
- add authentication  
- implement role-based access  
- add search and filtering  

---

## Author

Deepak Parmar
