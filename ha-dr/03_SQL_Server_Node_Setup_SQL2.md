# 03 - SQL Server Node Setup (SQL2)

## Objective

Prepare the second SQL Server node (SQL2) for High Availability and Disaster Recovery scenarios, ensuring configuration parity with SQL1 for cluster stability and failover reliability.

## Environment Overview

**Role**: Secondary SQL Server node
**Domain**: lab.local
**Virtualization platform**: VirtualBox
**Network model**: Host-Only Network

## Virtual Machine Configuration (SQL2)

**VM name**: SQL2
**Operating system**: Windows Server 2022 Standard (Evaluation)
**Installation type**: Desktop Experience
**Hardware configuration**:
- CPU: 4 vCPU
- Memory: 8 GB RAM
- Disk: 80 GB (VHD)
- Network adapters: Host-Only Adapter (primary lab network)

## Server Identity

**Server name:** SQL2

```powershell
Rename-Computer -NewName SQL2 -Restart
```

## Network Configuration

Static IP configuration was applied to maintain deterministic networking and cluster consistency.

Host-only adapter configuration:
- IP address: 192.168.56.21
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
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.56.21 -PrefixLength 24
```

Configure DNS:
```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.56.10
```

## Domain Join

SQL2 was joined to the Active Directory domain to ensure authentication and cluster integration.

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