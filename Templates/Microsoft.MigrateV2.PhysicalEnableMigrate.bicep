param targetSubscriptionID string
param targetResourceGroup string
param targetStorageAccount string
param azMigrateResourceGroup string
param azMigrateVault string
param azMigrateReplicationFabric string
param azMigrateReplicationProtectionContainer string
param azMigrateReplicationProtectableItem string
param targetVnet string
param targetAzureVmName string
param masterTargetId string
param targetAzureSubnetId string
param processServerId string
param disksToInclude array

@allowed(['WindowsServer'])
param licenseType string = 'WindowsServer'

param policyId string
param logStorageAccountId string = '/subscriptions/${targetSubscriptionID}/resourceGroups/${targetResourceGroup}/providers/Microsoft.Storage/storageAccounts/${targetStorageAccount}'
param targetAzureNetworkId string = '/subscriptions/${targetSubscriptionID}/resourceGroups/${targetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${targetVnet}'
param targetAzureV2ResourceGroupId string = '/subscriptions/${targetSubscriptionID}/resourceGroups/${targetResourceGroup}'
param protectableItemId string = '/subscriptions/${targetSubscriptionID}/resourceGroups/${azMigrateResourceGroup}/providers/Microsoft.RecoveryServices/vaults/${azMigrateVault}/replicationFabrics/${azMigrateReplicationFabric}/replicationProtectionContainers/${azMigrateReplicationProtectionContainer}/replicationProtectableItems/${azMigrateReplicationProtectableItem}'

resource ReplicationProtectableItem 'Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectedItems@2022-05-01' = {
  name: '${azMigrateVault}/${azMigrateReplicationFabric}/${azMigrateReplicationProtectionContainer}/${azMigrateReplicationProtectableItem}'
  properties: {
    policyId: policyId
    providerSpecificDetails: {
      instanceType: 'InMageAzureV2'
      logStorageAccountId: logStorageAccountId
      masterTargetId: masterTargetId
      licenseType: licenseType
      disksToInclude: disksToInclude
      processServerId: processServerId
      runAsAccountId: '1'
      targetAzureNetworkId: targetAzureNetworkId
      targetAzureSubnetId: targetAzureSubnetId
      targetAzureV2ResourceGroupId: targetAzureV2ResourceGroupId
      targetAzureVmName: targetAzureVmName
      targetVmTags: {
      }
      targetNicTags: {
      }
    }
    protectableItemId: protectableItemId
  }
}
