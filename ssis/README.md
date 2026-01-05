# README – SSIS (SQL Server Integration Services)

## Overview

This project demonstrates a basic ETL (Extract, Transform, Load) workflow implemented using SQL Server Integration Services (SSIS).
The goal is to load transactional data from an OLTP database into a Data Warehouse and create aggregated fact data suitable for reporting and analytics.

## Source System (OLTP)

**Database:** EnterpriseLab
**Table:** dbo.Orders
**Description:** Transactional orders table containing raw operational data.
**Volume:** ~200,000 records (synthetic dataset generated for lab purposes)

## Target System (Data Warehouse)

Database: EnterpriseDWH
Tables:
- dbo.FactOrders
- dbo.FactOrders_ByHour

## Implemented SSIS Packages

**Load_FactOrders.dtsx**

Purpose: Load transactional order data into the Data Warehouse fact table.

Logic:
- Source: EnterpriseLab.dbo.Orders
- Filter applied: Amount > 0
- Destination: EnterpriseDWH.dbo.FactOrders
- Load strategy: Full reload (TRUNCATE + INSERT)

SSIS Components Used:
- Execute SQL Task (TRUNCATE target table)
- ADO.NET Source
- ADO.NET Destination

**Load_FactOrders_ByHour.dtsx**

Purpose: Create an hourly aggregated fact table for analytical and reporting use.
Aggregation Logic: Group orders by HourBucket (OrderDate rounded to hour)

Metrics calculated:
- OrdersCount
- TotalAmount
- AvgAmount

SSIS Components Used:
- Execute SQL Task (TRUNCATE target table)
- ADO.NET Source
- Aggregate Transformation
- ADO.NET Destination