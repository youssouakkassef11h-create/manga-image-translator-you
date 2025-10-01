@echo off
chcp 65001 >nul
echo ========================================
echo    مترجم المانغا إلى العربية
echo    Manga to Arabic Translator
echo ========================================
echo.

REM التحقق من وجود Python
python --version >nul 2>&1
if errorlevel 1 (
    echo خطأ: Python غير مثبت أو غير موجود في PATH
    echo Error: Python is not installed or not in PATH
    pause
    exit /b 1
)

REM التحقق من وجود ملف الإعدادات
if not exist "config_arabic.json" (
    echo خطأ: ملف الإعدادات config_arabic.json غير موجود
    echo Error: Config file config_arabic.json not found
    pause
    exit /b 1
)

echo اختر نوع الترجمة:
echo Choose translation type:
echo 1. ترجمة صورة واحدة (Single image)
echo 2. ترجمة مجلد كامل (Entire folder)
echo.
set /p choice="أدخل اختيارك (1 أو 2) / Enter your choice (1 or 2): "

if "%choice%"=="1" (
    set /p input_file="أدخل مسار الصورة / Enter image path: "
    if not exist "!input_file!" (
        echo خطأ: الملف غير موجود
        echo Error: File not found
        pause
        exit /b 1
    )
    echo.
    echo بدء الترجمة...
    echo Starting translation...
    python translate_to_arabic.py "!input_file!"
) else if "%choice%"=="2" (
    set /p input_dir="أدخل مسار المجلد / Enter directory path: "
    if not exist "!input_dir!" (
        echo خطأ: المجلد غير موجود
        echo Error: Directory not found
        pause
        exit /b 1
    )
    echo.
    echo بدء ترجمة المجلد...
    echo Starting directory translation...
    python translate_to_arabic.py "!input_dir!" --directory
) else (
    echo اختيار غير صحيح
    echo Invalid choice
    pause
    exit /b 1
)

echo.
echo تمت العملية!
echo Process completed!
pause