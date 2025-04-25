# 🎓 GradTracker – Graduation Management Database System

GradTracker is a relational database system designed to help universities manage graduate registrations, guest tickets, award tracking, and ceremony logistics.

## 📦 Features
- Track graduate registrations and graduation status
- Manage ticket requests and guest assignments
- Assign awards and manage ceremony details
- SQL schema, sample data, and optimized queries
- Indexed fields for performance optimization

## 🧠 What I Learned
- How to **design a database system from scratch** using real-world requirements
- How to convert an ERD into a normalized relational schema
- Writing efficient SQL queries with JOINs and aggregates
- The importance of indexing and schema optimization
- Collaborating on large-scale team-based database projects

## 💻 Technologies
- SQL (Oracle/PLSQL)
- ERD Design (ERDPlus)
- Data analysis potential with Tableau/Power BI
- Presentation designed in PowerPoint

## ERD
![ERD_For_GradTracker](https://github.com/user-attachments/assets/99d96ef1-3e29-4ab9-be83-b9cadd790a80)

## RDB
![RDB_For_GradTracker](https://github.com/user-attachments/assets/9fafb2e1-22f2-4c1d-a069-52513886a5b2)

## 📈 Sample Queries
```sql
SELECT c.CeremonyID, COUNT(DISTINCT r.GraduateID) AS Grad_Count
FROM Ceremony c
JOIN Registration r ON c.CeremonyID = r.CeremonyID
GROUP BY c.CeremonyID;
