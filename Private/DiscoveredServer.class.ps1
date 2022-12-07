Enum FabricType {
    HyperV
    Physical
    Other
    # ...
}

Class DiscoveredServer {
    $Id
    $Name
    $OsType
    $OsName
    $OsVersion
    $LastUpdatedTime
    $EnqueueTime
    $SolutionName
    $MachineId
    $MachineManagerId
    [FabricType]$FabricType
    $MachineName
    $IpAddresses
    $Fqdn
    $BiosId
    $MacAddresses
    $Disks
    $FabricName
    $FabricId
    $ContainerName
    $ContainerId
    $Generation
    $HostId
    $HostName
    $MicrosoftDiscovery
    $BootType
    $DiskDetails
    $MemoryDetails
    $SdsArmId

    DiscoveredServer(){
    }   
}