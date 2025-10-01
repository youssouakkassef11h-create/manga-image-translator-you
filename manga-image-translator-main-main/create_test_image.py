#!/usr/bin/env python3
"""
Script to create a test image with clear text for Arabic translation testing.
"""

import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont
import os

def create_test_image():
    """Create a test image with English text for translation."""
    # Create a white background image
    width, height = 800, 600
    image = Image.new('RGB', (width, height), 'white')
    draw = ImageDraw.Draw(image)
    
    # Try to use a default font, fallback to basic if not available
    try:
        font = ImageFont.truetype("arial.ttf", 40)
        small_font = ImageFont.truetype("arial.ttf", 24)
    except:
        try:
            font = ImageFont.load_default()
            small_font = ImageFont.load_default()
        except:
            font = None
            small_font = None
    
    # Add some English text that can be translated to Arabic
    texts = [
        ("Hello World!", (50, 50)),
        ("Welcome to our store", (50, 120)),
        ("Good morning", (50, 190)),
        ("Thank you very much", (50, 260)),
        ("How are you today?", (50, 330)),
        ("See you later", (50, 400))
    ]
    
    # Draw text on the image
    for text, position in texts:
        # Draw a light gray background rectangle for each text
        bbox = draw.textbbox(position, text, font=font)
        draw.rectangle([bbox[0]-5, bbox[1]-5, bbox[2]+5, bbox[3]+5], 
                      fill='lightgray', outline='black', width=2)
        
        # Draw the text in black
        draw.text(position, text, fill='black', font=font)
    
    # Add a title
    title = "Test Image for Arabic Translation"
    title_bbox = draw.textbbox((0, 0), title, font=small_font)
    title_x = (width - (title_bbox[2] - title_bbox[0])) // 2
    draw.text((title_x, 10), title, fill='blue', font=small_font)
    
    # Save the image
    output_path = "test_image_with_text.png"
    image.save(output_path)
    print(f"Test image created: {output_path}")
    
    return output_path

if __name__ == "__main__":
    create_test_image()