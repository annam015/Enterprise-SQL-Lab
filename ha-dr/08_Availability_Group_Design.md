# 08 – SQL Server Availability Group Design


## Objective

Define the architecture, design decisions, and high-availability strategy for the SQL Server Always On Availability Group implemented in this lab environment.
This document focuses on design rationale, RPO/RTO objectives, and failover behavior, aligned with enterprise best practices.

## Design Context

The Availability Group is designed to provide:
- High availability at the database level
- Automatic failover for critical workloads
- Minimal data loss
- Predictable recovery times

This design is intentionally simple to highlight core HA principles while remaining representative of real-world production deployments.

## Environment Summary

**Primary replica:** SQL1
**Secondary replica:** SQL2
**Failover cluster:** SQLCLUSTER
**Domain:** lab.local
**Database:** AG_Lab
**Availability Group name:** AG_Lab_Group

## Availability Group Topology

Replica Layout:

Replica	| Role	    | Location	| Purpose
SQL1	| Primary	| On-prem	| Read/write workload
SQL2	| Secondary	| On-prem	| High availability + failover

Both replicas are hosted within the same data center and connected through a low-latency network.

## Availability Mode Selection

**Selected Mode:** Synchronous Commit

Rationale:
- Guarantees zero data loss in failover scenarios
- Transactions commit on primary only after being hardened on secondary
- Suitable for low-latency, same-site deployments

Trade-offs:
- Slightly higher transaction latency
- Not suitable for geographically distant replicas

## Failover Configuration

**Failover Type:** Automatic Failover

Conditions:
- Both replicas configured for synchronous commit
- Windows Server Failover Cluster monitors replica health

Failover behavior:
- Automatic failover occurs if the primary replica becomes unavailable
- Secondary replica (SQL2) is promoted to primary
- Client connections are redirected automatically via AG listener (logical design)

## Read/Write Access Strategy

Primary replica (SQL1):
- Read/write access
- Hosts application write workload

Secondary replica (SQL2):
- No read workload configured in this lab
- Dedicated to availability and failover

## RPO and RTO Objectives

**Recovery Point Objective (RPO)**

Target RPO: ≈ 0 seconds

Justification:
- Synchronous commit ensures no committed transactions are lost
- Failover occurs only after data is hardened on both replicas

**Recovery Time Objective (RTO)**

Target RTO: < 60 seconds (lab estimate)

Justification:
- Automatic failover handled by WSFC
- No manual intervention required
- Database-level failover avoids full instance restart

## Limitations of the Lab Design

- No geographic redundancy
- No asynchronous replicas
- No read-only routing configured
- No AG listener implemented at OS level