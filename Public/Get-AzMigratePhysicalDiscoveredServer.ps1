#requires -Module Az.Accounts
function Get-AzMigratePhysicalDiscoveredServer {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        $ResourceGroupName,

        [Parameter(Mandatory)]
        $MigrateProject,

        $SubscriptionId = (Get-AzContext).Subscription.Id,

        $DisplayName
    )

    # $token = Get-AzCachedAccessToken
    $token = (Get-AzAccessToken).Token
    $url = "https://management.azure.com/" + 
    "subscriptions/$SubscriptionId/" +
    "resourceGroups/$ResourceGroupName/" + 
    "providers/Microsoft.Migrate/" +
    "MigrateProjects/$MigrateProject" +
    "/machines?api-version=2020-06-01-preview&pageSize=9999&`$" +
    "filter=" +
    "(" +
    "(Properties/DiscoveryData/any(d: (d/FabricType eq 'Physical'))) " + # FabricType: {HyperV, Physical, Other, ...}
    "and ((not (Properties/MigrationData/any(m: m/MigrationPhase eq 'Replicating'))))" +
    ") " +
    "and ((not (Properties/MigrationData/any(m: (m/SolutionName eq 'Servers-Migration-ServerMigration') and (m/MigrationPhase eq 'Migrated')))))"
    $headers = New-Object 'System.Collections.Generic.Dictionary[[string],[string]]'
    $headers.Add("Authorization", "Bearer $Token")
    
    $response = Invoke-RestMethod -Uri $url -Headers $headers -ContentType "application/json" -Method "GET"

    if ($DisplayName) {
        $response = $response | Where-Object {$_.value.properties.discoveryData.machineName -imatch $DisplayName}
    }

    $discoveredMachines = @()
    foreach ($machine in $response.value) {
        $discoveredMachines += [PSCustomObject]@{
            Id = $machine.Id
            Name = $machine.Name
            OsType = $machine.properties.discoveryData.OsType
            OsName = $machine.properties.discoveryData.osName
            OsVersion = $machine.properties.discoveryData.osVersion
            LastUpdatedTime = $machine.properties.discoveryData.lastUpdatedTime
            EnqueueTime = $machine.properties.discoveryData.enqueueTime
            SolutionName = $machine.properties.discoveryData.solutionName
            MachineId = $machine.properties.discoveryData.machineId
            MachineManagerId = $machine.properties.discoveryData.machineManagerId
            FabricType = $machine.properties.discoveryData.fabricType
            MachineName = $machine.properties.discoveryData.machineName
            IpAddresses = $machine.properties.discoveryData.ipAddresses
            Fqdn = $machine.properties.discoveryData.fqdn
            BiosId = $machine.properties.discoveryData.biosId
            MacAddresses = $machine.properties.discoveryData.macAddresses
            Disks = $machine.properties.discoveryData.extendedInfo.Disks
            FabricName = $machine.properties.discoveryData.extendedInfo.fabricName
            FabricId = $machine.properties.discoveryData.extendedInfo.fabricId
            ContainerName = $machine.properties.discoveryData.extendedInfo.containerName
            ContainerId = $machine.properties.discoveryData.extendedInfo.containerId
            Generation = $machine.properties.discoveryData.extendedInfo.generation
            HostId = $machine.properties.discoveryData.extendedInfo.hostId
            HostName = $machine.properties.discoveryData.extendedInfo.hostName
            MicrosoftDiscovery = $machine.properties.discoveryData.extendedInfo.microsoftDiscovery
            BootType = $machine.properties.discoveryData.extendedInfo.bootType
            DiskDetails = $machine.properties.discoveryData.extendedInfo.diskDetails
            MemoryDetails = $machine.properties.discoveryData.extendedInfo.memoryDetails
            SdsArmId = $machine.properties.discoveryData.extendedInfo.sdsArmId
        }
    }

    return $discoveredMachines
}