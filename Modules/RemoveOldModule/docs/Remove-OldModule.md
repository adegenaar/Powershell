---
external help file: RemoveOldModules-help.xml
Module Name: RemoveOldModules
online version: https://learn.microsoft.com/en-us/powershell/module/powershellget/uninstall-module?view=powershellget-2.x
schema: 2.0.0
---

# Remove-OldModule

## SYNOPSIS

Removes older versions of installed modules

## SYNTAX

```powershell
Remove-OldModule [-Force] [<CommonParameters>]
```

## DESCRIPTION

for each installed script or module

* get all versions installed
* find the latest
* remove the older versions

## EXAMPLES

### EXAMPLE 1

```powershell
Remove-OldModule
```

### EXAMPLE 2

```powershell
Remove-OldModule -Force
```

## PARAMETERS

### -Force

Adds the -Force param to Uninstall-Module.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Remove-OldModule

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[https://learn.microsoft.com/en-us/powershell/module/powershellget/uninstall-module?view=powershellget-2.x](https://learn.microsoft.com/en-us/powershell/module/powershellget/uninstall-module?view=powershellget-2.x)

[https://learn.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershellget-2.x](https://learn.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershellget-2.x)
