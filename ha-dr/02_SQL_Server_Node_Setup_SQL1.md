# 02 - SQL Server Node Setup (SQL1)

## Objective

Prepare the first SQL Server node (SQL1) for High Availability and Disaster Recovery scenarios by configuring network settings, joining the Active Directory domain, and validating connectivity prerequisites for Windows Failover Clustering and Always On Availability Groups.

## Environment Overview

**Role**: Primary SQL Server node
**Domain**: lab.local
**Virtualization platform**: VirtualBox
**Network model**: Host-Only Network

## Virtual Machine Configuration (SQL1)

**VM name**: SQL1
**Operating system**: Windows Server 2022 Standard (Evaluation)
**Installation type**: Desktop Experience
**Hardware configuration**:
- CPU: 4 vCPU
- Memory: 8 GB RAM
- Disk: 80 GB (VHD)
- Network adapters: Host-Only Adapter (primary lab network)

## Server Identity

**Server name:** SQL1

```powershell
Rename-Computer -NewName SQL1 -Restart
```

## Network Configuration

A static IP address was assigned to ensure stable cluster and domain communication.

Host-only adapter configuration:
- IP address: 192.168.56.20
- Subnet mask: 255.255.255.0
- Default gateway: Not required
- Preferred DNS server: 192.168.56.10 (DC1)

Commands used:

Identify network interfaces:
```powershell
Get-NetAdapter
```

Assign static IP:
```powershell
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.56.20 -PrefixLength 24
```

Configure DNS:
```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.56.10
```

## Domain Join

SQL1 was joined to the Active Directory domain to enable cluster-based authentication and service coordination.

```powershell
Add-Computer -DomainName lab.local -Credential LAB\Administrator -Restart
```

## Post-Join Validation

Verify domain membership:
```powershell
systeminfo | findstr /B /C:"Domain"
```

Verify DNS resolution:
```powershell
ping dc1.lab.local
nslookup dc1.lab.local
```