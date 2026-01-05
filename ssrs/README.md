# README – SSRS (SQL Server Reporting Services)

## Overview

This project demonstrates the creation and deployment of SSRS reports based on a SQL Server Data Warehouse.
The reports provide time-based analytics using parameterized datasets and interactive charts.

## Data Source

**Database:** EnterpriseDWH
**Primary Table Used:** dbo.FactOrders_ByHour
**Connection Type:** SQL Server (Windows Authentication)

## Report Server Environment

**SSRS Version:** SQL Server Reporting Services 2019
**Execution Mode:** Local Report Server
**Web Service URL:** http://<machine-name>:8888/ReportServer
**Web Portal URL:** http://<machine-name>:8888/Reports

## Implemented Report

**Orders Count by Hour**

**Description:** A parameterized report displaying the total amount of orders grouped by hour within a selected date range.

**Features:**
- Line chart visualization
- Date range filtering using parameters

**Parameters**
Parameter	| Type	    | Description
StartDate	| DateTime	| Current date minus 7 days
EndDate	    | DateTime  | Current date

## Default Value Expressions:

```vb
StartDate = DateAdd("m", -3, Today())
EndDate   = Today()
```

## Dataset Query (Embedded Dataset)

```sql
SELECT
  HourBucket,
  OrdersCount,
  TotalAmount,
  AvgAmount
FROM dbo.FactOrders_ByHour
WHERE HourBucket >= @StartDate
  AND HourBucket <  @EndDate
ORDER BY HourBucket;
```

## Report Design

**X-axis:** HourBucket (formatted as DateTime)
**Y-axis:** TotalAmount
**Chart Type:** Line

## Deployment

- Reports are deployed from Visual Studio 2022 using a Report Server Project
- Deployment target: http://<machine-name>:8888/ReportServer
- Reports are accessed via the SSRS Web Portal