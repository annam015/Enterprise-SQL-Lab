# 05 – SQL Server Installation and Configuration

## Objective

Install and configure Microsoft SQL Server on both cluster nodes (SQL1 and SQL2) to prepare the environment for high availability using Windows Server Failover Clustering (WSFC) and Always On Availability Groups.

## Environment Overview

**SQL Server nodes:** SQL1, SQL2
**Domain:** lab.local
**Cluster:** SQLCLUSTER
**Operating system:** Windows Server 2022 Standard (Evaluation)
**SQL Server edition:** Developer Edition (lab environment)

## Pre-Installation Verification

Before installation, the following conditions were verified on both SQL1 and SQL2:
- Node is joined to the lab.local domain
- Static IP address assigned
- DNS server configured to DC1 (192.168.56.10)
- WSFC feature installed and cluster is online

```powershell
systeminfo | findstr /B /C:"Domain"
Get-ClusterNode
```

## SQL Server Installation Scope

SQL Server was installed locally on each node using identical configuration to ensure symmetry.

Installed components:
- Database Engine Services
- SQL Server Agent
- Client Connectivity tools (basic)

## SQL Server Instance Configuration

**Instance type:** Default instance (MSSQLSERVER)
**Authentication mode:** Windows Authentication
**Sysadmin role:** Local Administrators group (domain administrators included)

This configuration simplifies lab setup while remaining compatible with Always On Availability Groups.

## SQL Server Service Validation

After installation, core SQL services were validated on both SQL1 and SQL2.

Required services:
- SQL Server (MSSQLSERVER)
- SQL Server Agent

## Network Protocol Verification

TCP/IP protocol is required for cluster communication and Availability Groups.

Validation steps:
- SQL Server Configuration Manager
- SQL Server Network Configuration
- Protocols for MSSQLSERVER
- TCP/IP enabled