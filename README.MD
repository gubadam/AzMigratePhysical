# AzMigratePhysical

## About
This module provides abity to manage agent-based (aka physical) migration using Azure Migrate.

## Getting Started
### Prerequisites
- [Powershell 7.2 or newer](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.3)
- [Azure Powershell modules](https://learn.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-9.2.0)

### Installation
``` Powershell
Import-Module -Name ".\AzMigratePhysical.psm1"
```

## Usage
Check out the [examples](Examples)

## Roadmap
- [x] Get a list of discovered servers
- [X] Start a replication of a discovered server
- [ ] Get replication status
- [ ] Update replicated server parameters
- [ ] Start migration of a replicated server
- [ ] Get migration status
- [ ] Stop replication