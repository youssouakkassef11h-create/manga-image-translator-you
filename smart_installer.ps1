# ========================================
# Smart Installer for Manga Image Translator
# سكربت التثبيت الذكي لمترجم المانجا
# ========================================

param(
    [switch]$SkipPython,
    [switch]$SkipTesseract,
    [switch]$SkipGit,
    [switch]$Verbose
)

# إعدادات عامة
$ErrorActionPreference = "Continue"
$ProgressPreference = "Continue"

# فحص وطلب صلاحيات المدير مع الوسائط الكاملة
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "⚠ This script requires administrator privileges" -ForegroundColor Yellow
    Write-Host "ℹ The script will restart with administrator privileges..." -ForegroundColor Cyan
    
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($PSBoundParameters.Count -gt 0) {
        $arguments += " " + ($PSBoundParameters.GetEnumerator().ForEach({"-$($_.Key)"}) -join " ")
    }
    
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    exit
}

# ألوان للرسائل
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success($message) { Write-ColorOutput Green "✓ $message" }
function Write-Warning($message) { Write-ColorOutput Yellow "⚠ $message" }
function Write-Error($message) { Write-ColorOutput Red "✗ $message" }
function Write-Info($message) { Write-ColorOutput Cyan "ℹ $message" }

# تحديث PATH فوري
function Update-EnvironmentPath {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
}

# فحص صلاحيات المدير
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# فحص وجود أمر
function Test-Command($command) {
    return (Get-Command $command -ErrorAction SilentlyContinue) -ne $null
}

# Check and install Chocolatey
function Install-Chocolatey {
    Write-Info "Checking Chocolatey..."
    
    if (Test-Command choco) {
        Write-Success "Chocolatey is already installed"
        return $true
    }
    
    Write-Info "Installing Chocolatey..."
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # تحديث PATH فوري
        Update-EnvironmentPath
        
        if (Test-Command choco) {
            Write-Success "Chocolatey installed successfully"
            return $true
        } else {
            Write-Error "Failed to install Chocolatey"
            return $false
        }
    } catch {
        Write-Error "Error installing Chocolatey: $($_.Exception.Message)"
        return $false
    }
}

# فحص وتثبيت Python
function Install-Python {
    if ($SkipPython) {
        Write-Info "تم تخطي تثبيت Python"
        return $true
    }
    
    Write-Info "فحص Python..."
    
    # فحص إذا كان Python مثبت ومتوافق
    if (Test-Command python) {
        try {
            $pythonVersion = python --version 2>$null
            if ($pythonVersion -match "Python (\d+\.\d+)") {
                $version = [version]$matches[1]
                if ($version -ge [version]"3.8") {
                    Write-Success "Python $pythonVersion مثبت ومتوافق"
                    return $true
                } else {
                    Write-Warning "إصدار Python قديم: $pythonVersion"
                }
            }
        } catch {
            Write-Info "خطأ في فحص إصدار Python"
        }
    } else {
        Write-Info "Python غير مثبت"
    }
    
    Write-Info "تثبيت Python 3.11..."
    try {
        choco install python311 -y
        
        # تحديث PATH فوري
        Update-EnvironmentPath
        
        # التحقق من التثبيت
        Start-Sleep -Seconds 5
        if (Test-Command python) {
            $newVersion = python --version 2>$null
            Write-Success "تم تثبيت Python بنجاح: $newVersion"
            return $true
        } else {
            Write-Error "فشل في تثبيت Python"
            return $false
        }
    } catch {
        Write-Error "خطأ في تثبيت Python: $($_.Exception.Message)"
        return $false
    }
}

# فحص وتثبيت Git
function Install-Git {
    if ($SkipGit) {
        Write-Info "تم تخطي تثبيت Git"
        return $true
    }
    
    Write-Info "فحص Git..."
    
    if (Test-Command git) {
        $gitVersion = git --version
        Write-Success "Git مثبت مسبقاً: $gitVersion"
        return $true
    }
    
    Write-Info "تثبيت Git..."
    try {
        choco install git -y
        
        # تحديث PATH فوري
        Update-EnvironmentPath
        
        # التحقق من التثبيت
        Start-Sleep -Seconds 5
        if (Test-Command git) {
            $gitVersion = git --version
            Write-Success "تم تثبيت Git بنجاح: $gitVersion"
            return $true
        } else {
            Write-Error "فشل في تثبيت Git"
            return $false
        }
    } catch {
        Write-Error "خطأ في تثبيت Git: $($_.Exception.Message)"
        return $false
    }
}

