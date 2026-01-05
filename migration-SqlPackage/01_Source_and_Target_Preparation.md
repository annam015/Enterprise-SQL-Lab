# 01 – Source and Target Preparation

## Objective

Prepare both the source (on-premises SQL Server) and the target (Azure SQL Database) environments for migration. This step includes environment validation, target provisioning, and preparation of a representative dataset for migration.

## 1.1 Source Environment – Connectivity Validation

The source SQL Server instance is hosted on a Windows Server virtual machine. Before performing any migration operations, connectivity and database access were validated.

```cmd
sqlcmd -S localhost -E -C
```

## 1.2 Source Database Verification

The source database EnterpriseLab was verified to ensure it exists and is accessible.

```sql
SELECT name FROM sys.databases;
GO
```

## 1.3 Target Environment – Azure SQL Database Creation

An Azure SQL Database was created using the Azure Portal to serve as the migration target.

Target Configuration
- Platform: Azure SQL Database (Single Database – PaaS)
- Database name: EnterpriseLabCloud
- Authentication: SQL Authentication
- Compute tier: Low-cost tier (lab environment)
- Connectivity: Public endpoint with firewall rules allowing client access

The database was created empty and ready to receive schema and data.


## 1.4 Target Connectivity Validation

Connectivity to the Azure SQL Database was validated using Azure Data Studio.

```sql
SELECT name FROM sys.databases;
GO
```

## 1.5 Source Data Preparation

The existing data in the source table was removed and a synthetic dataset of 200,000 rows was generated in the source database to simulate a small-to-medium production workload.

```sql
USE EnterpriseLab;
GO

DELETE FROM Orders;
GO

SET NOCOUNT ON;

DECLARE @i INT = 1;

WHILE @i <= 200000
BEGIN
    INSERT INTO Orders (OrderDate, Amount)
    VALUES (
        DATEADD(MINUTE, -@i, SYSDATETIME()),
        ABS(CHECKSUM(NEWID())) % 1000 + 1
    );

    SET @i += 1;
END;
GO
```