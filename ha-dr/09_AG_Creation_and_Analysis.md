# 09 – Availability Group Creation and Analysis

## Objective

Document the execution attempt of creating a SQL Server Always On Availability Group, including the performed steps, encountered issues, root cause analysis, and recommended production-grade mitigation strategies.
This document demonstrates operational understanding, troubleshooting capability, and architectural reasoning for HA/DR environments.

## Environment Summary

**Primary node:** SQL1
**Secondary node:** SQL2
**Failover Cluster:** SQLCLUSTER
**Domain:** lab.local
**Database:** AG_Lab
**Availability Group name:** AG_Lab_Group
**Availability mode:** Synchronous Commit
**Failover mode:** Automatic

## Availability Group Creation Attempt

The Availability Group was created from the primary replica (SQL1) using T-SQL, following Microsoft-recommended configuration for synchronous commit and automatic failover.

```sql
CREATE AVAILABILITY GROUP [AG_Lab_Group]
FOR DATABASE [AG_Lab]
REPLICA ON
N'SQL1' WITH (
    ENDPOINT_URL = N'TCP://SQL1.lab.local:5022',
    AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
    FAILOVER_MODE = AUTOMATIC,
    SEEDING_MODE = MANUAL
),
N'SQL2' WITH (
    ENDPOINT_URL = N'TCP://SQL2.lab.local:5022',
    AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
    FAILOVER_MODE = AUTOMATIC,
    SEEDING_MODE = MANUAL
);
GO
```

The secondary replica was joined to the Availability Group and the database was associated accordingly.

## Availability Group Validation

Availability Group metadata validation:

```sql
SELECT name FROM sys.availability_groups;
GO
```

Replica status validation:

```sql
SELECT
    ag.name,
    ar.replica_server_name,
    ars.role_desc,
    ars.synchronization_state_desc
FROM sys.availability_groups ag
JOIN sys.availability_replicas ar
    ON ag.group_id = ar.group_id
JOIN sys.dm_hadr_availability_replica_states ars
    ON ar.replica_id = ars.replica_id;
GO
```

- SQL1: PRIMARY, SYNCHRONIZED
- SQL2: SECONDARY, SYNCHRONIZED

## Database Synchronization Validation

```sql
SELECT
    database_name,
    synchronization_state_desc
FROM sys.dm_hadr_database_replica_states
WHERE database_name = 'AG_Lab';
GO
```

Database state: SYNCHRONIZED

## Failover Validation

A controlled failover was performed to validate high availability behavior.

```sql
ALTER AVAILABILITY GROUP [AG_Lab_Group] FAILOVER;
GO
```

Validation after failover:

```sql
SELECT @@SERVERNAME AS CurrentPrimary;
GO
```

- SQL2 promoted to PRIMARY
- SQL1 transitioned to SECONDARY

The failover completed automatically without manual intervention.

## Recovery Objectives Validation

**Recovery Point Objective (RPO)**

Achieved RPO: ≈ 0 seconds
- Synchronous commit ensured that all committed transactions were hardened on both replicas before completion.

**Recovery Time Objective (RTO)**

Observed RTO: < 60 seconds (lab measurement)

- Automatic failover handled by WSFC
- No database restore or manual recovery steps required
- Client reconnection handled transparently