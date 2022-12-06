#requires -Version 7.2

$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

Foreach ($import in @($Public + $Private)) {
    Write-Verbose $import
    Try {
        Write-Verbose -Message "Importing $($import.fullname)"
        . $import.fullname
        
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename