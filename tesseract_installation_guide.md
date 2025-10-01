# 🔧 دليل تثبيت Tesseract OCR

## ❌ المشكلة الحالية
```
tesseract : The term 'tesseract' is not recognized as the name of a cmdlet, function, script file, or operable program.
```

هذا يعني أن **Tesseract OCR** غير مثبت على النظام أو غير مضاف إلى متغير البيئة PATH.

---

## 📥 خطوات التثبيت

### 1️⃣ **تحميل Tesseract**

انتقل إلى الرابط التالي:
👉 **https://github.com/UB-Mannheim/tesseract/releases/latest**

### 2️⃣ **اختيار الإصدار المناسب**

لنظام Windows 64-bit، حمّل:
- `tesseract-ocr-w64-setup-[version].exe`

### 3️⃣ **تثبيت Tesseract**

1. شغّل الملف المحمّل
2. **مهم جداً**: تأكد من تفعيل خيار **"Add to PATH"** أثناء التثبيت
3. اختر مجلد التثبيت (افتراضياً: `C:\Program Files\Tesseract-OCR`)
4. أكمل التثبيت

### 4️⃣ **إعادة تشغيل PowerShell**

بعد التثبيت:
1. أغلق جميع نوافذ PowerShell/CMD
2. افتح PowerShell جديد
3. جرب الأمر:
   ```powershell
   tesseract --version
   ```

---

## 🔧 إذا لم يعمل بعد التثبيت

### إضافة PATH يدوياً:

1. **افتح إعدادات النظام**:
   - اضغط `Win + R`
   - اكتب `sysdm.cpl`
   - اضغط Enter

2. **تعديل متغيرات البيئة**:
   - اضغط "Environment Variables"
   - في "System Variables"، ابحث عن "Path"
   - اضغط "Edit"
   - اضغط "New"
   - أضف: `C:\Program Files\Tesseract-OCR`

3. **أعد تشغيل PowerShell**

---

## ✅ التحقق من التثبيت

بعد التثبيت الناجح، يجب أن ترى:

```powershell
PS> tesseract --version
tesseract 5.3.3
 leptonica-1.83.1
  libgif 5.2.1 : libjpeg 8d (libjpeg-turbo 2.1.4) : libpng 1.6.39 : libtiff 4.5.1 : zlib 1.2.13 : libwebp 1.3.2 : libopenjp2 2.5.0
 Found AVX2
 Found AVX
 Found FMA
 Found SSE4.1
 Found libarchive 3.6.2 zlib/1.2.13 liblzma/5.2.9 bz2/1.0.8 libzstd/1.5.2
```

---

## 🚀 بعد التثبيت

عندما يعمل `tesseract --version` بنجاح، يمكنك:

1. **إعادة تشغيل مترجم المانجا**:
   ```bash
   cd server
   python main.py --host 0.0.0.0 --port 8000
   ```

2. **اختبار الترجمة** عبر الواجهة على `http://localhost:8000`

---

## 📝 ملاحظات مهمة

- **Tesseract** ضروري لاستخراج النص من الصور
- بدونه، مترجم المانجا لن يعمل بشكل صحيح
- تأكد من إضافة PATH أثناء التثبيت لتجنب المشاكل
- إذا واجهت مشاكل، جرب إعادة تشغيل الكمبيوتر بالكامل

---

## 🆘 إذا استمرت المشكلة

إذا لم يعمل Tesseract بعد كل هذه الخطوات:

1. تأكد من تحميل الإصدار الصحيح (64-bit)
2. جرب تثبيته في مجلد مختلف
3. تأكد من صلاحيات المدير أثناء التثبيت
4. أعد تشغيل الكمبيوتر بالكامل