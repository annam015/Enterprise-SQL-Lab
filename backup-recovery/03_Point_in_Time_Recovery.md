# 03 – Point-in-Time Recovery

## Objective
Understand and demonstrate how to restore a SQL Server database to an exact moment in time, minimizing data loss after an incident.

This chapter builds on:
- **00_Environment_Setup.md**
- **01_Backup_and_Recovery.md**
- **02_Differential_and_Log.md**

## 3.1 What Is Point-in-Time Recovery

Point-in-time recovery allows restoring a database to a specific moment between two transactions, not just to the time of the last backup.

# 3.2 Preconditions

Point-in-time recovery is possible only if:
- The database uses the **FULL recovery model**
- Transaction log backups are available
- The restore process stops before the unwanted transaction

```sql
USE master;
GO

ALTER DATABASE EnterpriseLab SET RECOVERY FULL;
GO
```

# 3.3 Capture a Baseline Full Backup

```sql
BACKUP DATABASE EnterpriseLab TO DISK = 'C:\SQLBackups\EnterpriseLab_full.bak' WITH INIT;
GO
```

# 3.4 Generate Transactions with a Known Timeline

Insert a first row (this data should be recovered):

```sql
USE EnterpriseLab;
GO

INSERT INTO Orders (OrderDate, Amount) VALUES (SYSDATETIME(), 400.00);
GO
```

Wait a few seconds, then insert a second row (this will be the unwanted change):

```sql
INSERT INTO Orders (OrderDate, Amount) VALUES (SYSDATETIME(), 300.00);
GO
```

Verify current state:

```sql
SELECT * FROM Orders ORDER BY OrderID;
GO
```

# 3.5 Transaction Log Backup

Capture all transactions that occurred so far:

```sql
BACKUP LOG EnterpriseLab TO DISK = 'C:\SQLBackups\EnterpriseLab_log.trn' WITH INIT;
GO
```

# 3.6 Simulate Data Corruption

```sql
USE master;
GO

DROP DATABASE EnterpriseLab;
GO
```
Verify:

```sql
SELECT name FROM sys.databases;
GO
```

# 3.7 Restore to a Specific Point in Time

Step 1: Restore Full Backup (NORECOVERY)

```sql
RESTORE DATABASE EnterpriseLab FROM DISK = 'C:\SQLBackups\EnterpriseLab_full.bak' WITH NORECOVERY;
GO
```

Step 2: Restore Log Backup with STOPAT

```sql
RESTORE LOG EnterpriseLab FROM DISK = 'C:\SQLBackups\EnterpriseLab_log.trn' WITH STOPAT = 'YYYY-MM-DD HH:MM:SS', RECOVERY;
GO
```

Replace YYYY-MM-DD HH:MM:SS with a timestamp between the two INSERT operations.

## 3.8 Validation

```sql
USE EnterpriseLab;
GO

SELECT * FROM Orders ORDER BY OrderID;
GO
```

Expected result:
- The first row (400.00) exists
- The second row (300.00) does NOT exist