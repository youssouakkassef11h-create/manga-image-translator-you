#!/usr/bin/env python3
"""
سكريبت لترجمة المانغا من الإنجليزية إلى العربية
Script to translate manga from English to Arabic
"""

import os
import sys
import argparse
from pathlib import Path

def translate_single_image(input_path, output_path=None, config_path=None):
    """
    ترجمة صورة واحدة من الإنجليزية إلى العربية
    Translate a single image from English to Arabic
    """
    if not os.path.exists(input_path):
        print(f"خطأ: الملف غير موجود - {input_path}")
        print(f"Error: File not found - {input_path}")
        return False
    
    # تحديد مسار الإخراج إذا لم يتم تحديده
    if output_path is None:
        input_file = Path(input_path)
        output_path = input_file.parent / f"{input_file.stem}_arabic{input_file.suffix}"
    
    # تحديد ملف الإعدادات
    if config_path is None:
        config_path = "config_arabic.json"
    
    # بناء الأمر
    cmd = [
        sys.executable, "-m", "manga_translator",
        "local",
        "--input", str(input_path),
        "--dest", str(output_path.parent),
        "--config-file", config_path,
        "--verbose"
    ]
    
    print(f"ترجمة الصورة: {input_path}")
    print(f"Translating image: {input_path}")
    print(f"الأمر المنفذ: {' '.join(cmd)}")
    print(f"Command: {' '.join(cmd)}")
    
    # تنفيذ الأمر
    import subprocess
    try:
        result = subprocess.run(cmd, capture_output=True)
        if result.returncode == 0:
            print(f"✅ تمت الترجمة بنجاح! الملف المحفوظ في: {output_path}")
            print(f"✅ Translation successful! File saved at: {output_path}")
            return True
        else:
            print(f"❌ خطأ في الترجمة:")
            print(f"❌ Translation error:")
            # فك تشفير مخرجات الخطأ مع معالجة الأخطاء لتجنب مشاكل الترميز
            # Decode stderr with error handling to avoid encoding issues
            error_output = result.stderr.decode('utf-8', errors='replace')
            print(error_output)
            return False
    except Exception as e:
        try:
            print(f"خطأ في تنفيذ الأمر: {e}")
        except UnicodeEncodeError:
            print(f"Error in command execution: {e}")
        print(f"Command execution error: {e}")
        return False

def translate_directory(input_dir, output_dir=None, config_path=None):
    """
    ترجمة جميع الصور في مجلد
    Translate all images in a directory
    """
    if not os.path.exists(input_dir):
        print(f"خطأ: المجلد غير موجود - {input_dir}")
        print(f"Error: Directory not found - {input_dir}")
        return False
    
    # تحديد مجلد الإخراج
    if output_dir is None:
        output_dir = os.path.join(input_dir, "translated_arabic")
    
    # إنشاء مجلد الإخراج إذا لم يكن موجوداً
    os.makedirs(output_dir, exist_ok=True)
    
    # البحث عن الصور
    image_extensions = ['.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.webp']
    image_files = []
    
    for ext in image_extensions:
        image_files.extend(Path(input_dir).glob(f"*{ext}"))
        image_files.extend(Path(input_dir).glob(f"*{ext.upper()}"))
    
    if not image_files:
        print(f"لم يتم العثور على صور في المجلد: {input_dir}")
        print(f"No images found in directory: {input_dir}")
        return False
    
    print(f"تم العثور على {len(image_files)} صورة")
    print(f"Found {len(image_files)} images")
    
    success_count = 0
    for i, image_file in enumerate(image_files, 1):
        print(f"\n--- ترجمة الصورة {i}/{len(image_files)} ---")
        print(f"--- Translating image {i}/{len(image_files)} ---")
        
        output_file = Path(output_dir) / f"{image_file.stem}_arabic{image_file.suffix}"
        
        if translate_single_image(str(image_file), str(output_file), config_path):
            success_count += 1
    
    print(f"\n🎉 تمت ترجمة {success_count} من أصل {len(image_files)} صورة بنجاح!")
    print(f"🎉 Successfully translated {success_count} out of {len(image_files)} images!")
    return success_count > 0

def main():
    parser = argparse.ArgumentParser(
        description="ترجمة المانغا من الإنجليزية إلى العربية / Translate manga from English to Arabic"
    )
    parser.add_argument("input", help="مسار الصورة أو المجلد / Path to image or directory")
    parser.add_argument("-o", "--output", help="مسار الإخراج / Output path")
    parser.add_argument("-c", "--config", default="config_arabic.json", 
                       help="ملف الإعدادات / Config file (default: config_arabic.json)")
    parser.add_argument("-d", "--directory", action="store_true",
                       help="معالجة جميع الصور في المجلد / Process all images in directory")
    
    args = parser.parse_args()
    
    if args.directory or os.path.isdir(args.input):
        translate_directory(args.input, args.output, args.config)
    else:
        translate_single_image(args.input, args.output, args.config)

if __name__ == "__main__":
    main()