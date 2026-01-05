# 02 – Differential and Transaction Log Backups

## Objective

Understand how differential and transaction log backups work together to reduce data loss and recovery time in production environments.

This chapter builds on:
- **00_Environment_Setup.md**
- **01_Backup_and_Recovery.md**

## 2.1 Recovery Model Requirement

Transaction log backups are only possible when the database uses the **FULL recovery model**.

```sql
USE master;
GO

ALTER DATABASE EnterpriseLab SET RECOVERY FULL;
GO
```

## 2.2 Establish a New Full Backup

Before working with differential and log backups, a new FULL backup is created to serve as a baseline.

```sql
BACKUP DATABASE EnterpriseLab TO DISK = 'C:\SQLBackups\EnterpriseLab_full.bak' WITH INIT;
GO
```

## 2.3 Generate Data Changes (Activity Simulation)

```sql
USE EnterpriseLab;
GO

INSERT INTO Orders (OrderDate, Amount)
VALUES (SYSDATETIME(), 999.99);
GO
```

Verify current row count:

```sql
SELECT COUNT(*) AS RowCount FROM Orders;
GO
```

## 2.4 Differential Backup

A differential backup contains all data changes since the most recent FULL backup. Compared to a FULL backup:
- It is faster to create
- It requires less storage
- It speeds up restore operations

```sql
BACKUP DATABASE EnterpriseLab TO DISK = 'C:\SQLBackups\EnterpriseLab_diff.bak' WITH DIFFERENTIAL;
GO
```

## 2.5 Additional Data Changes (Post-Differential)

```sql
INSERT INTO Orders (OrderDate, Amount)
VALUES (SYSDATETIME(), 111.11);
GO
```

Verify current row count:

```sql
SELECT COUNT(*) AS RowCount FROM Orders;
GO
```

## 2.6 Transaction Log Backup

Transaction log backups capture all transactions that occurred since the last log backup. They allow recovery to a precise point in time and minimize data loss.

```sql
BACKUP LOG EnterpriseLab TO DISK = 'C:\SQLBackups\EnterpriseLab_log.trn' WITH INIT;
GO
```

## 2.7 Simulating a Database-Level Failure

To simulate a severe incident, the database is dropped.

```sql
USE master;
GO

DROP DATABASE EnterpriseLab;
GO
```

Verify the database no longer exists:

```sql
SELECT name FROM sys.databases;
GO
```

## 2.8 Restore Sequence (FULL → DIFF → LOG)

Step 1: Restore Full Backup (No Recovery)

```sql
RESTORE DATABASE EnterpriseLab FROM DISK = 'C:\SQLBackups\EnterpriseLab_full.bak' WITH NORECOVERY;
GO
```

Step 2: Restore Differential Backup (No Recovery)

```sql
RESTORE DATABASE EnterpriseLab FROM DISK = 'C:\SQLBackups\EnterpriseLab_diff.bak' WITH NORECOVERY;
GO
```

Step 3: Restore Log Backup (Recovery)

```sql
RESTORE LOG EnterpriseLab FROM DISK = 'C:\SQLBackups\EnterpriseLab_log.trn' WITH RECOVERY;
GO
```

NORECOVERY keeps the database in a restoring state.
The final RECOVERY brings the database online.

## 2.9 Validation

```sql
USE EnterpriseLab;
GO

SELECT * FROM Orders ORDER BY OrderID;
GO
```

Expected result:
- All rows are present
- Rows inserted before and after the differential backup are recovered