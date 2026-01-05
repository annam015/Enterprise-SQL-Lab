CREATE DATABASE EnterpriseLab;
GO

CREATE DATABASE EnterpriseDWH;
GO

USE EnterpriseLab;
GO

CREATE TABLE dbo.Orders (
    OrderID   INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATETIME2 NOT NULL,
    Amount    INT NOT NULL
);
GO

SET NOCOUNT ON;
GO

DECLARE @i INT = 1;

WHILE @i <= 200000
BEGIN
    INSERT INTO dbo.Orders (OrderDate, Amount)
    VALUES (
        DATEADD(MINUTE, -@i, SYSDATETIME()),
        ABS(CHECKSUM(NEWID())) % 1000 + 1
    );

    SET @i += 1;
END;
GO

USE EnterpriseDWH;
GO

CREATE TABLE dbo.FactOrders (
    OrderID   INT NOT NULL,
    OrderDate DATETIME2 NOT NULL,
    Amount    INT NOT NULL
);
GO

CREATE TABLE dbo.FactOrders_ByHour (
    HourBucket  DATETIME2(0) NOT NULL,
    OrdersCount INT          NOT NULL,
    TotalAmount BIGINT       NOT NULL,
    AvgAmount   DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_FactOrders_ByHour PRIMARY KEY (HourBucket)
);
GO
