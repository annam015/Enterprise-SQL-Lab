# ITSM Analytics – SSAS Tabular BI Project

## Project Overview
This project represents an end-to-end **Business Intelligence solution for IT Service Management (ITSM)**, built using **SQL Server** and **SQL Server Analysis Services (SSAS) Tabular**.

The goal of the project is to analyze **ticket volumes, SLA compliance and severity distribution**, and to expose business-ready KPIs for both **IT management** and **operations teams**.

The solution follows **enterprise BI best practices**, including dimensional modeling, DAX measures, KPIs, perspectives and client consumption via Excel.

---

## Architecture
- **Data Source**: SQL Server (relational database)
- **Semantic Layer**: SSAS Tabular Model
- **Consumption Layer**: Microsoft Excel (Pivot Tables connected to SSAS)

---

## Data Model
The model follows a **star schema** design:

### Fact Table
- **FactTickets**
  - TicketID
  - OpenDateKey
  - CloseDateKey
  - CategoryKey
  - SLAHours
  - ResolutionHours
  - Status

### Dimension Tables
- **DimDate**
  - DateKey
  - Date
  - Month
  - Year
- **DimCategory**
  - Category
  - Severity
  - Team

Technical keys are hidden from end users to ensure a clean, business-friendly model.

---

## DAX Measures
The following core measures were implemented using DAX:

- **Total Tickets**
- **Avg Resolution Hours**
- **SLA Breach Tickets**
- **SLA Breach %**
- **High Severity Tickets**
- **High Severity Tickets %**

All measures are organized using display folders for improved usability.

---

## KPIs
Two business KPIs were designed and implemented directly in SSAS Tabular:

### SLA Breach % KPI
- **Target**: ≤ 10%
- **Warning**: 10% – 20%
- **Critical**: > 20%
- **Direction**: Lower is better

### High Severity Tickets % KPI
- **Target**: ≤ 30%
- **Warning**: 30% – 40%
- **Critical**: > 40%
- **Direction**: Lower is better

Both KPIs use visual status indicators (traffic lights) and are fully consumable in Excel or Power BI.

---

## Perspectives
To improve usability for different user roles, multiple **SSAS Perspectives** were created:

### IT Management
- KPIs
- Key high-level measures
- Limited dimensions for slicing

### Operations
- Full ticket-level analysis
- All measures and dimensions
- Designed for operational monitoring

---

## Client Consumption
The model is consumed using **Microsoft Excel**, connected live to the SSAS Tabular model.
Users can:
- Build Pivot Tables
- Filter by date and category
- Visualize KPI status
- Analyze SLA performance trends

---

## Technologies Used
- SQL Server
- SQL Server Analysis Services (Tabular)
- DAX
- Microsoft Excel
- Star Schema / Dimensional Modeling