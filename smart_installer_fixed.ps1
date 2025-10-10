# Smart Installer for Manga Image Translator
# This script automatically installs all required dependencies

param(
    [switch]$SkipPython,
    [switch]$SkipTesseract,
    [switch]$SkipGit,
    [switch]$Verbose,
    [switch]$TestOnly
)

# Auto-elevate to Administrator if not already running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($PSBoundParameters.Count -gt 0) {
        $arguments += " " + ($PSBoundParameters.GetEnumerator().ForEach({"-$($_.Key) $($_.Value)"}) -join " ")
    }
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    exit
}

# Set error handling and progress preferences
$ErrorActionPreference = "Continue"
$ProgressPreference = "Continue"

# Color functions for better output
function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Cyan
}

# Function to refresh environment variables
function Update-EnvironmentPath {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if (Get-Command refreshenv -ErrorAction SilentlyContinue) {
        refreshenv
    }
}

# Check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Install Chocolatey package manager
function Install-Chocolatey {
    Write-Info "Checking Chocolatey..."
    
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Success "Chocolatey is already installed"
        return $true
    }
    
    Write-Info "Installing Chocolatey..."
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Update PATH immediately
        Update-EnvironmentPath
        
        # Verify installation
        Start-Sleep -Seconds 3
        if (Get-Command choco -ErrorAction SilentlyContinue) {
            Write-Success "Chocolatey installed successfully"
            return $true
        } else {
            Write-Error "Failed to verify Chocolatey installation"
            return $false
        }
    } catch {
        Write-Error "Error installing Chocolatey: $($_.Exception.Message)"
        return $false
    }
}

# Install Python 3.11
function Install-Python {
    if ($SkipPython) {
        Write-Info "Skipping Python installation"
        return $true
    }
    
    Write-Info "Checking Python..."
    
    # Check if Python 3.11 is already installed
    try {
        $pythonVersion = python --version 2>&1
        if ($pythonVersion -match "Python 3\.11") {
            Write-Success "Python 3.11 is already installed: $pythonVersion"
            return $true
        }
    } catch {
        # Python not found, continue with installation
    }
    
    Write-Info "Installing Python 3.11..."
    try {
        # Only use --force if Python test fails
        if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
            choco install python311 -y --force
        } else {
            choco install python311 -y
        }
        
        # Update PATH immediately
        Update-EnvironmentPath
        
        # Verify installation
        Start-Sleep -Seconds 5
        $pythonVersion = python --version 2>&1
        if ($pythonVersion -match "Python 3\.11") {
            Write-Success "Python installed successfully: $pythonVersion"
            return $true
        } else {
            Write-Error "Failed to verify Python installation. Got: $pythonVersion"
            return $false
        }
    } catch {
        Write-Error "Error installing Python: $($_.Exception.Message)"
        return $false
    }
}

# Install Git
function Install-Git {
    if ($SkipGit) {
        Write-Info "Skipping Git installation"
        return $true
    }
    
    Write-Info "Checking Git..."
    
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $gitVersion = git --version
        Write-Success "Git is already installed: $gitVersion"
        return $true
    }
    
    Write-Info "Installing Git..."
    try {
        choco install git -y
        
        # Update PATH immediately
        Update-EnvironmentPath
        
        # Verify installation
        Start-Sleep -Seconds 5
        if (Get-Command git -ErrorAction SilentlyContinue) {
            $gitVersion = git --version
            Write-Success "Git installed successfully: $gitVersion"
            return $true
        } else {
            Write-Error "Failed to verify Git installation"
            return $false
        }
    } catch {
        Write-Error "Error installing Git: $($_.Exception.Message)"
        return $false
    }
}

# Check and install Tesseract
function Install-Tesseract {
    if ($SkipTesseract) {
        Write-Info "Skipping Tesseract installation"
        return $true
    }
    
    Write-Info "Checking Tesseract..."
    
    if (Get-Command tesseract -ErrorAction SilentlyContinue) {
        $tesseractVersion = tesseract --version 2>&1 | Select-Object -First 1
        Write-Success "Tesseract is already installed: $tesseractVersion"
        return $true
    }
    
    Write-Info "Installing Tesseract..."
    try {
        choco install tesseract -y
        
        # Update PATH immediately
        Update-EnvironmentPath
        
        # Verify installation
        Start-Sleep -Seconds 5
        if (Get-Command tesseract -ErrorAction SilentlyContinue) {
            $tesseractVersion = tesseract --version 2>&1 | Select-Object -First 1
            Write-Success "Tesseract installed successfully: $tesseractVersion"
            return $true
        } else {
            Write-Error "Failed to verify Tesseract installation"
            return $false
        }
    } catch {
        Write-Error "Error installing Tesseract: $($_.Exception.Message)"
        return $false
    }
}

