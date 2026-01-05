# 01 – Full Backup and Restore (Data Loss Simulation)

## Objective

Understand how a FULL database backup works and how to restore a database after accidental data loss. This chapter introduces the basic backup/restore workflow used in production environments.

This step builds on the database created in **00_Environment_Setup.md**.

## 1.1 Recovery Model – Introduction

Before performing advanced recovery operations, the database must use the **FULL recovery model**.

```sql
USE master;
GO

ALTER DATABASE EnterpriseLab SET RECOVERY FULL;
GO
```

The FULL recovery model ensures that all database transactions are fully logged in the transaction log.
After switching to FULL recovery, a new full backup is required to establish a valid baseline.

## 1.2. Full Database Backup

A FULL backup captures the entire database at a specific point in time.

```sql
BACKUP DATABASE EnterpriseLab TO DISK = 'C:\SQLBackups\EnterpriseLab_full.bak' WITH INIT;
GO
```

## 1.3 Simulating Data Loss (Incident)

To simulate a real production incident, all rows are deleted from the table.

```sql
USE EnterpriseLab;
GO

DELETE FROM Orders;
GO
```

Verify the table is empty:

```sql
SELECT * FROM Orders;
GO
```

## 1.4 Restore from Full Backup

To restore the database, existing connections must be terminated and the database must be overwritten.

```sql
USE master;
GO

ALTER DATABASE EnterpriseLab SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

RESTORE DATABASE EnterpriseLab FROM DISK = 'C:\SQLBackups\EnterpriseLab_full.bak' WITH REPLACE;
GO

ALTER DATABASE EnterpriseLab SET MULTI_USER;
GO
```

## 1.5 Validation

```sql
USE EnterpriseLab;
GO

SELECT * FROM Orders;
GO
```

Expected result:
- The original rows are visible again
- Data loss has been successfully recovered