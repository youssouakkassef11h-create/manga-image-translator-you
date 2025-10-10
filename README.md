# 🎌 Manga Image Translator

Automatic translation of manga/comic images powered by Python + Tesseract OCR + AI translation services.

## ✨ Features

- 🔍 **OCR Text Detection**: Extract text from manga images using Tesseract OCR
- 🌐 **Multi-language Support**: Translate between Japanese, Arabic, Chinese, Korean, English, and more
- 🎨 **Smart Text Rendering**: Preserve original font styles and bubble layouts
- 🖥️ **Web Interface**: Easy-to-use browser-based interface
- ⚡ **Batch Processing**: Process multiple images at once
- 🎯 **High Accuracy**: Advanced image preprocessing for better OCR results

## 🚀 Quick Start

### Option 1: Easy Installation (Recommended)
1. Double-click `EASY_INSTALL.bat`
2. Wait for automatic installation to complete
3. Open your browser and go to `http://localhost:8000`

### Option 2: Manual Installation
1. Install Python 3.11+ and Tesseract OCR
2. Clone this repository
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Run the server:
   ```bash
   cd server
   python main.py --host 0.0.0.0 --port 8000
   ```

## 📋 System Requirements

- **Operating System**: Windows 10/11 64-bit
- **RAM**: 4 GB minimum (8 GB recommended)
- **Storage**: 3 GB free disk space
- **Python**: 3.11 or higher
- **Tesseract OCR**: 5.3.0 or higher

## 🛠️ Dependencies

This project uses the following key components:
- **Python 3.11+**: Core runtime environment
- **Tesseract OCR**: Text extraction from images
- **OpenCV**: Image processing and manipulation
- **Flask**: Web server framework
- **Pillow**: Image handling library
- **Various AI Translation APIs**: For text translation

## 📖 Usage

1. **Start the Server**:
   ```bash
   python server/main.py --host 0.0.0.0 --port 8000
   ```

2. **Open Web Interface**:
   Navigate to `http://localhost:8000` in your browser

3. **Upload Image**:
   - Click "Choose File" and select your manga image
   - Select source language (e.g., Japanese)
   - Select target language (e.g., English)
   - Click "Translate"

4. **Download Result**:
   - Wait for processing to complete
   - Download the translated image

## 🔧 Configuration

### Environment Variables
- `TESSDATA_PREFIX`: Path to Tesseract language data
- `TRANSLATOR_API_KEY`: API key for translation services (if using external APIs)

### Supported Languages
- **Source**: Japanese (jpn), Chinese Simplified (chi_sim), Chinese Traditional (chi_tra), Korean (kor), Arabic (ara)
- **Target**: English (eng), Arabic (ara), French (fra), German (deu), Spanish (spa), Russian (rus)

## 🐛 Troubleshooting

### Common Issues

**1. "tesseract command not found"**
- Install Tesseract OCR following the guide in `tesseract_installation_guide.md`
- Ensure Tesseract is added to your system PATH

**2. "Module not found" errors**
- Run `pip install -r requirements.txt` to install all dependencies
- Ensure you're using Python 3.11 or higher

**3. Poor OCR accuracy**
- Use high-quality images (300 DPI or higher)
- Ensure good contrast between text and background
- Try preprocessing the image (brightness/contrast adjustment)

**4. Translation errors**
- Check your internet connection for online translation services
- Verify API keys are correctly configured

## 📁 Project Structure

```
manga-image-translator/
├── server/                 # Web server and API
│   ├── main.py            # Main server application
│   ├── translator.py      # Translation logic
│   └── ocr.py            # OCR processing
├── static/                # Web interface assets
├── templates/             # HTML templates
├── requirements.txt       # Python dependencies
├── EASY_INSTALL.bat      # Automated installer
├── smart_installer.ps1   # PowerShell installer script
└── README.md             # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project bundles multiple open-source components, each with their own licenses:

- **Core Application**: MIT License
- **Tesseract OCR**: Apache License 2.0
- **OpenCV**: Apache License 2.0
- **Flask**: BSD License
- **Other dependencies**: See individual package licenses

See the `LICENSE` file for complete details.

## 🙏 Acknowledgments

- **Tesseract OCR Team** for the excellent OCR engine
- **OpenCV Community** for image processing capabilities
- **Flask Team** for the web framework
- **All contributors** who help improve this project

## 📞 Support

- 📧 **Issues**: Report bugs and feature requests on GitHub Issues
- 📖 **Documentation**: Check the `docs/` folder for detailed guides
- 💬 **Discussions**: Join community discussions on GitHub Discussions

---

**Made with ❤️ for the manga translation community**