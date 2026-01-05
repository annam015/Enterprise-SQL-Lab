# 04 – Selective Data Recovery

## Objective

Demonstrate how to recover only specific records after data corruption, without restoring the production database or interrupting live workloads.


This chapter builds on:
- **00_Environment_Setup.md**
- **01_Backup_and_Recovery.md**
- **02_Differential_and_Log.md**
- **03_Point_in_Time_Recovery.md**

## 4.1 Key Principle

SQL Server does **not** support restoring individual rows directly.

Selective data recovery is achieved by:
1. Restoring the database to a **separate recovery database**
2. Extracting only the required records
3. Re-inserting them into the production database


## 4.2 Incident Simulation – Accidental Delete

Simulating a delete operation executed with an incorrect condition.

```sql
USE EnterpriseLab;
GO

DELETE FROM Orders WHERE OrderDate < '2025-12-17 12:00:00';
GO
```

## 4.3 Identify Logical File Names (One-Time Step)

Before restoring the database under a new name, the logical file names contained in the backup must be identified.

```sql
RESTORE FILELISTONLY FROM DISK = 'C:\SQLBackups\EnterpriseLab_full.bak';
GO
```

## 4.4 Restore Backup into a Recovery Database

Before restoring a database under a new name, the correct data file location for the SQL Server instance must be identified. The target directory must exist on the operating system and be writable by the SQL Server service account.

The current data file location can be determined by querying the system catalog view `sys.database_files` on an existing database.

```sql
SELECT name, physical_name FROM EnterpriseLab.sys.database_files;
GO
```

From the returned physical_name values, extract the directory path up to the \DATA\ folder. This path represents the default data directory used by the SQL Server instance.

The production database (`EnterpriseLab`) remains online and untouched.

Restore the backup into a **new database** named EnterpriseLab_Recovery:

```sql
RESTORE DATABASE EnterpriseLab_Recovery 
FROM DISK = 'C:\SQLBackups\EnterpriseLab_full.bak'
WITH MOVE 'EnterpriseLab' TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\Data\EnterpriseLab_Recovery.mdf',
     MOVE 'EnterpriseLab_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\Data\EnterpriseLab_Recovery.ldf',
     RECOVERY;
GO
```

Replace the path with the instance-specific ...\MSSQLxx...\DATA\ returned by sys.database_files.

## 4.5 Validate the Recovery Database

```sql
USE EnterpriseLab_Recovery;
GO

SELECT * FROM Orders
WHERE OrderDate < '2025-12-17 12:00:00';
GO
```

These rows represent the data that must be restored to production.

## 4.6 Selective Data Extraction

Reinsert only the missing records into the production database, avoiding duplicates.

```sql
SET IDENTITY_INSERT EnterpriseLab.dbo.Orders ON;
GO
```

```sql
INSERT INTO EnterpriseLab.dbo.Orders (OrderID, OrderDate, Amount)
SELECT r.OrderID, r.OrderDate, r.Amount
FROM EnterpriseLab_Recovery.dbo.Orders r
LEFT JOIN EnterpriseLab.dbo.Orders p
       ON r.OrderID = p.OrderID
WHERE r.OrderDate < '2025-12-17 12:00:00'
  AND p.OrderID IS NULL;
GO
```

```sql
SET IDENTITY_INSERT EnterpriseLab.dbo.Orders OFF;
GO

DECLARE @maxId INT;
SELECT @maxId = MAX(OrderID) FROM EnterpriseLab.dbo.Orders;

DBCC CHECKIDENT ('EnterpriseLab.dbo.Orders', RESEED, @maxId);
GO
```

## 4.7 Validation

```sql
USE EnterpriseLab;
GO

SELECT * FROM Orders;
GO

SELECT * FROM Orders
WHERE OrderDate < '2025-12-17 12:00:00'
ORDER BY OrderID;
GO
```

Expected result:
- Deleted historical records are restored
- Existing records remain unchanged

## 4.8 Cleanup

Once recovery is complete, the temporary database can be removed.

```sql
DROP DATABASE EnterpriseLab_Recovery;
GO
```