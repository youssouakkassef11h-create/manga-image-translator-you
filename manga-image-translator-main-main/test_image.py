#!/usr/bin/env python3
"""
إنشاء صورة اختبار بسيطة تحتوي على نص عربي لاختبار برنامج manga-translator
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_test_image():
    """إنشاء صورة اختبار تحتوي على نص عربي"""
    
    # إنشاء صورة بيضاء
    width, height = 800, 600
    image = Image.new('RGB', (width, height), 'white')
    draw = ImageDraw.Draw(image)
    
    # النصوص العربية للاختبار
    arabic_texts = [
        "مرحباً بكم في عالم المانجا",
        "هذا نص تجريبي للترجمة",
        "البرنامج يدعم اللغة العربية",
        "اختبار الكتابة من اليمين لليسار"
    ]
    
    try:
        # محاولة استخدام خط عربي إذا كان متوفراً
        font_paths = [
            "fonts/Arial-Unicode-Regular.ttf",
            "C:/Windows/Fonts/arial.ttf",
            "C:/Windows/Fonts/calibri.ttf"
        ]
        
        font = None
        for font_path in font_paths:
            if os.path.exists(font_path):
                try:
                    font = ImageFont.truetype(font_path, 40)
                    break
                except:
                    continue
        
        if font is None:
            font = ImageFont.load_default()
            
    except Exception as e:
        print(f"تحذير: لا يمكن تحميل الخط، سيتم استخدام الخط الافتراضي: {e}")
        font = ImageFont.load_default()
    
    # رسم النصوص على الصورة
    y_position = 100
    for text in arabic_texts:
        # رسم مستطيل خلفية للنص
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        
        x_position = (width - text_width) // 2
        
        # رسم خلفية بيضاء للنص
        draw.rectangle([x_position-10, y_position-10, 
                       x_position+text_width+10, y_position+text_height+10], 
                      fill='lightgray', outline='black', width=2)
        
        # رسم النص
        draw.text((x_position, y_position), text, fill='black', font=font)
        
        y_position += 120
    
    # حفظ الصورة
    output_path = "test_arabic_image.png"
    image.save(output_path)
    print(f"تم إنشاء صورة الاختبار: {output_path}")
    
    return output_path

if __name__ == "__main__":
    create_test_image()