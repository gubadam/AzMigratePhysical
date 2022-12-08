Import-Module -Name "..\AzMigratePhysical.psm1"

$SubscriptionId = (Get-AzContext).Subscription.Id
$ResourceGroupName = "rg-azMigrateTest"
$ProjectName = "AzMigrateTest-EU"

$discoveredServersParams = @{
    SubscriptionId = (Get-AzContext).Subscription.Id
    ResourceGroupName = "rg-azMigrateTest"
    ProjectName = "AzMigrateTest-EU"
    DisplayName = 'vmtest02'
}
$discoveredServer = Get-AzMigratePhysicalDiscoveredServer @discoveredServersParams

$newReplicationParams = @{
    TargetVmName = 'vmtest02'
    TargetSubscriptionId = (Get-AzContext).Subscription.Id
    TargetResourceGroup = 'rg-azMigrate-testMigration-01'
    TargetStorageAccount = 'sttestmigration01'
    TargetVnet = 'vnet-azMigrate-testMigration-01'
    TargetSubnet = 'default'
    TargetLicenseType = "WindowsServer"
    SubscriptionId = $SubscriptionId
    ResourceGroupName = $ResourceGroupName
    ProjectName = $ProjectName
    DiscoveredServer = $discoveredServer
}

New-AzMigratePhysicalServerReplication @newReplicationParams