# فحص وتثبيت Tesseract
function Install-Tesseract {
    if ($SkipTesseract) {
        Write-Info "تم تخطي تثبيت Tesseract"
        return $true
    }
    
    Write-Info "فحص Tesseract..."
    
    if (Test-Command tesseract) {
        $tesseractVersion = tesseract --version 2>$null | Select-Object -First 1
        Write-Success "Tesseract مثبت مسبقاً: $tesseractVersion"
        return $true
    }
    
    Write-Info "تثبيت Tesseract..."
    try {
        choco install tesseract -y
        
        # تحديث PATH فوري
        Update-EnvironmentPath
        
        # التحقق من التثبيت
        Start-Sleep -Seconds 5
        if (Test-Command tesseract) {
            $tesseractVersion = tesseract --version 2>$null | Select-Object -First 1
            Write-Success "تم تثبيت Tesseract بنجاح: $tesseractVersion"
            return $true
        } else {
            Write-Error "فشل في تثبيت Tesseract"
            return $false
        }
    } catch {
        Write-Error "خطأ في تثبيت Tesseract: $($_.Exception.Message)"
        return $false
    }
}

# العثور على مسار تثبيت Tesseract
function Find-TesseractPath {
    $possiblePaths = @(
        "C:\Program Files\Tesseract-OCR",
        "C:\Program Files (x86)\Tesseract-OCR",
        "C:\tools\tesseract",
        "C:\ProgramData\chocolatey\lib\tesseract\tools"
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path "$path\tesseract.exe") {
            return $path
        }
    }
    
    # البحث في PATH
    $tesseractCmd = Get-Command tesseract -ErrorAction SilentlyContinue
    if ($tesseractCmd) {
        return Split-Path $tesseractCmd.Source -Parent
    }
    
    return $null
}

