function New-AzMigratePhysicalServerReplication {
    param (
        $TargetVmName,
        $TargetSubscriptionId = (Get-AzContext).Subscription.Id,
        $TargetResourceGroup,
        $TargetStorageAccount,
        $TargetStorageAccountResourceGroup,
        $TargetVnet,
        $TargetSubnet,
        $TargetLicenseType = "WindowsServer",
        $SubscriptionId = (Get-AzContext).Subscription.Id,
        $ResourceGroupName,
        $ProjectName,
        [DiscoveredServer]$DiscoveredServer
    )

    $projectParams = @{
        ResourceGroupName = $ResourceGroupName
        MigrateProject = $ProjectName
    }
    $migrateSolutionReplication = Get-AzMigratePhysicalSolution @projectParams | ? {$_.name -imatch 'Servers-Migration-ServerMigration_Replication' }
    $asrVault = Get-AzResource -ResourceId $migrateSolutionReplication.properties.details.extendedDetails.asrVaultId
    $asrVaultParams = @{
        ResourceGroupName = "rg-azMigrateTest"
        AsrVaultName = $asrVault.Name
    }
    $migrateReplicationFabric = Get-AzMigratePhysicalReplicationFabric @asrVaultParams | ? {$_.name -imatch $discoveredServer.FabricName}
    $replicatioContainerMapping = Get-AzMigratePhysicalReplicationContainerMapping @asrVaultParams | ? {$_.Properties.SourceFabricFriendlyName -imatch $migrateReplicationFabric.Properties.friendlyName}
    
    $vault = Get-AzRecoveryServicesVault -ResourceGroupName $asrVault.ResourceGroupName -Name $asrVault.Name
    Set-AzRecoveryServicesAsrVaultContext -Vault $vault | Out-Null
    $fabric = Get-AzRecoveryServicesAsrFabric -FriendlyName $migrateReplicationFabric.properties.friendlyName
    $protectionContainer = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $fabric
    $replicationProtectableItem = Get-AzRecoveryServicesAsrProtectableItem -ProtectionContainer $protectionContainer | ? {$_.FriendlyName -imatch $TargetVmName}

    $templateParams = @{
        targetSubscriptionID = $TargetSubscriptionId
        targetResourceGroup = $TargetResourceGroup
        targetStorageAccount = $TargetStorageAccount
        targetStorageAccountResourceGroup = $TargetStorageAccountResourceGroup
        azMigrateResourceGroup = $ResourceGroupName
        azMigrateVault = $vault.Name
        azMigrateReplicationFabric = $DiscoveredServer.fabricName
        azMigrateReplicationProtectionContainer = $DiscoveredServer.containerName
        azMigrateReplicationProtectableItem = $replicationProtectableItem.Name
        targetVnet = $TargetVnet
        targetAzureVmName = $TargetVmName
        masterTargetId = ($migrateReplicationFabric.properties.customDetails.masterTargetServers | Select -First 1).id
        processServerId = ($migrateReplicationFabric.properties.customDetails.processServers | Select -First 1).id
        licenseType = $TargetLicenseType
        targetAzureSubnetId = $TargetSubnet
        policyId = $replicatioContainerMapping.properties.policyId
        logStorageAccountId = "/subscriptions/${targetSubscriptionID}/resourceGroups/$TargetStorageAccountResourceGroup/providers/Microsoft.Storage/storageAccounts/${targetStorageAccount}"
        targetAzureNetworkId = "/subscriptions/${targetSubscriptionID}/resourceGroups/${targetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${targetVnet}"
        targetAzureV2ResourceGroupId = "/subscriptions/${targetSubscriptionID}/resourceGroups/${targetResourceGroup}"
        protectableItemId = $replicationProtectableItem.Id
        disksToInclude = @()
    }
    $templateParams.disksToInclude += $DiscoveredServer.Disks | ConvertFrom-Json | % {
        return @{
            diskId = $_.Id
            logStorageAccountId = $templateParams.logStorageAccountId
            diskType = 'Standard_LRS'
            diskEncryptionSetId = $null
        }
    }

    $deploymentParams = @{
        Name = "MigrateReplication-$TargetVmName-$(Get-Date -Format "yyyyMMdd-HHdd")" 
        ResourceGroupName = $ResourceGroupName 
        Mode = 'Incremental'
        TemplateFile = "$PSScriptRoot\templates\Microsoft.MigrateV2.PhysicalEnableMigrate.bicep"
        TemplateParameterObject = $templateParams
    }
    New-AzResourceGroupDeployment @deploymentParams
}