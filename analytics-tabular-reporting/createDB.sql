CREATE DATABASE ITSM_Analytics;
GO

USE ITSM_Analytics;
GO

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    Year INT,
    Month INT,
    MonthName VARCHAR(20),
    Day INT
);
GO

DECLARE @StartDate DATE = (SELECT MAX(FullDate) FROM DimDate);
DECLARE @EndDate DATE = DATEADD(DAY, 7, CAST(GETDATE() AS DATE));

IF @StartDate IS NULL
BEGIN
    SET @StartDate = DATEADD(MONTH, -6, CAST(GETDATE() AS DATE));
END

SET @StartDate = DATEADD(DAY, 1, @StartDate);

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (DateKey, FullDate, Year, Month, MonthName, Day)
    VALUES (
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
        @StartDate,
        YEAR(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DAY(@StartDate)
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

CREATE TABLE DimCategory (
    CategoryKey INT IDENTITY PRIMARY KEY,
    TicketType VARCHAR(20),
    Severity INT,
    Team VARCHAR(50)
);
GO

INSERT INTO DimCategory (TicketType, Severity, Team)
VALUES
('Incident', 1, 'Network'),
('Incident', 2, 'Network'),
('Incident', 3, 'Application'),
('Incident', 4, 'Application'),
('Request', 3, 'Service Desk'),
('Request', 4, 'Service Desk');
GO

CREATE TABLE FactTickets (
    TicketID INT IDENTITY PRIMARY KEY,
    OpenDateKey INT,
    CloseDateKey INT,
    CategoryKey INT,
    SLAHours INT,
    ResolutionHours INT,
    Status VARCHAR(20),
    CONSTRAINT FK_OpenDate FOREIGN KEY (OpenDateKey) REFERENCES DimDate(DateKey),
    CONSTRAINT FK_CloseDate FOREIGN KEY (CloseDateKey) REFERENCES DimDate(DateKey),
    CONSTRAINT FK_Category FOREIGN KEY (CategoryKey) REFERENCES DimCategory(CategoryKey)
);
GO

DECLARE @i INT = 1;

WHILE @i <= 500
BEGIN
    DECLARE @OpenDateTime DATETIME =
        DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 180, GETDATE());

    DECLARE @Resolution INT =
        ABS(CHECKSUM(NEWID())) % 72 + 1;

    DECLARE @SLA INT =
        CASE 
            WHEN @Resolution < 8 THEN 4
            WHEN @Resolution < 24 THEN 8
            ELSE 24
        END;

    DECLARE @CloseDateTime DATETIME =
        DATEADD(HOUR, @Resolution, @OpenDateTime);

    INSERT INTO FactTickets (
        OpenDateKey,
        CloseDateKey,
        CategoryKey,
        SLAHours,
        ResolutionHours,
        Status
    )
    SELECT
        CONVERT(INT, FORMAT(@OpenDateTime, 'yyyyMMdd')),
        CONVERT(INT, FORMAT(@CloseDateTime, 'yyyyMMdd')),
        CategoryKey,
        @SLA,
        @Resolution,
        CASE WHEN @Resolution <= @SLA THEN 'Closed' ELSE 'Breached' END
    FROM DimCategory
    ORDER BY NEWID()
    OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

    SET @i = @i + 1;
END;
GO

SELECT COUNT(*) FROM FactTickets;
GO

SELECT
    dc.TicketType,
    dc.Severity,
    COUNT(*) AS Tickets,
    AVG(ft.ResolutionHours) AS AvgResolutionHours
FROM FactTickets ft
JOIN DimCategory dc ON ft.CategoryKey = dc.CategoryKey
GROUP BY dc.TicketType, dc.Severity;