# Download and install Tesseract language packs
function Install-TesseractLanguages {
    Write-Info "Installing Tesseract language packs..."
    
    # Find Tesseract installation path
    $tesseractPath = ""
    $possiblePaths = @(
        "C:\Program Files\Tesseract-OCR",
        "C:\Program Files (x86)\Tesseract-OCR",
        "C:\tools\tesseract"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            $tesseractPath = $path
            break
        }
    }
    
    if (-not $tesseractPath) {
        Write-Error "Could not find Tesseract installation path"
        return $false
    }
    
    $tessDataPath = Join-Path $tesseractPath "tessdata"
    if (-not (Test-Path $tessDataPath)) {
        Write-Error "Could not find tessdata directory: $tessDataPath"
        return $false
    }
    
    Write-Info "Found Tesseract at: $tesseractPath"
    Write-Info "Installing language packs to: $tessDataPath"
    
    # Language packs to download
    $languages = @{
        "jpn" = "Japanese"
        "ara" = "Arabic"
        "chi_sim" = "Chinese Simplified"
        "chi_tra" = "Chinese Traditional"
        "kor" = "Korean"
        "fra" = "French"
        "deu" = "German"
        "spa" = "Spanish"
        "rus" = "Russian"
    }
    
    $baseUrl = "https://github.com/tesseract-ocr/tessdata/raw/main"
    $successCount = 0
    
    foreach ($lang in $languages.Keys) {
        $langFile = "$lang.traineddata"
        $langPath = Join-Path $tessDataPath $langFile
        
        if (Test-Path $langPath) {
            Write-Success "$($languages[$lang]) ($lang) is already installed"
            $successCount++
            continue
        }
        
        Write-Info "Downloading $($languages[$lang]) ($lang)..."
        try {
            $url = "$baseUrl/$langFile"
            $tempFile = Join-Path $env:TEMP $langFile
            
            # Use Start-BitsTransfer for better progress indication and speed
            if (Get-Command Start-BitsTransfer -ErrorAction SilentlyContinue) {
                Start-BitsTransfer -Source $url -Destination $tempFile -DisplayName "Downloading $langFile"
            } else {
                Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing
            }
            
            # Verify file size (should be at least 1MB for language files)
            if ((Get-Item $tempFile -ErrorAction SilentlyContinue).Length -lt 1MB) {
                throw "Downloaded file is too small or corrupted"
            }
            
            if (Test-Path $tempFile) {
                Move-Item $tempFile $langPath -Force
                Write-Success "$($languages[$lang]) ($lang) installed successfully"
                $successCount++
                
                # Clean up temp file if move failed
                if (Test-Path $tempFile) {
                    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
                }
            } else {
                Write-Error "Failed to download $($languages[$lang]) ($lang)"
            }
        } catch {
            Write-Error "Error downloading $($languages[$lang]) ($lang): $($_.Exception.Message)"
            # Clean up temp file on error
            if (Test-Path $tempFile) {
                Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    Write-Info "Installed $successCount out of $($languages.Count) language packs"
    
    # Test Tesseract languages functionality
    if ($successCount -gt 0) {
        try {
            Write-Info "Testing Tesseract language recognition..."
            $installedLangs = tesseract --list-langs 2>&1 | Where-Object { $_ -match 'ara|jpn|chi_sim|chi_tra|kor|fra|deu|spa|rus' }
            if ($installedLangs) {
                Write-Success "Confirmed languages: $($installedLangs -join ', ')"
            }
        } catch {
            Write-Warning "Could not verify language installation: $($_.Exception.Message)"
        }
    }
    
    return $successCount -gt 0
}

# Create Python virtual environment
function Create-VirtualEnvironment {
    Write-Info "Creating Python virtual environment..."
    
    $venvPath = ".\venv"
    
    if (Test-Path $venvPath) {
        Write-Success "Virtual environment already exists"
        return $true
    }
    
    try {
        python -m venv $venvPath
        
        if (Test-Path $venvPath) {
            Write-Success "Virtual environment created successfully"
            return $true
        } else {
            Write-Error "Failed to create virtual environment"
            return $false
        }
    } catch {
        Write-Error "Error creating virtual environment: $($_.Exception.Message)"
        return $false
    }
}

# Install Python requirements
function Install-PythonRequirements {
    Write-Info "Installing Python requirements..."
    
    $venvPath = ".\venv"
    $activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
    $requirementsFile = ".\manga-image-translator\requirements.txt"
    
    if (-not (Test-Path $activateScript)) {
        Write-Error "Virtual environment activation script not found"
        return $false
    }
    
    if (-not (Test-Path $requirementsFile)) {
        Write-Error "Requirements file not found: $requirementsFile"
        return $false
    }
    
    try {
        # Activate virtual environment and install requirements
        & $activateScript
        python -m pip install --upgrade pip
        python -m pip install -r $requirementsFile
        
        Write-Success "Python requirements installed successfully"
        return $true
    } catch {
        Write-Error "Error installing Python requirements: $($_.Exception.Message)"
        return $false
    }
}

# Test installation
function Test-Installation {
    Write-Info "Testing installation..."
    
    $allGood = $true
    
    # Test Python
    try {
        $pythonVersion = python --version 2>&1
        if ($pythonVersion -match "Python 3\.11") {
            Write-Success "Python test passed: $pythonVersion"
        } else {
            Write-Error "Python test failed: $pythonVersion"
            $allGood = $false
        }
    } catch {
        Write-Error "Python test failed: $($_.Exception.Message)"
        $allGood = $false
    }
    
    # Test Tesseract
    try {
        $tesseractVersion = tesseract --version 2>&1 | Select-Object -First 1
        Write-Success "Tesseract test passed: $tesseractVersion"
        
        # Test languages
        $languages = tesseract --list-langs 2>&1 | Where-Object { $_ -notmatch "List of available languages" }
        Write-Info "Available languages: $($languages -join ', ')"
    } catch {
        Write-Error "Tesseract test failed: $($_.Exception.Message)"
        $allGood = $false
    }
    
    # Test Git
    try {
        $gitVersion = git --version
        Write-Success "Git test passed: $gitVersion"
    } catch {
        Write-Error "Git test failed: $($_.Exception.Message)"
        $allGood = $false
    }
    
    # Test virtual environment
    if (Test-Path ".\venv") {
        Write-Success "Virtual environment test passed"
    } else {
        Write-Error "Virtual environment test failed"
        $allGood = $false
    }
    
    return $allGood
}

# Main function
function Main {
    Write-Info "========================================="
    Write-Info "Smart Installer for Manga Image Translator"
    Write-Info "========================================="
    
    $success = $true
    
    if ($TestOnly) {
        Write-Info "Running in test mode only..."
        $testResult = Test-Installation
        if ($testResult) {
            Write-Success "All tests passed!"
            exit 0
        } else {
            Write-Error "Some tests failed!"
            exit 1
        }
    }
    
    Write-Info "Starting installation process..."
    
    # Install core components
    if (-not (Install-Chocolatey)) {
        Write-Error "Failed to install Chocolatey. Aborting."
        $success = $false
    }
    
    if ($success -and -not (Install-Python)) {
        Write-Error "Failed to install Python. Aborting."
        $success = $false
    }
    
    if ($success -and -not (Install-Git)) {
        Write-Error "Failed to install Git. Aborting."
        $success = $false
    }
    
    if ($success -and -not (Install-Tesseract)) {
        Write-Error "Failed to install Tesseract. Aborting."
        $success = $false
    }
    
    # Install language packs
    if ($success) {
        Install-TesseractLanguages
    }
    
    # Create virtual environment
    if ($success -and -not (Create-VirtualEnvironment)) {
        Write-Error "Failed to create virtual environment. Aborting."
        $success = $false
    }
    
    # Install Python requirements
    if ($success -and -not (Install-PythonRequirements)) {
        Write-Error "Failed to install Python requirements. Aborting."
        $success = $false
    }
    
    # Test installation
    Write-Info "========================================="
    Write-Info "Testing installation..."
    Write-Info "========================================="
    
    $testResult = Test-Installation
    
    if ($testResult -and $success) {
        Write-Success "========================================="
        Write-Success "Installation completed successfully!"
        Write-Success "========================================="
        Write-Info "Next steps:"
        Write-Info "1. Activate virtual environment: .\venv\Scripts\Activate.ps1"
        Write-Info "2. Navigate to project: cd manga-image-translator"
        Write-Info "3. Run translator: python -m manga_translator --help"
        Start-Sleep -Seconds 3
        exit 0
    } else {
        Write-Error "========================================="
        Write-Error "Installation completed with errors!"
        Write-Error "========================================="
        Write-Info "Please check the error messages above and try again."
        Start-Sleep -Seconds 3
        exit 1
    }
}

# Run main function
Main