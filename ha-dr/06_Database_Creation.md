# 06 – Database Creation and Preparation for High Availability 

## Objective

Create and prepare a SQL Server database for high availability using Always On Availability Groups.
This step ensures the database meets all technical prerequisites required for participation in an Availability Group.

## Environment Overview

**Primary SQL node:** SQL1
**Secondary SQL node:** SQL2
**Domain:** lab.local
**Cluster:** SQLCLUSTER
**SQL Server edition:** Developer Edition (lab)
**Database name:** AG_Lab

## Database Creation

The database was created on the primary node (SQL1).
At this stage, the database exists only on the primary node.

```sql
CREATE DATABASE AG_Lab;
GO
```

## Initial Schema and Data (Optional)

A minimal schema was created to simulate application data and allow validation after failover.

```sql
USE AG_Lab;
GO

CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATETIME2 NOT NULL,
    Amount DECIMAL(10,2) NOT NULL
);
GO
```

Insert sample data:

```sql
INSERT INTO dbo.Orders (OrderDate, Amount)
VALUES
    (SYSDATETIME(), 100.00),
    (SYSDATETIME(), 250.50),
    (SYSDATETIME(), 75.25);
GO
```

## Recovery Model Configuration

Availability Groups require the database to use the FULL recovery model.

```sql
ALTER DATABASE AG_Lab SET RECOVERY FULL;
GO
```

## Initial Full Backup

A recent full backup is mandatory before adding a database to an Availability Group.

```sql
BACKUP DATABASE AG_Lab
TO DISK = 'C:\SQLBackups\AG_Lab_full.bak'
WITH INIT;
GO
```

## Restore Database on Secondary Node (SQL2)

The database was restored on SQL2 using NORECOVERY mode to prepare it for Availability Group synchronization.
A shared backup location accessible by both SQL1 and SQL2 was used.

```sql
RESTORE DATABASE AG_Lab
FROM DISK = '\\SQL1\SQLBackups\AG_Lab_full.bak'
WITH NORECOVERY;
GO
```

## Database Readiness Validation

The following conditions were verified before proceeding to Always On configuration:
- Database exists on both nodes
- Primary database is ONLINE
- Secondary database is RESTORING
- Recovery model is FULL
- Recent full backup exists

Validation query:

```sql
SELECT name, state_desc, recovery_model_desc
FROM sys.databases
WHERE name = 'AG_Lab';
GO
```