function New-PythonProject {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        # folder - the name for the project folder
        [Parameter(Mandatory = $true)]
        [string]
        $folder,

        # modules - list of modules to be added to the requirements.txt
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]
        $modules
    )

    begin {
        # Check and see if the folder already exists
        $FolderExists = Test-Path -Path $folder 
    }


    process {
        If (!$FolderExists) {
            if ($PSCmdlet.ShouldProcess($folder, 'Create New Python Project Folder')) {
                New-Item -ItemType Directory -Path $folder -ErrorAction SilentlyContinue > $null
            }
        }

        if ($PSCmdlet.ShouldProcess($folder, "cd to $folder")) {
            Set-Location -Path $folder
        }
        $VirtualEnv = '.venv'
        if (Test-Path -Path $VirtualEnv) {
            if ($PSCmdlet.ShouldProcess(
                ('Updating existing Python virtual environment {0}' -f $VirtualEnv),
                    'Are you sure?', 
                    'Upgrade Virtual Environment'
                )
            ) {
                & 'py.exe' -m venv --upgrade $VirtualEnv
            }
        }
        else {
            if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating new Python virtual environment')) {
                & 'py.exe' -m venv $VirtualEnv
            }
        }
        if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Activating Python virtual environment')) {
            & ".\$VirtualEnv\scripts\activate.ps1"
        }

        if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating the requirements files')) {
            if (-not(Test-Path -Path '.\requirements-dev.txt')) {
                Write-Verbose 'Creating requirements-dev.txt'
                $devmodules = 'wheel', 'pip', 'setuptools', 'black', 'pytest', 'pytest-cov', 'pylint'
                foreach ($devmodule in $devmodules) {
                    "$devmodule" | Out-File -FilePath .\requirements-dev.txt -Append
                }
            }
            & 'pip' install --upgrade -r requirements-dev.txt

            if (-not(Test-Path -Path '.\requirements.txt')) {
                Write-Verbose 'Creating requirements.txt'
                foreach ($module in $modules) {
                    Write-Output "Adding $module "
                    "$module" | Out-File -FilePath .\requirements.txt -Append
                }
            }
            else {
                Write-Verbose 'Validating requirements.txt'
                # upgrade the requirements.txt
                $installed_modules = pip list --format=json | ConvertFrom-Json
                foreach ($module in $modules) {
                    if ($module -in $installed_modules.Name) {
                        Write-Verbose "Skipping existing $module"
                    }
                    else {
                        # add the module to the requirements.txt
                        Write-Verbose "Adding $module to requirements.txt"
                        "$module" | Out-File -FilePath .\requirements.txt -Append
                    }
                }
                & 'pip' install --upgrade -r requirements.txt
            }
        }

        # Create the test folder if doesn't exist yet
        If (!(Test-Path -Path 'Tests')) {
            if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating the Tests folder')) {
                Write-Verbose 'Creating Tests folder'
                New-Item -ItemType Directory -Path 'Tests' -ErrorAction SilentlyContinue > $null
            }
        }
        
        # Create the __init__.py file if doesn't exist yet
        if (!(Test-Path -Path 'Tests\__init__.py')) {
            if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating the Tests\__init__.py file')) {
                Write-Verbose 'Creating Tests\__init__.py file'
                New-Item -ItemType File -Path 'tests' -Name '__init__.py' -Value '# Needed for the operation of the tests' -ErrorAction SilentlyContinue > $null
            }
        }
        # Create the Src folder if doesn't exist yet
        If (!(Test-Path -Path 'src')) {
            if ($PSCmdlet.ShouldProcess('.\Src', 'Creating the Src folder')) {
                Write-Verbose 'Creating Src folder'
                New-Item -ItemType Directory -Path 'Src' -ErrorAction SilentlyContinue > $null
            }
        }

        # Create the __init__.py if doesn't exist yet
        if (!(Test-Path -Path 'Src\__init__.py')) {
            if ($PSCmdlet.ShouldProcess('.\Src', 'Creating the Src\__init__.py file')) {
                Write-Verbose 'Creating Src\__init__.py file'
                New-Item -ItemType File -Path 'src' -Name '__init__.py' -Value '# Needed for the operation of the packaging' -ErrorAction SilentlyContinue > $null
            }
        }
    }


    end {

    }


    <#
.SYNOPSIS

 Create a new python project.

.DESCRIPTION

 Creates a new Python project folder:
 * Creates the Folder, if it doesn't exist
 * If the virtual environment exists, upgrade the environment
 * otherwise, create the virtual environment
 * Activate the virtual environment
 * Create a requirements-dev.txt and a requirements.txt
 * use pip to install the requirements
 * If they don't exist, create the src & test folders
 * If they don't exist, create the __init__.py files in each

.INPUTS

None. You cannot pipe objects to New-PythonProject.ps1.

.OUTPUTS

None. 

.EXAMPLE

PS> New-PythonProject -folder MyPythonProject -modules Simple-Salesforce

.EXAMPLE

PS> New-PythonProject -folder MyPythonProject

#>
}