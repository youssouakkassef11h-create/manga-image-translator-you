@echo off
chcp 65001 >nul
title تثبيت مترجم المانجا - التثبيت السهل

echo.
echo ========================================
echo       تثبيت مترجم المانجا السهل
echo    Easy Manga Image Translator Setup
echo ========================================
echo.
echo هذا السكربت سيقوم بتثبيت جميع المتطلبات تلقائياً:
echo.
echo ✓ Python 3.11
echo ✓ Git
echo ✓ Tesseract OCR
echo ✓ حزم اللغات (اليابانية، العربية، الصينية، الكورية، وأكثر)
echo ✓ جميع مكتبات Python المطلوبة
echo ✓ إعداد البيئة الافتراضية
echo.
echo سيتم طلب صلاحيات المدير لإكمال التثبيت
echo.
pause

echo تشغيل السكربت الذكي...
powershell -ExecutionPolicy Bypass -File "smart_installer_fixed.ps1"

echo.
echo تم الانتهاء من التثبيت!
echo.
pause