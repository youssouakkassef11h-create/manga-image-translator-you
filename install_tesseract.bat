@echo off
echo ========================================
echo       تثبيت Tesseract OCR
echo ========================================
echo.
echo يتم تحميل Tesseract من الموقع الرسمي...
echo.

REM تحميل Tesseract من الموقع الرسمي
powershell -Command "& {Invoke-WebRequest -Uri 'https://github.com/UB-Mannheim/tesseract/releases/download/v5.3.3.20231005/tesseract-ocr-w64-setup-5.3.3.20231005.exe' -OutFile 'tesseract-installer.exe'}"

if exist tesseract-installer.exe (
    echo تم تحميل Tesseract بنجاح!
    echo.
    echo سيتم تشغيل المثبت الآن...
    echo تأكد من اختيار "Add to PATH" أثناء التثبيت
    echo.
    pause
    start tesseract-installer.exe
    echo.
    echo بعد انتهاء التثبيت، أعد تشغيل PowerShell وجرب:
    echo tesseract --version
) else (
    echo فشل في تحميل Tesseract
    echo يرجى تحميله يدوياً من:
    echo https://github.com/UB-Mannheim/tesseract/releases
)

echo.
pause