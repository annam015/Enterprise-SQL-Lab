# 01 – Active Directory and DNS Setup (DC1)

## Objective

Create and configure the first Domain Controller (DC1) for the HA/DR lab environment, providing Active Directory Domain Services (AD DS) and DNS, required for SQL Server HA/DR scenarios.

## Environment Overview

**Virtualization platform:** VirtualBox
**Network model:** Host-Only Network (isolated lab network)

**Host-only network configuration:**
- Network: 192.168.56.0/24
- Gateway (host): 192.168.56.1
- DHCP: Disabled

## Virtual Machine Configuration (DC1)

**VM name:** DC1
**Operating system:** Windows Server 2022 Standard (Evaluation)
**Installation type:** Desktop Experience

**Hardware configuration:**
- CPU: 4 vCPU
- Memory: 4 GB RAM
- Disk: 50 GB (VHD)
- Network adapters: Host-Only Adapter

## Server Identity

```powershell
Rename-Computer -NewName DC1 -Restart
```
Renamed host. Server rebooted after rename.

## Network Configuration

A static IP address was assigned to ensure reliable domain and DNS operations.

Host-only adapter configuration:
- IP address: 192.168.56.10
- Subnet mask: 255.255.255.0
- Default gateway: (not required for host-only)
- Preferred DNS server: 192.168.56.10 (self)

The NAT adapter was used only for initial OS updates and does not participate in domain traffic.

Commands used:

Identify the Host-only adapter:
```powershell
Get-NetAdapter
```

Assign static IP for Host-Only Adapter:
```powershell
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.56.10 -PrefixLength 24
``` 

Configure DNS to point to itself:
```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses 192.168.56.10
```

## Install Active Directory Domain Services & DNS

Installed required roles:
```powershell
Install-WindowsFeature AD-Domain-Services,DNS -IncludeManagementTools
```

## Create Active Directory Domain

Promoted server to domain controller:
```powershell
Install-ADDSForest -DomainName "lab.local" -InstallDNS
```

## Post Installation Validation

Verified domain creation:
```powershell
Get-ADDomain
```

Verified DNS zones:
```powershell
Get-DnsServerZone
```

Verified domain membership:
```powershell
systeminfo | findstr /B /C:"Domain"
```
 
Domain controller diagnostics:
```powershell
dcdiag
```