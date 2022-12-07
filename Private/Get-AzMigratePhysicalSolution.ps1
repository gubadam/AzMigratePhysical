#requires -Module Az.Accounts
function Get-AzMigratePhysicalSolution {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ResourceGroupName,

        [Parameter(Mandatory)]
        $MigrateProject,

        $SubscriptionId = (Get-AzContext).Subscription.Id,

        $DisplayName
    )

    $token = (Get-AzAccessToken).Token
    $url = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Migrate/MigrateProjects/$MigrateProject/solutions?api-version=2020-06-01-preview"
    $headers = New-Object 'System.Collections.Generic.Dictionary[[string],[string]]'
    $headers.Add("Authorization", "Bearer $Token")
    
    $response = Invoke-RestMethod -Uri $url -Headers $headers -ContentType "application/json" -Method "GET"

    return $response.value
}