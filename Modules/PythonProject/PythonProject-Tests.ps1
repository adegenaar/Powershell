
BeforeAll {
    Import-Module $PSScriptRoot/PythonProject.psm1 -Force
}

Describe 'New-PythonProject' {
    BeforeEach {
        Start-Sleep -Seconds 5
        $folder = Join-Path $env:TEMP Test
        if (Test-Path $folder) {
            Remove-Item -Recurse -Force $folder
        }
    }
    It 'Create new project with no modules' {
        $folder = $env:TEMP
        Push-Location $folder
        New-PythonProject "Test"
        Test-Path -PathType Container $env:TEMP/Test | Should -Be $true
        Test-Path -PathType Container Src | Should -Be $true
        Test-Path -PathType Leaf Src/__init__.py | Should -Be $true
        Test-Path -PathType Container Tests | Should -Be $true
        Test-Path -PathType Leaf Tests/__init__.py | Should -Be $true
        Test-Path -PathType leaf .gitignore | Should -Be $true
        Test-Path -PathType leaf requirements-dev.txt | Should -Be $true
        Test-Path -PathType leaf requirements.txt | Should -Be $false
    }
    It 'Create new project with modules' {
        $folder = $env:TEMP
        Push-Location $folder
        New-PythonProject "Test" -modules httpx
        Test-Path -PathType Container $env:TEMP/Test | Should -Be $true
        Test-Path -PathType Container Src | Should -Be $true
        Test-Path -PathType Leaf Src/__init__.py | Should -Be $true
        Test-Path -PathType Container Tests | Should -Be $true
        Test-Path -PathType Leaf Tests/__init__.py | Should -Be $true
        Test-Path -PathType leaf .gitignore | Should -Be $true
        Test-Path -PathType leaf requirements-dev.txt | Should -Be $true
        Test-Path -PathType leaf requirements.txt | Should -Be $true
        $modules = Get-Content requirements.txt
        "httpx" -in $modules | Should -Be $true
    }
    It 'Update project with modules' {
        $folder = $env:TEMP
        Push-Location $folder
        New-PythonProject "Test" -modules httpx
        Set-Location $folder
        Update-PythonProject "Test" -modules httpx, Simple-Salesforce
        Test-Path -PathType Container $env:TEMP/Test | Should -Be $true
        Test-Path -PathType Container Src | Should -Be $true
        Test-Path -PathType Leaf Src/__init__.py | Should -Be $true
        Test-Path -PathType Container Tests | Should -Be $true
        Test-Path -PathType Leaf Tests/__init__.py | Should -Be $true
        Test-Path -PathType leaf .gitignore | Should -Be $true
        Test-Path -PathType leaf requirements-dev.txt | Should -Be $true
        Test-Path -PathType leaf requirements.txt | Should -Be $true
        $modules = Get-Content requirements.txt
        "httpx" -in $modules | Should -Be $true
        "Simple-Salesforce" -in $modules | Should -Be $true
    }
    AfterEach {
        Start-Sleep -Seconds 5
        if ($null -ne $env:VIRTUAL_ENV) {
            deactivate(1)
        }
        $folder = Join-Path $env:TEMP Test
        if (Test-Path $folder) {
            Remove-Item -Recurse -Force $folder
        }
        Pop-Location
    }
}

AfterAll {
    Start-Sleep -Seconds 5
    $folder = Join-Path $env:TEMP Test
    if (Test-Path $folder) {
        Remove-Item -Recurse -Force $folder
    }
}
