@echo off
chcp 65001 >nul
title Manga Image Translator - Easy Install

REM فحص صلاحيات المسؤول
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ يجب تشغيل هذا الملف كمسؤول!
    echo    Right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo    Manga Image Translator Easy Setup
echo ========================================
echo.
echo This script will automatically install all requirements:
echo.
echo ✓ Python 3.11
echo ✓ Git
echo ✓ Tesseract OCR
echo ✓ Language packs (Japanese, Arabic, Chinese, Korean, and more)
echo ✓ All required Python libraries
echo ✓ Virtual environment setup
echo.
echo Administrator privileges confirmed ✓
echo.
pause

echo Running smart installer...
powershell -ExecutionPolicy Bypass -File "%~dp0smart_installer.ps1"

if %errorlevel% neq 0 (
    echo.
    echo ❌ فشل التثبيت! راجع الأخطاء أعلاه
    echo    Installation failed! Check errors above
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ انتهى التثبيت بنجاح!
echo    Installation completed successfully!
echo.
echo للبدء، اكتب: python -m manga_translator --help
echo To start, type: python -m manga_translator --help
echo.
pause