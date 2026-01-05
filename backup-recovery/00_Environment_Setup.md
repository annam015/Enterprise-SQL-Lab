# 00 – Environment Setup + First Test Database

## Objective

Prepare the lab environment and create a small database with sample data that will be used in the next chapters (Backup/Restore, Diff/Log, Point-in-Time).

## 0.1 Connect to SQL Server (Server Core)

Because `sqlcmd` uses ODBC Driver 18 (encryption on by default), the lab connection uses the `-C` option (trust server certificate) for local/dev.

```cmd
sqlcmd -S localhost -E -C
```

## 0.2 Create a folder for backups (OS level)

Run in CMD (not inside sqlcmd):

```cmd
mkdir C:\SQLBackups
```

## 0.3 Create the database + a sample table with data

Run inside sqlcmd:

```sql
CREATE DATABASE EnterpriseLab;
GO
```

```sql
USE EnterpriseLab;
GO

CREATE TABLE Orders (
    OrderID   INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATETIME2 NOT NULL,
    Amount    DECIMAL(10,2) NOT NULL
);
GO
```

```sql
INSERT INTO Orders (OrderDate, Amount)
VALUES (SYSDATETIME(), 100.50), (SYSDATETIME(), 250.00);
GO
```

Check the data:

```sql
SELECT * FROM Orders;
GO
```