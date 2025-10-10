@echo off
echo ========================================
echo       تثبيت Tesseract OCR
echo ========================================
echo.

REM فحص وجود Tesseract مسبقاً
where tesseract >nul 2>&1
if %errorlevel% equ 0 (
    echo Tesseract موجود مسبقاً!
    tesseract --version
    echo.
    echo لا حاجة لإعادة التثبيت.
    pause
    exit /b 0
)

echo يتم تحميل Tesseract من الموقع الرسمي...
echo.

REM تحميل Tesseract من الموقع الرسمي
powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/UB-Mannheim/tesseract/releases/download/v5.3.3.20231005/tesseract-ocr-w64-setup-5.3.3.20231005.exe' -OutFile 'tesseract-installer.exe'}"

if not exist tesseract-installer.exe (
    echo فشل في تحميل Tesseract
    echo يرجى تحميله يدوياً من:
    echo https://github.com/UB-Mannheim/tesseract/releases
    pause
    exit /b 1
)

echo تم تحميل Tesseract بنجاح!
echo.
echo سيتم تشغيل المثبت الآن مع إضافة تلقائية إلى PATH...
echo.

REM تثبيت تلقائي مع إضافة إلى PATH
start /wait tesseract-installer.exe /S /D="C:\Program Files\Tesseract-OCR"

REM حذف المثبت بعد الانتهاء
del tesseract-installer.exe

echo.
echo تم انتهاء التثبيت!
echo أعد تشغيل PowerShell وجرب:
echo tesseract --version

echo.
pause