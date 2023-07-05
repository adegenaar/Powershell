<#PSScriptInfo
.VERSION 0.1.0
.GUID bf663505-5248-4a03-8ebd-8833966425ac
.AUTHOR adegenaar@degenaar.com
.COMPANYNAME CHAOS, Inc.
.COPYRIGHT (c) Albert Degenaar. All rights reserved.
.TAGS Python
.LICENSEURI
.PROJECTURI
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<#
.DESCRIPTION
 Create a new python project.
#>


[CmdletBinding()]
param(
    [Parameter(Mandatory = $True)]
    [string]
    $folder,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]
    $modules
)

# Create the folder if doesn't exist yet
If (!(Test-Path -Path $folder)) {
    New-Item -ItemType Directory -Path $folder
}

Set-Location -Path $folder

if (Test-Path -Path ".venv") {
    & "py.exe" -m venv --upgrade .venv
}
else {
    & 'py.exe' -m venv .venv
}

& ".\.venv\scripts\activate.ps1"

#setup the requirements-dev & requirements files, if necessary
if (-not(Test-Path -Path ".\requirements-dev.txt")) {
    $devmodules = "wheel", "pip", "setuptools", "black", "pytest", "pytest-cov", "pylint"
    foreach ($devmodule in $devmodules) {
        "$devmodule" | Out-File -FilePath .\requirements-dev.txt -Append
    }
}
& 'pip' install --upgrade -r requirements-dev.txt

if (-not(Test-Path -Path ".\requirements.txt")) {
    foreach ($module in $modules) {
        "$module" | Out-File -FilePath .\requirements.txt -Append
    }
}
& 'pip' install --upgrade -r requirements.txt

# Create the tests folder if doesn't exist yet
If (!(Test-Path -Path "tests")) {
    New-Item -ItemType Directory -Path "tests"
}

# Create the __init__.py if doesn't exist yet
if (!(Test-Path -Path "tests\__init__.py")) {
    New-Item -ItemType File -Path "tests" -Name "__init__.py" -Value "# Needed for the operation of the tests"
}

# Create the tests folder if doesn't exist yet
If (!(Test-Path -Path "src")) {
    New-Item -ItemType Directory -Path "src"
}

# Create the __init__.py if doesn't exist yet
if (!(Test-Path -Path "src\__init__.py")) {
    New-Item -ItemType File -Path "src" -Name "__init__.py" -Value "# Needed for the operation of the packaging"
}