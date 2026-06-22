# 🌍 Smart Tourism Management System

A comprehensive **MySQL Database Management Project** designed to streamline tourism operations by managing tourist destinations, hotels, transportation, bookings, reviews, and travel packages. This project demonstrates advanced SQL concepts including database design, normalization, indexing, views, stored procedures, triggers, joins, and analytical queries.

---

## 📌 Project Overview

The Smart Tourism Management System provides a centralized platform for managing tourism-related services and operations. It enables efficient handling of tourist information, hotel reservations, transport bookings, package management, reviews, and business analytics.

This project was developed to showcase practical implementation of **Database Management System (DBMS)** concepts using MySQL in a real-world tourism domain.

---

## 🚀 Features

### User Management

* Tourist, Admin, and Travel Agent Management
* Secure user information storage
* Role-based user classification

### Tourist Places Management

* Destination details management
* Categorization by heritage, beach, hill station, wildlife, religious, and adventure tourism
* Seasonal and entry fee information

### Hotel Management

* Hotel information and amenities
* Star ratings and pricing
* Hotel booking management

### Transport Management

* Flight, Train, Bus, Cab, and Ferry services
* Route and seat availability tracking
* Transport booking management

### Reviews & Ratings

* Destination reviews
* Hotel reviews
* Rating and feedback system

### Travel Packages

* Package creation and management
* Multi-destination itineraries
* Agent-managed travel packages

### Business Analytics

* Revenue reporting
* Popular destination analysis
* Customer booking insights
* Tourism performance tracking

---

## 🛠️ Technologies Used

* MySQL
* SQL
* MySQL Workbench

---

## 🗄️ Database Architecture

### Core Tables

| Table Name         | Description                                  |
| ------------------ | -------------------------------------------- |
| users              | Stores tourist, admin, and agent information |
| tourist_places     | Tourist destination details                  |
| hotels             | Hotel information and pricing                |
| hotel_bookings     | Hotel reservation records                    |
| transport          | Transport service details                    |
| transport_bookings | Transport reservation records                |
| reviews            | Ratings and customer reviews                 |
| travel_packages    | Travel package information                   |
| package_places     | Package itinerary mapping                    |

---

## 📊 Advanced SQL Features Implemented

### Views

* `vw_place_ratings`
* `vw_hotel_booking_summary`
* `vw_transport_booking_details`
* `vw_package_overview`

### Stored Procedures

* `sp_book_hotel()`
* `sp_book_transport()`
* `sp_get_user_bookings()`
* `sp_revenue_report()`

### Triggers

* Automatic hotel booking amount calculation
* Transport seat availability management
* Booking cancellation handling
* Review validation mechanism

### SQL Concepts Used

* Joins (INNER JOIN, LEFT JOIN)
* Subqueries
* Aggregate Functions
* Group By & Having
* Views
* Stored Procedures
* Triggers
* Indexing
* Constraints
* Database Normalization

---

## 🔄 Entity Relationship Overview

```text
Users
│
├── Hotel Bookings ─── Hotels ─── Tourist Places
│
├── Transport Bookings ─── Transport
│
└── Reviews ─── Tourist Places

Travel Packages
        │
Package Places
        │
Tourist Places
```

---

## 📈 Sample Analytical Queries

### Revenue Analysis

* Monthly revenue reports
* Booking statistics

### Customer Insights

* Top spending tourists
* User booking history

### Tourism Analytics

* Most popular destinations
* Highest-rated tourist places
* Package performance analysis

### Operational Reports

* Hotel booking summaries
* Transport availability reports

---

## 🎯 Learning Outcomes

Through this project, I gained practical experience in:

* Relational Database Design
* SQL Query Development
* Database Normalization
* Indexing and Performance Optimization
* Stored Procedures and Triggers
* Data Integrity Management
* Business Reporting and Analytics

---

## 📂 Project Structure

```text
smart-tourism-management-system/
│
├── Smart_Tourism_Management_System.sql
├── README.md
│
├── Database Setup
├── Table Creation Scripts
├── Sample Data
├── Views
├── Stored Procedures
├── Triggers
├── Analytical Queries
└── Reports
```

---

## ▶️ How to Run

1. Install MySQL Server and MySQL Workbench.
2. Clone this repository.

```bash
git clone https://github.com/your-username/smart-tourism-management-system.git
```

3. Open MySQL Workbench.
4. Import and execute the SQL script.
5. The database, tables, sample data, views, procedures, and triggers will be created automatically.

---

## 📷 Future Enhancements

* AI-Based Travel Recommendation System
* Chatbot Integration
* Weather Forecast Integration
* Online Payment Gateway
* Mobile Application Support
* Real-Time Booking Dashboard

---

## 👨‍💻 Author

**Sathiya Narayanan**

MCA Graduate | SQL Developer | Database Enthusiast

GitHub: https://github.com/sath918

LinkedIn: https://www.linkedin.com/in/sathiya-p

---

## ⭐ Project Highlights

✔ 9+ Relational Tables

✔ 4 Views

✔ 4 Stored Procedures

✔ 4 Triggers

✔ Advanced SQL Queries

✔ Revenue & Business Analytics

✔ Real-World Tourism Management Use Case
