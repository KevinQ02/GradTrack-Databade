# 🎓 GradTracker – Graduation Management Database System

GradTracker is a relational database system designed to help universities manage graduate registrations, guest tickets, award tracking, and ceremony logistics.

## 📦 Features
- Track graduate registrations and graduation status
- Manage ticket requests and guest assignments
- Assign awards and manage ceremony details
- SQL schema, sample data, and optimized queries
- Indexed fields for performance optimization

## 🧠 Technologies
- SQL (Oracle/PLSQL)
- ERD Design (ERDPlus)
- Data analysis potential with Tableau/Power BI
- Presentation designed in PowerPoint

## 📈 Sample Queries
```sql
SELECT c.CeremonyID, COUNT(DISTINCT r.GraduateID) AS Grad_Count
FROM Ceremony c
JOIN Registration r ON c.CeremonyID = r.CeremonyID
GROUP BY c.CeremonyID;
