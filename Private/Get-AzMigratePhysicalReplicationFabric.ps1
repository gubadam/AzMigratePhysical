#requires -Module Az.Accounts
function Get-AzMigratePhysicalReplicationFabric {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ResourceGroupName,

        [Parameter(Mandatory)]
        $AsrVaultName,

        $SubscriptionId = (Get-AzContext).Subscription.Id
    )

    # $token = Get-AzCachedAccessToken
    $token = (Get-AzAccessToken).Token
    $url = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.RecoveryServices/vaults/$AsrVaultName/replicationFabrics?api-version=2021-11-01"
    
    $headers = New-Object 'System.Collections.Generic.Dictionary[[string],[string]]'
    $headers.Add("Authorization", "Bearer $Token")
    
    $response = Invoke-RestMethod -Uri $url -Headers $headers -ContentType "application/json" -Method "GET"

    $response.value
}