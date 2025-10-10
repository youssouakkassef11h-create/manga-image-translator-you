# 🔧 دليل تثبيت Tesseract OCR

## ❌ المشكلة الحالية
```
tesseract : The term 'tesseract' is not recognized as the name of a cmdlet, function, script file, or operable program.
```

هذا يعني أن **Tesseract OCR** غير مثبت على النظام أو غير مضاف إلى متغير البيئة PATH.

---

## 📋 متطلبات النظام

قبل التثبيت، تأكد من توفر:

- **Windows 10/11 64-bit** (مطلوب)
- **4 GB RAM** كحد أدنى (8 GB مُستحسن)
- **2 GB مساحة فارغة** على القرص الصلب
- **Visual C++ Redistributable** (سيتم تثبيته تلقائياً)

⚠️ **تنبيه**: إذا ظهر خطأ `MSVCP140.dll` بعد التثبيت، قم بتحميل Visual C++ Redistributable من:
👉 **https://aka.ms/vcpp**

---

## 📥 خطوات التثبيت

### 1️⃣ **تحميل Tesseract**

استخدم الرابط الثابت للإصدار الأحدث:
👉 **https://github.com/UB-Mannheim/tesseract/releases/download/v5.3.3.20231005/tesseract-ocr-w64-setup-5.3.3.20231005.exe**

> 💡 **نصيحة**: هذا الرابط ثابت ولن يتغير، بخلاف `/releases/latest` الذي قد يسبب مشاكل مع بعض شبكات VPN.

**للحصول على أحدث إصدار**:
يمكنك أيضاً زيارة صفحة الإصدارات والبحث عن أحدث ملف `.exe`:
👉 **https://github.com/UB-Mannheim/tesseract/releases**

### 2️⃣ **التثبيت العادي (مع واجهة)**

1. شغّل الملف المحمّل
2. **مهم جداً**: تأكد من تفعيل خيار **"Add to PATH"** أثناء التثبيت
3. اختر مجلد التثبيت (افتراضياً: `C:\Program Files\Tesseract-OCR`)
4. أكمل التثبيت

### 3️⃣ **التثبيت الصامت (للمطورين)**

للتثبيت التلقائي بدون تدخل المستخدم:

```powershell
# تحميل الملف
Invoke-WebRequest -Uri "https://github.com/UB-Mannheim/tesseract/releases/download/v5.3.3.20231005/tesseract-ocr-w64-setup-5.3.3.20231005.exe" -OutFile "tesseract-setup.exe"

# تثبيت صامت مع إضافة PATH تلقائياً
.\tesseract-setup.exe /S /D=C:\Tesseract-OCR
```

**معاملات التثبيت الصامت**:
- `/S` = تثبيت صامت (بدون نوافذ)
- `/D=PATH` = تحديد مجلد التثبيت

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

## 🗑️ إزالة التثبيت

إذا كنت تريد إعادة تثبيت Tesseract أو إزالته:

### الطريقة الأولى (مُستحسنة):
1. اذهب إلى **إعدادات Windows** (`Win + I`)
2. اختر **التطبيقات** (Apps)
3. ابحث عن **"Tesseract"**
4. اضغط **إلغاء التثبيت** (Uninstall)

### الطريقة الثانية (يدوياً):
1. اذهب إلى **لوحة التحكم** → **البرامج والميزات**
2. ابحث عن **Tesseract-OCR**
3. اضغط **إلغاء التثبيت**

### تنظيف إضافي:
بعد إلغاء التثبيت، احذف المجلد يدوياً إن بقي:
```powershell
Remove-Item "C:\Program Files\Tesseract-OCR" -Recurse -Force -ErrorAction SilentlyContinue
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
- للحصول على أفضل أداء، استخدم صور عالية الجودة (300 DPI أو أكثر)

---

## 🖼️ صور توضيحية

للمستخدمين المبتدئين، إليك الخطوات المصورة:

### خطوة "Add to PATH" أثناء التثبيت:
![Tesseract PATH Setup](https://user-images.githubusercontent.com/placeholder/tesseract-path-setup.gif)

> 📝 **ملاحظة للمطورين**: 
> - أضف صورة GIF توضح خيار "Add to PATH" أثناء التثبيت
> - مسار الصورة المقترح: `docs/images/tesseract-install-path.gif`
> - يمكن إنشاء الصورة باستخدام أدوات مثل ScreenToGif أو LICEcap

### نافذة التثبيت الصحيحة:
```
✅ Install Tesseract-OCR
✅ Add to PATH environment variable  ← مهم جداً!
✅ Install additional language data
```