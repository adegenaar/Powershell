#requires -Version 2.0 -Modules PowerShellGet
function Remove-OldModules {
    [CmdletBinding()]
    param (
        # Adds the -Force param to Uninstall-Module.
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

    <#
.SYNOPSIS  

Removes older versions of installed modules

.DESCRIPTION


for each installed script or module

* get all versions installed
* find the latest
* remove the older versions 

.INPUTS

None. You cannot pipe objects to Remove-OldModules.

.OUTPUTS

None.

.EXAMPLE

PS> Remove-OldModules 

.EXAMPLE

PS> Remove-OldModules -Force

.LINK

https://learn.microsoft.com/en-us/powershell/module/powershellget/uninstall-module?view=powershellget-2.x

.LINK

https://learn.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershellget-2.x

.NOTES

additional info here

#>
}
