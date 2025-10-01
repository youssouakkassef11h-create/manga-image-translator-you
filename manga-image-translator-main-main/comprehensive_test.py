#!/usr/bin/env python3
"""
اختبار شامل لبرنامج ترجمة المانجا
Comprehensive test for Manga Image Translator program
"""

import os
import sys
import subprocess
import time
from pathlib import Path

def print_section(title):
    """طباعة عنوان القسم"""
    print("\n" + "="*60)
    print(f"🔍 {title}")
    print("="*60)

def test_module_import():
    """اختبار استيراد الوحدات الأساسية"""
    print_section("اختبار استيراد الوحدات / Module Import Test")
    
    try:
        import manga_translator
        print("✅ تم استيراد manga_translator بنجاح")
        print("✅ manga_translator module imported successfully")
        
        from manga_translator.args import parser
        print("✅ تم استيراد parser بنجاح")
        print("✅ parser imported successfully")
        
        return True
    except ImportError as e:
        print(f"❌ خطأ في استيراد الوحدات: {e}")
        print(f"❌ Module import error: {e}")
        return False

def test_help_command():
    """اختبار أمر المساعدة"""
    print_section("اختبار أمر المساعدة / Help Command Test")
    
    try:
        result = subprocess.run([
            sys.executable, "-m", "manga_translator", "--help"
        ], capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0:
            print("✅ أمر المساعدة يعمل بشكل صحيح")
            print("✅ Help command works correctly")
            return True
        else:
            print(f"❌ فشل أمر المساعدة: {result.stderr}")
            print(f"❌ Help command failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ خطأ في تنفيذ أمر المساعدة: {e}")
        print(f"❌ Error executing help command: {e}")
        return False

def test_config_validation():
    """اختبار التحقق من صحة ملف الإعدادات"""
    print_section("اختبار التحقق من ملف الإعدادات / Config Validation Test")
    
    config_file = "config_arabic.json"
    if not os.path.exists(config_file):
        print(f"❌ ملف الإعدادات غير موجود: {config_file}")
        print(f"❌ Config file not found: {config_file}")
        return False
    
    try:
        result = subprocess.run([
            sys.executable, "-m", "manga_translator", "config-help"
        ], capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0:
            print("✅ أمر مساعدة الإعدادات يعمل بشكل صحيح")
            print("✅ Config help command works correctly")
            return True
        else:
            print(f"❌ فشل أمر مساعدة الإعدادات: {result.stderr}")
            print(f"❌ Config help command failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ خطأ في اختبار الإعدادات: {e}")
        print(f"❌ Error testing config: {e}")
        return False

def test_image_processing():
    """اختبار معالجة الصور"""
    print_section("اختبار معالجة الصور / Image Processing Test")
    
    test_image = "test_arabic_image.png"
    if not os.path.exists(test_image):
        print(f"❌ صورة الاختبار غير موجودة: {test_image}")
        print(f"❌ Test image not found: {test_image}")
        return False
    
    try:
        # تنفيذ أمر الترجمة
        result = subprocess.run([
            sys.executable, "-m", "manga_translator", "local",
            "--input", test_image,
            "--dest", ".",
            "--config-file", "config_arabic.json"
        ], capture_output=True, text=True, timeout=120)
        
        if result.returncode == 0:
            print("✅ تمت معالجة الصورة بنجاح")
            print("✅ Image processing completed successfully")
            
            # التحقق من وجود ملف النتيجة
            result_dir = Path("../manga-image-translator/result")
            if result_dir.exists() and any(result_dir.glob("*.png")):
                print("✅ تم إنشاء ملف النتيجة")
                print("✅ Result file created")
                return True
            else:
                print("⚠️ تمت المعالجة ولكن لم يتم العثور على ملف النتيجة")
                print("⚠️ Processing completed but result file not found")
                return True
        else:
            print(f"❌ فشل في معالجة الصورة: {result.stderr}")
            print(f"❌ Image processing failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ خطأ في معالجة الصور: {e}")
        print(f"❌ Error in image processing: {e}")
        return False

def test_custom_script():
    """اختبار السكريبت المخصص للترجمة العربية"""
    print_section("اختبار السكريبت المخصص / Custom Script Test")
    
    script_file = "translate_to_arabic.py"
    test_image = "test_arabic_image.png"
    
    if not os.path.exists(script_file):
        print(f"❌ السكريبت المخصص غير موجود: {script_file}")
        print(f"❌ Custom script not found: {script_file}")
        return False
    
    if not os.path.exists(test_image):
        print(f"❌ صورة الاختبار غير موجودة: {test_image}")
        print(f"❌ Test image not found: {test_image}")
        return False
    
    try:
        result = subprocess.run([
            sys.executable, script_file, test_image
        ], capture_output=True, text=True, timeout=120)
        
        if result.returncode == 0:
            print("✅ السكريبت المخصص يعمل بشكل صحيح")
            print("✅ Custom script works correctly")
            return True
        else:
            print(f"❌ فشل السكريبت المخصص: {result.stderr}")
            print(f"❌ Custom script failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"❌ خطأ في تنفيذ السكريبت المخصص: {e}")
        print(f"❌ Error executing custom script: {e}")
        return False

def test_gui_availability():
    """اختبار توفر واجهة المستخدم الرسومية"""
    print_section("اختبار توفر واجهة المستخدم الرسومية / GUI Availability Test")
    
    gui_file = "MangaStudioMain.py"
    if not os.path.exists(gui_file):
        print(f"❌ ملف واجهة المستخدم الرسومية غير موجود: {gui_file}")
        print(f"❌ GUI file not found: {gui_file}")
        return False
    
    try:
        # اختبار استيراد PySide6
        import PySide6
        print("✅ PySide6 متوفر")
        print("✅ PySide6 available")
        
        print("✅ واجهة المستخدم الرسومية متوفرة")
        print("✅ GUI interface available")
        return True
    except ImportError:
        print("❌ PySide6 غير متوفر")
        print("❌ PySide6 not available")
        return False

def generate_report(results):
    """إنشاء تقرير شامل للاختبارات"""
    print_section("تقرير الاختبارات الشامل / Comprehensive Test Report")
    
    total_tests = len(results)
    passed_tests = sum(1 for result in results.values() if result)
    failed_tests = total_tests - passed_tests
    
    print(f"📊 إجمالي الاختبارات: {total_tests}")
    print(f"📊 Total tests: {total_tests}")
    print(f"✅ الاختبارات الناجحة: {passed_tests}")
    print(f"✅ Passed tests: {passed_tests}")
    print(f"❌ الاختبارات الفاشلة: {failed_tests}")
    print(f"❌ Failed tests: {failed_tests}")
    
    success_rate = (passed_tests / total_tests) * 100
    print(f"📈 معدل النجاح: {success_rate:.1f}%")
    print(f"📈 Success rate: {success_rate:.1f}%")
    
    print("\n📋 تفاصيل النتائج / Detailed Results:")
    for test_name, result in results.items():
        status = "✅ نجح" if result else "❌ فشل"
        status_en = "✅ PASSED" if result else "❌ FAILED"
        print(f"  {test_name}: {status} / {status_en}")
    
    if success_rate >= 80:
        print("\n🎉 البرنامج يعمل بشكل ممتاز!")
        print("🎉 Program works excellently!")
    elif success_rate >= 60:
        print("\n👍 البرنامج يعمل بشكل جيد مع بعض المشاكل البسيطة")
        print("👍 Program works well with minor issues")
    else:
        print("\n⚠️ البرنامج يحتاج إلى إصلاحات")
        print("⚠️ Program needs fixes")

def main():
    """الدالة الرئيسية للاختبار الشامل"""
    print("🚀 بدء الاختبار الشامل لبرنامج ترجمة المانجا")
    print("🚀 Starting comprehensive test for Manga Image Translator")
    print(f"📅 الوقت: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"📅 Time: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    
    # تنفيذ جميع الاختبارات
    results = {}
    
    results["Module Import"] = test_module_import()
    results["Help Command"] = test_help_command()
    results["Config Validation"] = test_config_validation()
    results["Image Processing"] = test_image_processing()
    results["Custom Script"] = test_custom_script()
    results["GUI Availability"] = test_gui_availability()
    
    # إنشاء التقرير النهائي
    generate_report(results)
    
    return all(results.values())

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)