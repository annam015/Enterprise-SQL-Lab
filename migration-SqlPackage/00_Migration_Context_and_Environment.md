# 00 – Migration Context and Environment

## Objective

Define the scope, context, and environments involved in the on-premises to Azure SQL migration lab. This document establishes the baseline for all subsequent migration steps.

## 0.1 Migration Scenario Overview

This lab simulates a realistic database migration scenario where an on-premises SQL Server database is migrated to Azure SQL Database.

The migration focuses on:
- Understanding migration tooling
- Executing a real schema + data migration
- Measuring downtime
- Validating data consistency

The lab intentionally uses a simplified data model while preserving enterprise-grade migration principles.

## 0.2 Source Environment (On-Prem)

**Platform:**  
- SQL Server (Developer Edition)
- Windows Server (Virtual Machine)

**Database:**  
- Name: `EnterpriseLab`
- Recovery model: FULL
- Backup & Recovery strategy: Implemented and tested separately

**Table used for migration testing:**
- `dbo.Orders`
  - `OrderID` (IDENTITY, primary key)
  - `OrderDate`
  - `Amount`

## 0.3 Target Environment (Azure)

**Platform:**  
- Azure SQL Database (Single Database – PaaS)

**Database:**  
- Name: `EnterpriseLabCloud`
- Authentication: SQL Authentication
- Compute tier: Low-cost tier (lab environment)

Azure SQL Database was selected for hands-on execution due to cost constraints associated with Azure SQL Managed Instance in a trial subscription.

## 0.4 Tooling Overview

The following tools are used in this lab:

- **Azure Data Studio**
  - Connectivity and query execution
- **SqlPackage (DAC Framework)**
  - Export and import of BACPAC files
- **Azure Portal**
  - Creation and management of Azure SQL Database

## 0.5 Migration Method Selection

The migration is executed using an **offline migration** approach based on
BACPAC export and import.

Reasons for this choice:
- Simple and deterministic execution
- Suitable for small to medium databases
- Clear downtime measurement
- Minimal Azure cost