# تنزيل وتثبيت حزم اللغات
function Install-TesseractLanguages {
    Write-Info "تثبيت حزم اللغات لـ Tesseract..."
    
    $tesseractPath = Find-TesseractPath
    if (-not $tesseractPath) {
        Write-Error "لم يتم العثور على مسار تثبيت Tesseract"
        return $false
    }
    
    $tessdataPath = Join-Path $tesseractPath "tessdata"
    if (-not (Test-Path $tessdataPath)) {
        Write-Error "مجلد tessdata غير موجود في: $tessdataPath"
        return $false
    }
    
    Write-Info "مسار tessdata: $tessdataPath"
    
    # قائمة اللغات المطلوبة
    $languages = @(
        @{Code="jpn"; Name="اليابانية"},
        @{Code="ara"; Name="العربية"},
        @{Code="chi_sim"; Name="الصينية المبسطة"},
        @{Code="chi_tra"; Name="الصينية التقليدية"},
        @{Code="kor"; Name="الكورية"},
        @{Code="fra"; Name="الفرنسية"},
        @{Code="deu"; Name="الألمانية"},
        @{Code="spa"; Name="الإسبانية"},
        @{Code="rus"; Name="الروسية"}
    )
    
    $baseUrl = "https://github.com/tesseract-ocr/tessdata/raw/main"
    $successCount = 0
    
    foreach ($lang in $languages) {
        $langFile = "$($lang.Code).traineddata"
        $langPath = Join-Path $tessdataPath $langFile
        
        if (Test-Path $langPath) {
            Write-Success "حزمة $($lang.Name) ($($lang.Code)) مثبتة مسبقاً"
            $successCount++
            continue
        }
        
        Write-Info "تنزيل حزمة $($lang.Name) ($($lang.Code))..."
        
        try {
            $url = "$baseUrl/$langFile"
            $tempFile = Join-Path $env:TEMP $langFile
            
            # استخدام Start-BitsTransfer للتنزيل السريع مع شريط التقدم
            Start-BitsTransfer -Source $url -Destination $tempFile -DisplayName "جارٍ تنزيل $langFile"
            
            # التحقق من حجم الملف
            if ((Get-Item $tempFile).Length -lt 1MB) {
                throw "الملف المنزل صغير جداً أو تالف"
            }
            
            if (Test-Path $tempFile) {
                # نسخ إلى مجلد tessdata
                Copy-Item $tempFile $langPath -Force
                
                # حذف الملف المؤقت
                Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
                
                if (Test-Path $langPath) {
                    Write-Success "تم تثبيت حزمة $($lang.Name) بنجاح"
                    $successCount++
                } else {
                    Write-Error "فشل في نسخ حزمة $($lang.Name)"
                }
            } else {
                Write-Error "فشل في تنزيل حزمة $($lang.Name)"
            }
        } catch {
            Write-Error "خطأ في تثبيت حزمة $($lang.Name): $($_.Exception.Message)"
            # حذف الملف المؤقت في حالة الخطأ
            if (Test-Path $tempFile) {
                Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    Write-Info "تم تثبيت $successCount من أصل $($languages.Count) حزمة لغة"
    
    # اختبار وظيفي للغات المثبتة
    if ($successCount -gt 0) {
        Write-Info "اختبار اللغات المثبتة..."
        try {
            $installedLangs = tesseract --list-langs 2>$null | Where-Object { $_ -match 'ara|jpn|chi_sim|chi_tra|kor|fra|deu|spa|rus' }
            if ($installedLangs) {
                Write-Success "اللغات المؤكدة: $($installedLangs -join ', ')"
            }
        } catch {
            Write-Warning "لا يمكن التحقق من اللغات المثبتة"
        }
    }
    
    return $successCount -gt 0
}

# إنشاء البيئة الافتراضية وتثبيت المتطلبات
function Setup-PythonEnvironment {
    Write-Info "إعداد البيئة الافتراضية لـ Python..."
    
    $venvPath = "venv"
    
    # إنشاء البيئة الافتراضية إذا لم تكن موجودة
    if (-not (Test-Path $venvPath)) {
        Write-Info "إنشاء البيئة الافتراضية..."
        python -m venv $venvPath
        
        if (-not (Test-Path $venvPath)) {
            Write-Error "فشل في إنشاء البيئة الافتراضية"
            return $false
        }
    } else {
        Write-Success "البيئة الافتراضية موجودة مسبقاً"
    }
    
    # تفعيل البيئة الافتراضية
    $activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
    if (Test-Path $activateScript) {
        Write-Info "تفعيل البيئة الافتراضية..."
        & $activateScript
    } else {
        Write-Error "لم يتم العثور على سكربت التفعيل"
        return $false
    }
    
    # تحديث pip
    Write-Info "تحديث pip..."
    python -m pip install --upgrade pip
    
    # تثبيت المتطلبات
    $requirementsFile = "manga-image-translator\requirements.txt"
    if (Test-Path $requirementsFile) {
        Write-Info "تثبيت متطلبات Python..."
        python -m pip install -r $requirementsFile
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "تم تثبيت متطلبات Python بنجاح"
            return $true
        } else {
            Write-Error "فشل في تثبيت بعض المتطلبات"
            return $false
        }
    } else {
        Write-Warning "ملف requirements.txt غير موجود"
        return $false
    }
}

# اختبار التثبيت
function Test-Installation {
    Write-Info "اختبار التثبيت..."
    
    $tests = @()
    
    # اختبار Python
    try {
        $pythonVersion = python --version 2>$null
        if ($pythonVersion) {
            $tests += @{Name="Python"; Status="✓"; Details=$pythonVersion}
        } else {
            $tests += @{Name="Python"; Status="✗"; Details="غير متاح"}
        }
    } catch {
        $tests += @{Name="Python"; Status="✗"; Details="خطأ في الاختبار"}
    }
    
    # اختبار Tesseract
    try {
        $tesseractVersion = tesseract --version 2>$null | Select-Object -First 1
        if ($tesseractVersion) {
            $tests += @{Name="Tesseract"; Status="✓"; Details=$tesseractVersion}
        } else {
            $tests += @{Name="Tesseract"; Status="✗"; Details="غير متاح"}
        }
    } catch {
        $tests += @{Name="Tesseract"; Status="✗"; Details="خطأ في الاختبار"}
    }
    
    # اختبار اللغات المثبتة
    try {
        $languages = tesseract --list-langs 2>$null
        if ($languages) {
            $langCount = ($languages | Measure-Object -Line).Lines - 1
            $tests += @{Name="حزم اللغات"; Status="✓"; Details="$langCount لغة مثبتة"}
        } else {
            $tests += @{Name="حزم اللغات"; Status="✗"; Details="غير متاح"}
        }
    } catch {
        $tests += @{Name="حزم اللغات"; Status="✗"; Details="خطأ في الاختبار"}
    }
    
    # اختبار Git
    try {
        $gitVersion = git --version 2>$null
        if ($gitVersion) {
            $tests += @{Name="Git"; Status="✓"; Details=$gitVersion}
        } else {
            $tests += @{Name="Git"; Status="✗"; Details="غير متاح"}
        }
    } catch {
        $tests += @{Name="Git"; Status="✗"; Details="خطأ في الاختبار"}
    }
    
    # عرض النتائج
    Write-Info "نتائج الاختبار:"
    Write-Output "=" * 50
    foreach ($test in $tests) {
        Write-Output "$($test.Status) $($test.Name): $($test.Details)"
    }
    Write-Output "=" * 50
    
    $successCount = ($tests | Where-Object {$_.Status -eq "✓"}).Count
    $totalCount = $tests.Count
    
    if ($successCount -eq $totalCount) {
        Write-Success "جميع الاختبارات نجحت! ($successCount/$totalCount)"
        return $true
    } else {
        Write-Warning "نجح $successCount من أصل $totalCount اختبار"
        return $false
    }
}

# الدالة الرئيسية
function Main {
    Write-Output ""
    Write-Output "=" * 60
    Write-ColorOutput Magenta "    سكربت التثبيت الذكي لمترجم المانجا"
    Write-ColorOutput Magenta "    Smart Installer for Manga Image Translator"
    Write-Output "=" * 60
    Write-Output ""
    
    $startTime = Get-Date
    $success = $true
    
    try {
        # تثبيت Chocolatey
        if (-not (Install-Chocolatey)) {
            $success = $false
        }
        
        # تثبيت Python
        if ($success -and -not (Install-Python)) {
            $success = $false
        }
        
        # تثبيت Git
        if ($success -and -not (Install-Git)) {
            $success = $false
        }
        
        # تثبيت Tesseract
        if ($success -and -not (Install-Tesseract)) {
            $success = $false
        }
        
        # تثبيت حزم اللغات
        if ($success) {
            Install-TesseractLanguages
        }
        
        # إعداد البيئة الافتراضية
        if ($success) {
            Setup-PythonEnvironment
        }
        
        # اختبار التثبيت
        Write-Output ""
        $testResult = Test-Installation
        
    } catch {
        Write-Error "خطأ عام في التثبيت: $($_.Exception.Message)"
        $success = $false
    }
    
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    Write-Output ""
    Write-Output "=" * 60
    if ($success) {
        Write-Success "تم التثبيت بنجاح!"
        Write-Info "الوقت المستغرق: $($duration.ToString('mm\:ss'))"
        Write-Output ""
        Write-Info "يمكنك الآن تشغيل مترجم المانجا باستخدام:"
        Write-ColorOutput Yellow "    .\venv\Scripts\Activate.ps1"
        Write-ColorOutput Yellow "    cd manga-image-translator"
        Write-ColorOutput Yellow "    python -m manga_translator --help"
    } else {
        Write-Error "فشل في التثبيت!"
        Write-Info "يرجى مراجعة الأخطاء أعلاه وإعادة المحاولة"
    }
    Write-Output "=" * 60
    Write-Output ""
    
    # انتظار 3 ثوانٍ بدلاً من ReadKey
    Write-Info "سيتم إغلاق النافذة خلال 3 ثوانٍ..."
    Start-Sleep -Seconds 3
    
    # إرجاع رمز الخروج المناسب
    exit ([int](-not $success))
}

# تشغيل السكربت
Main