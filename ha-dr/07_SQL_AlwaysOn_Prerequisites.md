# 07 – SQL Server Always On Availability Groups – Prerequisites

## Objective

Enable and validate all SQL Server–level prerequisites required for configuring Always On Availability Groups.
This step ensures that both SQL Server instances are fully prepared to participate in a high-availability configuration built on Windows Server Failover Clustering (WSFC).

## Environment Overview

**SQL Nodes:** SQL1, SQL2
**Domain:** lab.local
**Failover Cluster:** SQLCLUSTER
**atabase prepared:** AG_Lab
**SQL Server Edition:** Developer Edition (lab environment)

## Enable Always On Availability Groups Feature

Always On Availability Groups must be explicitly enabled at the SQL Server instance level.

This operation was performed on both SQL1 and SQL2.

```powershell
Enable-SqlAlwaysOn -ServerInstance "SQL1" -Force
Enable-SqlAlwaysOn -ServerInstance "SQL2" -Force
```

The SQL Server service restarts automatically as part of this operation.

## Always On Feature Validation

After restart, Always On status was verified on both instances.

```sql
SELECT SERVERPROPERTY('IsHadrEnabled') AS IsAlwaysOnEnabled;
GO
```

## SQL Server Services Validation

Both SQL Server and SQL Server Agent services must be running.

```sql
SELECT servicename, status_desc
FROM sys.dm_server_services;
GO
```

## Endpoint Configuration (HADR)

SQL Server Availability Groups use database mirroring endpoints for replica communication.

Endpoint requirements:
- Protocol: TCP
- Port: 5022
- State: STARTED

```sql
SELECT name, state_desc, port
FROM sys.database_mirroring_endpoints;
GO
```

If required, endpoints are created automatically during AG creation.

## Endpoint Security Validation

Endpoints must allow CONNECT permissions for the SQL Server service account.

```sql
SELECT
    e.name AS EndpointName,
    p.permission_name,
    p.state_desc
FROM sys.database_mirroring_endpoints e
JOIN sys.endpoint_permissions p
    ON e.endpoint_id = p.endpoint_id;
GO
```

## Cluster Network Validation

Availability Groups rely on Windows Failover Cluster networks for client access and replica communication.

```powershell
Get-ClusterNetwork | Format-Table Name, Role, State
```

Expected configuration: At least one network configured as ClusterAndClient
Network state: Up

## Database State Validation

The database prepared in the previous step was validated for AG readiness.

Primary node (SQL1):

```sql
SELECT
    name,
    state_desc,
    recovery_model_desc
FROM sys.databases
WHERE name = 'AG_Lab';
GO
```

Expected result:
- State: ONLINE
- Recovery model: FULL

Secondary node (SQL2):

```sql
SELECT
    name,
    state_desc
FROM sys.databases
WHERE name = 'AG_Lab';
GO
```

Expected result:
- State: RESTORING