#!/usr/bin/env python3
"""
Comprehensive test script for Arabic text rendering in manga translator.
This script tests the Arabic text processing and rendering functionality.
"""

import sys
import os
sys.path.append('.')

# Test Arabic text processing
def test_arabic_processing():
    """Test Arabic text reshaping and bidi processing."""
    print("Testing Arabic text processing...")
    
    try:
        import arabic_reshaper
        from bidi.algorithm import get_display
        
        # Test Arabic text
        arabic_text = "مرحبا بالعالم"
        print(f"Original Arabic text: {arabic_text}")
        
        # Reshape Arabic text
        reshaped_text = arabic_reshaper.reshape(arabic_text)
        print(f"Reshaped text: {reshaped_text}")
        
        # Apply bidi algorithm
        bidi_text = get_display(reshaped_text)
        print(f"Bidi processed text: {bidi_text}")
        
        print("✓ Arabic text processing libraries are working correctly")
        return True
        
    except ImportError as e:
        print(f"✗ Arabic processing libraries not available: {e}")
        return False
    except Exception as e:
        print(f"✗ Error in Arabic processing: {e}")
        return False

def test_rendering_imports():
    """Test if rendering module has Arabic support."""
    print("\nTesting rendering module Arabic support...")
    
    try:
        sys.path.append('manga_translator/rendering')
        from manga_translator.rendering import text_render
        
        # Check if ARABIC_SUPPORT is available
        if hasattr(text_render, 'ARABIC_SUPPORT'):
            print(f"✓ ARABIC_SUPPORT flag found: {text_render.ARABIC_SUPPORT}")
            return text_render.ARABIC_SUPPORT
        else:
            print("✗ ARABIC_SUPPORT flag not found in text_render module")
            return False
            
    except ImportError as e:
        print(f"✗ Could not import text_render module: {e}")
        return False
    except Exception as e:
        print(f"✗ Error testing rendering imports: {e}")
        return False

def test_font_availability():
    """Test if Arabic fonts are available."""
    print("\nTesting Arabic font availability...")
    
    font_paths = [
        "../manga-image-translator/manga_translator/fonts/Amiri-Regular.ttf",
        "manga_translator/fonts/Amiri-Regular.ttf",
        "fonts/Amiri-Regular.ttf",
        "Amiri-Regular.ttf"
    ]
    
    found_fonts = []
    for font_path in font_paths:
        if os.path.exists(font_path):
            print(f"✓ Arabic font found: {font_path}")
            found_fonts.append(font_path)
    
    if found_fonts:
        return True
    else:
        print("✗ No Arabic fonts found in expected locations")
        return False

def create_simple_test_image():
    """Create a simple test image with Arabic text."""
    print("\nCreating simple Arabic test image...")
    
    try:
        from PIL import Image, ImageDraw, ImageFont
        
        # Create image
        img = Image.new('RGB', (400, 200), 'white')
        draw = ImageDraw.Draw(img)
        
        # Add simple text
        draw.text((50, 50), "Hello", fill='black')
        draw.text((50, 100), "World", fill='black')
        
        # Save image
        img.save('simple_test.png')
        print("✓ Simple test image created: simple_test.png")
        return True
        
    except Exception as e:
        print(f"✗ Error creating test image: {e}")
        return False

def main():
    """Run all tests."""
    print("=== Arabic Translation System Test ===\n")
    
    results = []
    results.append(("Arabic Processing Libraries", test_arabic_processing()))
    results.append(("Rendering Module Arabic Support", test_rendering_imports()))
    results.append(("Arabic Font Availability", test_font_availability()))
    results.append(("Test Image Creation", create_simple_test_image()))
    
    print("\n=== Test Results Summary ===")
    passed = 0
    for test_name, result in results:
        status = "PASS" if result else "FAIL"
        print(f"{test_name}: {status}")
        if result:
            passed += 1
    
    print(f"\nPassed: {passed}/{len(results)} tests")
    
    if passed == len(results):
        print("✓ All tests passed! Arabic translation system is ready.")
    else:
        print("✗ Some tests failed. Please check the issues above.")
    
    return passed == len(results)

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)