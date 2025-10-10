# 🚀 Easy Installation Guide for Manga Image Translator

## 📋 Overview

This guide shows how to install the Manga Image Translator easily and quickly using the smart installer script that does everything automatically.

## ✨ Features

- **One-click installation**: No need to deal with technical details
- **Auto-detection**: Detects what's already installed and skips it
- **Comprehensive installation**: Installs all requirements automatically
- **Multi-language support**: Installs essential language packs
- **Automatic testing**: Verifies successful installation

## 🛠️ What Gets Installed

### Core Programs:
- ✅ **Python 3.11** - Main programming language
- ✅ **Git** - Code management
- ✅ **Tesseract OCR** - Text extraction from images
- ✅ **Chocolatey** - Package manager for Windows

### Tesseract Language Packs:
- 🇯🇵 **Japanese** (jpn)
- 🇸🇦 **Arabic** (ara)
- 🇨🇳 **Chinese Simplified** (chi_sim)
- 🇹🇼 **Chinese Traditional** (chi_tra)
- 🇰🇷 **Korean** (kor)
- 🇫🇷 **French** (fra)
- 🇩🇪 **German** (deu)
- 🇪🇸 **Spanish** (spa)
- 🇷🇺 **Russian** (rus)

### Python Libraries:
- All required libraries from `requirements.txt`
- Isolated virtual environment for the project

## 🚀 Installation Methods

### Method 1: Easy Install (Recommended)

1. **Double-click** on one of these files:
   - `تثبيت_سهل.bat` (Arabic interface)
   - `EASY_INSTALL.bat` (English interface)

2. **Follow the instructions** on screen

3. **Wait** for installation to complete (may take 10-20 minutes)

### Method 2: Manual Execution

If you prefer more control:

```powershell
# Open PowerShell as Administrator
PowerShell -ExecutionPolicy Bypass -File "smart_installer.ps1"
```

### Advanced Options:

```powershell
# Skip Python installation (if already installed)
PowerShell -ExecutionPolicy Bypass -File "smart_installer.ps1" -SkipPython

# Skip Tesseract installation
PowerShell -ExecutionPolicy Bypass -File "smart_installer.ps1" -SkipTesseract

# Skip Git installation
PowerShell -ExecutionPolicy Bypass -File "smart_installer.ps1" -SkipGit

# Show more details
PowerShell -ExecutionPolicy Bypass -File "smart_installer.ps1" -Verbose
```

## 🔧 After Installation

### Activate Virtual Environment:
```powershell
.\venv\Scripts\Activate.ps1
```

### Navigate to Project Folder:
```powershell
cd manga-image-translator
```

### Run the Translator:
```powershell
# Show help
python -m manga_translator --help

# Translate an image
python -m manga_translator -i input_image.jpg -o output_image.jpg --target-lang English
```

## 🧪 Testing Installation

The script tests automatically, but you can run manual tests:

**⚠️ Important: Restart your Terminal/PowerShell after installation to refresh environment variables**

```powershell
# Test Python
python --version

# Test Tesseract
tesseract --version

# Test installed languages
tesseract --list-langs

# Test Git
git --version
```

## ❗ Common Issues & Solutions

### Issue: "Cannot run script"
**Solution**: Make sure to run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Issue: "Failed to download files"
**Solution**: 
- Check internet connection
- Temporarily disable antivirus
- Use VPN if there's blocking

### Issue: "Access denied"
**Solution**: 
- Run script as Administrator
- Temporarily close antivirus programs

### Issue: "Python not found"
**Solution**: 
- Restart PowerShell after installation
- Manually add Python to PATH

## 📁 File Structure After Installation

```
manga-image-translator/
├── smart_installer.ps1          # Smart installer script
├── تثبيت_سهل.bat               # Easy install (Arabic)
├── EASY_INSTALL.bat            # Easy install (English)
├── venv/                       # Virtual environment
├── manga-image-translator/     # Main project
└── jpn.traineddata            # Japanese language pack
```

## 🆘 Getting Help

If you encounter any issues:

1. **Review error messages** in the script
2. **Check internet connection**
3. **Run script as Administrator**
4. **Check antivirus settings**

## 🎯 Next Steps

After successful installation:

1. **Try translating a simple image**
2. **Read the complete user guide**
3. **Explore advanced options**
4. **Share your experience with others**

---

## 📝 Important Notes

- ⏱️ **Expected time**: 10-20 minutes depending on internet speed
- 💾 **Required space**: About 2-3 GB
- 🔒 **Security**: All downloads from official sources
- 🔄 **Updates**: Can re-run script for updates

**Enjoy translating manga! 🎌📚**

---

## 📄 License Information

All components used in this project are open-source software under their respective licenses:
- **Manga Image Translator**: MIT License
- **Python**: Python Software Foundation License
- **Tesseract OCR**: Apache License 2.0
- **Git**: GNU General Public License v2.0

You are free to use this software for personal and commercial purposes according to the terms of each license.