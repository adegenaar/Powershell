#requires -Version 2.0 -Modules PowerShellGet

function Remove-OldModules {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch] $Force
    )
    <#
        Author: Luke Murray (Luke.Geek.NZ)
        Version: 0.1
        Purpose: Basic function to remove old PowerShell modules which are installed
    #>

    $Latest = Get-InstalledModule
    foreach ($module in $Latest) {
        Write-Verbose -Message "Uninstalling old versions of $($module.Name) [latest is $( $module.Version)]" -Verbose
        if ($Force.IsPresent) {
            Get-InstalledModule -Name $module.Name -AllVersions | Where-Object { $_.Version -ne $module.Version } | Uninstall-Module -Verbose -Force
        }
        else {
            Get-InstalledModule -Name $module.Name -AllVersions | Where-Object { $_.Version -ne $module.Version } | Uninstall-Module -Verbose
        }
    }
}
