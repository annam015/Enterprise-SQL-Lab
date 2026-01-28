# Enterprise-SQL-Lab

## Overview

This repository contains a comprehensive SQL Server enterprise lab covering core responsibilities of a Database Administrator / Data Engineer, including backup & recovery, high availability, disaster recovery, migrations, ETL, and reporting.
The lab is designed to demonstrate hands-on implementation, not just theoretical knowledge, and follows real-world enterprise best practices.

## Repository Structure

**1. Backup & Recovery**

Folder: backup-recovery

This section covers SQL Server data protection and recovery strategies. Demonstrates ownership of backup strategies and the ability to recover data after incidents with minimal data loss.

Key topics:
- Full database backups
- Differential backups
- Transaction log backups
- Point-in-time recovery
- Selective data recovery using a recovery database

**2. High Availability & Disaster Recovery (HA/DR)**

Folder: ha-dr

This section implements SQL Server Always On Availability Groups built on Windows Server Failover Clustering (WSFC). Demonstrates high-availability design, failover testing, and enterprise-grade HA/DR architecture.

Key topics:
- Active Directory & DNS setup
- SQL Server multi-node environment
- WSFC creation and validation
- Always On Availability Groups
- Synchronous commit & automatic failover
- RPO ≈ 0 and RTO < 60 seconds (lab measurement)

**3. On-Prem to Cloud Migration (SqlPackage)**

Folder: migration-sqlpackage

This section demonstrates an offline migration from on-premises SQL Server to Azure SQL Database using Microsoft SqlPackage (DACFx). Demonstrates practical experience with SQL Server → Azure SQL migrations and tooling used in real projects.

Key topics:
- Source and target environment preparation
- BACPAC export and import
- Schema and data migration
- Downtime measurement (~54 seconds for ~200k rows)
- Migration method selection and trade-offs

**4. ETL – SQL Server Integration Services (SSIS)**

Folder: ssis

This section covers ETL workflows built with SQL Server Integration Services. Demonstrates ETL design, data transformations, and analytical data preparation.

Key topics:
- OLTP to Data Warehouse data loading
- Fact table population
- Hourly aggregations using SSIS transformations
- Full reload strategy (lab environment)

SSIS Packages:
- Load_FactOrders.dtsx
- Load_FactOrders_ByHour.dtsx


**5. Reporting – SQL Server Reporting Services (SSRS)**

Folder: ssrs

This section presents enterprise reporting using SSRS on top of the Data Warehouse. Demonstrates end-to-end reporting: DWH → SSRS → User-friendly analytics.

Key topics:
- Parameterized reports
- Date range filtering with default values
- Time-based analytics (Amount by Hour)
- Chart-based visualization
- Report deployment to SSRS Report Server

**5. Analytics & Semantic Layer – SSAS Tabular & KPI Reporting**

Folder: analytics-tabular-reporting

This section implements the analytical and semantic layer on top of the database using SQL Server Analysis Services (SSAS) Tabular. It demonstrates how relational data is transformed into business-ready measures, KPIs and analytical views.

Key topics:
- SSAS Tabular model design
- DAX measures and calculations
- Business KPIs with thresholds
- Analytical perspectives (IT Management / Operations)
- Excel-based reporting on SSAS

**Purpose of the Lab**

This lab was built to:
- Simulate real enterprise DBA responsibilities
- Demonstrate hands-on technical ownership
- Provide clear documentation and reproducibility
- Serve as a practical portfolio for enterprise database roles