---
external help file: PythonProject-help.xml
Module Name: PythonProject
online version:
schema: 2.0.0
---

# New-PythonProject

## SYNOPSIS
Create a new python project.

## SYNTAX

```powershell
New-PythonProject [-folder] <String> [[-modules] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creates a new Python project folder:

* Creates the Folder, if it doesn't exist
* If the virtual environment exists, upgrade the environment
* otherwise, create the virtual environment
* Activate the virtual environment
* Create a requirements-dev.txt and a requirements.txt
* use pip to install the requirements
* If they don't exist, create the src & test folders
* If they don't exist, create the __init__.py files in each

## EXAMPLES

### EXAMPLE 1

```powershell
New-PythonProject -folder MyPythonProject -modules Simple-Salesforce,httpx
```

### EXAMPLE 2

```powershell
New-PythonProject -folder MyPythonProject
```

## PARAMETERS

### -folder

folder - the name for the project folder

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -modules

modules - list of modules to be added to the requirements.txt

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to New-PythonProject.ps1

## OUTPUTS

### None

## NOTES

## RELATED LINKS
