# 02_Migration_Execution_with_SqlPackage.md

## Objective

Execute the actual migration of the on-premises SQL Server database to Azure SQL Database using Microsoft SqlPackage (DAC framework). This step covers the export of schema and data into a BACPAC file, the import into Azure SQL Database, and downtime measurement.

## 2.1 Migration Tool Selection

The migration was executed using **SqlPackage**, the Microsoft-supported CLI tool for Data-tier Application (DAC) operations.

SqlPackage was selected because:
- It provides a deterministic offline migration approach
- It supports schema and data export/import via BACPAC
- It is suitable for small to medium-sized databases
- It incurs minimal Azure cost in a lab environment

Azure Database Migration Service (DMS) is documented conceptually as the recommended production-scale solution, while SqlPackage is used here for hands-on execution.

## 2.2 Export Database from On-Prem SQL Server

The source database `EnterpriseLab` was exported into a BACPAC file using SqlPackage. The export operation packages both schema and data.

```cmd
sqlpackage /Action:Export /SourceServerName:localhost /SourceDatabaseName:EnterpriseLab /SourceTrustServerCertificate:true /TargetFile:C:\Temp\EnterpriseLab.bacpac
```

The export process was executed against the on-premises SQL Server instance (localhost). The resulting BACPAC file contains the full database schema and all data rows.

## 2.3 Import into Azure SQL Database

The previously generated BACPAC file was imported into Azure SQL Database, creating the target database schema and loading all data.

```cmd
sqlpackage /Action:Import /TargetServerName:<YOUR_SERVER_NAME> /TargetDatabaseName:EnterpriseLabCloud /TargetUser:<YOUR_USER> /TargetPassword:<YOUR_PASSWORD> /TargetEncryptConnection:true /TargetTrustServerCertificate:true /SourceFile:C:\Temp\EnterpriseLab.bacpac
```

## 2.4 Downtime Definition and Measurement

For this lab, downtime was defined as the time window between:
- Start of the export operation
- Completion of the import operation

This definition reflects a full offline migration scenario where the source database is considered unavailable for changes during migration.

Observed Migration Duration:
- Dataset size: 200,000 rows
- Migration method: BACPAC export + import
- Total export + import duration: 54 seconds

This duration includes tooling overhead such as packaging, compression, encryption, network transfer, and Azure-side processing.

## Result

The on-premises SQL Server database was successfully migrated to Azure SQL Database using SqlPackage. The migration completed without errors, and all schema objects and data were transferred within an acceptable downtime window for a lab environment.