#requires -Module Az.Accounts
function Get-AzMigratePhysicalReplicationContainerMapping {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ResourceGroupName,

        [Parameter(Mandatory)]
        $AsrVaultName,

        $SubscriptionId = (Get-AzContext).Subscription.Id
    )

    $token = (Get-AzAccessToken).Token
    $url = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.RecoveryServices/vaults/$AsrVaultName/replicationProtectionContainerMappings?api-version=2018-01-10"

    $headers = New-Object 'System.Collections.Generic.Dictionary[[string],[string]]'
    $headers.Add("Authorization", "Bearer $Token")
    
    $response = Invoke-RestMethod -Uri $url -Headers $headers -ContentType "application/json" -Method "GET"

    $response.value
}