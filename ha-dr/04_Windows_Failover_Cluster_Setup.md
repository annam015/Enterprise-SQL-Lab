# 04 – Windows Server Failover Cluster (WSFC) Setup

## Objective

Configure and validate a Windows Server Failover Cluster (WSFC) using two domain-joined SQL Server nodes (SQL1 and SQL2).
This cluster provides the high-availability foundation required for SQL Server Always On Availability Groups.

## Environment Overview

**Cluster name**: SQLCLUSTER
**Cluster nodes**: SQL1, SQL2
**Domain**: lab.local
**Virtualization platform**: VirtualBox
**Network model**: Host-Only Network
**Cluster IP address**: 192.168.56.30

# Prerequisites

Before creating the cluster, the following conditions were verified:
Both SQL1 and SQL2:
- Are joined to the lab.local domain
- Have static IP addresses assigned
- Use DC1 (192.168.56.10) as their DNS server
Network connectivity and name resolution between nodes are functional.
SQL Server software is not yet installed (cluster creation is independent of SQL installation).

# Install Failover Clustering Feature

The Failover Clustering feature was installed on both SQL1 and SQL2.

```powershell
Install-WindowsFeature Failover-Clustering -IncludeManagementTools
```

Verification:

```powershell
Get-WindowsFeature Failover-Clustering
```

# Cluster Validation

Cluster validation was executed to ensure hardware, network, and system compatibility.
Validation was executed from SQL1.

```powershell
Test-Cluster -Node SQL1,SQL2
```
No critical errors were observed.
Validation confirmed that both nodes can participate in a failover cluster.
The generated validation report was reviewed before proceeding.

# Create the Failover Cluster

The Windows Server Failover Cluster was created using a static IP address.

```powershell
New-Cluster -Name SQLCLUSTER -Node SQL1,SQL2 -StaticAddress 192.168.56.30 -NoStorage
```

NoStorage was specified because SQL Server Always On Availability Groups do not require shared storage.
The cluster name and IP were registered automatically in Active Directory and DNS.

# Post-Creation Validation

Verify cluster status:
```powershell
Get-Cluster
```

Verify cluster nodes:
```powershell
Get-ClusterNode
```

DNS Validation:
```powershell
Resolve-DnsName SQLCLUSTER
```

Cluster groups overview:
```powershell
Get-ClusterGroup
```