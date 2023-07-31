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
        # check for indications that this is not a new installation
        If ($FolderExists) {
            Write-Error ("$Folder already exists.  Use Update-PythonProject to modify")
            return
        }

        if ($PSCmdlet.ShouldProcess($folder, 'Create New Python Project Folder')) {
            New-Item -ItemType Directory -Path $folder -ErrorAction SilentlyContinue > $null
            Set-Location -Path $folder
        }

        $VirtualEnv = '.venv'
        if (Test-Path -Path $(Join-Path $pwd $VirtualEnv)) {
            Write-Error ("$VirtualEnv already exists.  Use Update-PythonProject to modify")
            return
        }

        $VirtualEnv = 'src\.venv'
        if (Test-Path -Path $(Join-Path $pwd $VirtualEnv)) {
            Write-Error ("$VirtualEnv already exists.  Use Update-PythonProject to modify")
            return
        }

        ###############################
        # setup the folder structures #
        ###############################

        # Create the test folder if doesn't exist yet
        If (!(Test-Path -Path 'tests')) {
            if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating the tests folder')) {
                Write-Verbose 'Creating tests folder'
                New-Item -ItemType Directory -Path 'tests' -ErrorAction SilentlyContinue > $null
            }
        }

        # Create the __init__.py file if doesn't exist yet
        if (!(Test-Path -Path 'tests\__init__.py')) {
            if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating the Tests\__init__.py file')) {
                Write-Verbose 'Creating Tests\__init__.py file'
                New-Item -ItemType File -Path 'tests' -Name '__init__.py' -Value '# Needed for the operation of the tests' -ErrorAction SilentlyContinue > $null
            }
        }

        # Create the src folder if doesn't exist yet
        If (!(Test-Path -Path 'src')) {
            if ($PSCmdlet.ShouldProcess('src', 'Creating the src folder')) {
                Write-Verbose 'Creating src folder'
                New-Item -ItemType Directory -Path $(Join-Path $pwd 'src') -ErrorAction SilentlyContinue > $null
                #Set-Location -Path $(Join-Path $pwd 'src')
            }
        }

        # Create the __init__.py if doesn't exist yet
        if (!(Test-Path -Path 'src\__init__.py')) {
            if ($PSCmdlet.ShouldProcess('src', 'Creating the src\__init__.py file')) {
                Write-Verbose 'Creating src\__init__.py file'
                New-Item -ItemType File -Path 'src' -Name '__init__.py' -Value '# Needed for the operation of the packaging' -ErrorAction SilentlyContinue > $null
            }
        }

        # If there is a virtual environment active, turn it off
        if ($null -ne $env:VIRTUAL_ENV) {
            try {
                deactivate(1)
            }
            finally {}
        }

        if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating new Python virtual environment')) {
            & py.exe -m venv $VirtualEnv --upgrade-deps
            & ".\$VirtualEnv\scripts\activate.ps1"
            & python.exe -m pip install --upgrade pip
        }

        if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating the requirements files')) {
            if (!(Test-Path -Path '.\requirements-dev.txt')) {
                Write-Verbose 'Creating requirements-dev.txt'
                $devmodules = 'wheel', 'setuptools', 'black', 'pytest', 'pytest-cov', 'pylint'
                foreach ($devmodule in $devmodules) {
                    "$devmodule" | Out-File -FilePath .\requirements-dev.txt -Append
                }
            }
            & pip install --upgrade -r requirements-dev.txt

            if (!(Test-Path -Path '.\requirements.txt')) {
                Write-Verbose 'Creating requirements.txt'
                foreach ($module in $modules) {
                    Write-Output "Adding $module "
                    "$module" | Out-File -FilePath .\requirements.txt -Append
                }
            }
        }

        # Create the readme.md if doesn't exist yet
        If (!(Test-Path -Path 'readme.md')) {
            if ($PSCmdlet.ShouldProcess('readme.md', 'Creating the project readme.md file')) {
                $content = @" 
# $Folder

Sample readme
"@ 
                Set-Content '.\readme.md' $content  
            }
        }
        
        # Create the .gitignore if doesn't exist yet
        If (!(Test-Path -Path '.gitignore')) {
            if ($PSCmdlet.ShouldProcess('.gitignore', 'Creating the Python .gitignore file')) {
                Invoke-WebRequest -Uri https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore -OutFile '.gitignore'
            }
        }

        # Create the readme.md if doesn't exist yet
        If (!(Test-Path -Path 'pyproject.toml')) {
            if ($PSCmdlet.ShouldProcess('pyproject.toml', 'Creating the pyproject.toml file')) {
                $content = @"
[project]
name = "$Folder"
version = "0.0.1"
description = "Replace me with an interesting description"
authors = [
    {name = "Albert Degenaar", email = "albert.w.degenaar@accenture.com"},
]
readme = "README.md"
requires-python = ">=3.10"
license = {text = "BSD-3-Clause"}

classifiers = [
    "Programming Language :: Python :: 3",
]

[tool.setuptools.packages]
find = {}  # Scanning implicit namespaces is active by default
"@
                Set-Content 'pyproject.toml' $content  
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
 * If the virtual environment does not exist, create the virtual environment
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

PS> New-PythonProject -folder MyPythonProject -modules httpx,Simple-Salesforce

.EXAMPLE

PS> New-PythonProject -folder MyPythonProject

#>
}

function Update-PythonProject {

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
            Write-Error ("$folder does not exist - Use New-PythonProject for creating a new python project")
            return
        }

        if ($PSCmdlet.ShouldProcess($folder, "cd to $folder")) {
            Set-Location -Path $folder
        }

        $VirtualEnv = '.venv'
        if ($null -ne $env:VIRTUAL_ENV) {
            deactivate(1)
        }

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

        if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Activating Python virtual environment')) {
            & ".\$VirtualEnv\scripts\activate.ps1"
        }

        if ($PSCmdlet.ShouldProcess($VirtualEnv, 'Creating the requirements files')) {
            if (-not(Test-Path -Path '.\requirements.txt')) {
                Write-Verbose 'Creating requirements.txt'
                foreach ($module in $modules) {
                    Write-Output "Adding $module "
                    "$module" | Out-File -FilePath .\requirements.txt -Append
                }
            }
            else {
                Write-Verbose 'Updating requirements.txt'
                # get the list of installed modules and check to see if the modules have already been installed
                # todo: it may be a better idea to process the requirements.txt file directly (revisit after using this awhile)
                # $installed_modules = $(pip list --format=json | ConvertFrom-Json).Name
                $installed_modules = Get-Content requirements.txt
                foreach ($module in $modules) {
                    if ($module -in $installed_modules) {
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

        # Create the .gitignore if doesn't exist yet
        If (!(Test-Path -Path '.gitignore')) {
            if ($PSCmdlet.ShouldProcess('.gitignore', 'Creating the Python .gitignore file')) {
                Invoke-WebRequest -Uri https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore -OutFile '.gitignore'
            }
        }
    }


    end {

    }


    <#
.SYNOPSIS

 Update an existing python project.

.DESCRIPTION

 Updates an existing Python project folder:

 * If the folder already exists, error
 * If the virtual environment exists, upgrade the environment
 * otherwise, error
 * Activate the virtual environment
 * Create a requirements-dev.txt and a requirements.txt if they don't exist
 * upgrade the requirements.txt with the modules if it already exists
 * use pip to install the requirements
 * If they don't exist, create the src & test folders
 * If they don't exist, create the __init__.py files in each

.INPUTS

None. You cannot pipe objects to Update-PythonProject.ps1.

.OUTPUTS

None.

.EXAMPLE

PS> Update-PythonProject -folder MyPythonProject -modules Simple-Salesforce

.EXAMPLE

PS> Update-PythonProject -folder MyPythonProject

#>
}
