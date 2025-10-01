# دليل ترجمة المانغا من الإنجليزية إلى العربية

## نظرة عامة
هذا الدليل يوضح كيفية استخدام برنامج `manga-image-translator` لترجمة المانغا من الإنجليزية إلى العربية.

## المتطلبات
- Python 3.8 أو أحدث
- جميع التبعيات المثبتة من `requirements.txt`
- مساحة تخزين كافية للنماذج (حوالي 2-3 جيجابايت)

## الملفات المهمة
- `config_arabic.json` - إعدادات الترجمة للعربية
- `translate_to_arabic.py` - سكريبت Python للترجمة
- `translate_batch.bat` - ملف batch لنظام Windows

## طرق الاستخدام

### 1. الطريقة السهلة (Windows)
```bash
# تشغيل ملف batch
translate_batch.bat
```

### 2. استخدام السكريبت مباشرة

#### ترجمة صورة واحدة:
```bash
python translate_to_arabic.py "path/to/image.jpg"
```

#### ترجمة مجلد كامل:
```bash
python translate_to_arabic.py "path/to/folder" --directory
```

#### تحديد مجلد الإخراج:
```bash
python translate_to_arabic.py "input.jpg" -o "output_arabic.jpg"
```

### 3. استخدام الأمر الأساسي
```bash
python -m manga_translator local --input "image.jpg" --output "output.jpg" --config config_arabic.json
```

## الإعدادات المتقدمة

### تخصيص ملف الإعدادات
يمكنك تعديل `config_arabic.json` لتخصيص:

```json
{
  "render": {
    "direction": "rtl",           // اتجاه النص من اليمين لليسار
    "gimp_font": "Arial Unicode MS", // الخط المستخدم
    "rtl": true                   // دعم الكتابة من اليمين لليسار
  },
  "translator": {
    "translator": "m2m100",       // نوع المترجم
    "target_lang": "ARA"          // اللغة الهدف (العربية)
  }
}
```

### المترجمات المتاحة للعربية:
- `m2m100` - مترجم محلي (مجاني)
- `nllb` - مترجم محلي متقدم
- `mbart50` - مترجم محلي
- `google` - Google Translate (يتطلب API)
- `openai` - ChatGPT (يتطلب API key)
- `gemini` - Google Gemini (يتطلب API key)

### استخدام مترجم مختلف:
```bash
python -m manga_translator local --input "image.jpg" --translator nllb --target-lang ARA
```

## نصائح للحصول على أفضل النتائج

### 1. جودة الصورة
- استخدم صور عالية الدقة
- تأكد من وضوح النص في الصورة الأصلية

### 2. الخطوط العربية
- تأكد من وجود خطوط عربية في النظام
- الخطوط المقترحة: Arial Unicode MS, Tahoma, Segoe UI

### 3. معالجة النص
- البرنامج يدعم تلقائياً:
  - إعادة تشكيل النص العربي
  - الكتابة من اليمين لليسار
  - ربط الحروف العربية

## استكشاف الأخطاء

### خطأ في التبعيات:
```bash
pip install -r requirements.txt
```

### خطأ في النماذج:
```bash
# سيتم تحميل النماذج تلقائياً في أول استخدام
# تأكد من وجود اتصال إنترنت
```

### مشاكل الخطوط:
- تأكد من تثبيت خطوط عربية
- على Windows: انسخ الخطوط إلى مجلد `C:\Windows\Fonts`

## أمثلة عملية

### مثال 1: ترجمة صورة واحدة
```bash
python translate_to_arabic.py "manga_page.jpg"
# النتيجة: manga_page_arabic.jpg
```

### مثال 2: ترجمة مجلد كامل
```bash
python translate_to_arabic.py "manga_chapter" --directory
# النتيجة: مجلد translated_arabic داخل manga_chapter
```

### مثال 3: استخدام مترجم مختلف
```bash
# تعديل config_arabic.json
{
  "translator": {
    "translator": "nllb",
    "target_lang": "ARA"
  }
}
```

## الواجهة الويب

لاستخدام الواجهة الويب:
```bash
python -m manga_translator ws --host 0.0.0.0 --port 5003
```
ثم افتح المتصفح على: `http://localhost:5003`

## الدعم والمساعدة

إذا واجهت مشاكل:
1. تأكد من تثبيت جميع التبعيات
2. تحقق من وجود مساحة تخزين كافية
3. تأكد من صحة مسارات الملفات
4. راجع رسائل الخطأ في Terminal

## ملاحظات مهمة
- الترجمة الأولى قد تستغرق وقتاً أطول لتحميل النماذج
- النماذج المحلية (m2m100, nllb) لا تحتاج إنترنت بعد التحميل
- المترجمات السحابية تحتاج مفاتيح API وإنترنت

---

**استمتع بترجمة المانغا إلى العربية! 🎌➡️🇸🇦**