#!/usr/bin/env python3
"""Generate PWA icons from SVG"""
import subprocess
import sys
import os
import shutil

def convert_svg_to_png(svg_file, png_file, size):
    """Convert SVG to PNG using various methods"""
    # Try using cairosvg (Python library)
    try:
        import cairosvg
        cairosvg.svg2png(url=svg_file, write_to=png_file, output_width=size, output_height=size)
        return True
    except ImportError:
        pass
    
    # Try using rsvg-convert
    rsvg_paths = [
        'rsvg-convert',
        '/usr/local/bin/rsvg-convert',
        '/opt/homebrew/bin/rsvg-convert',
        '/usr/bin/rsvg-convert'
    ]
    for rsvg_cmd in rsvg_paths:
        if shutil.which(rsvg_cmd) or os.path.exists(rsvg_cmd):
            try:
                subprocess.run([rsvg_cmd, '-w', str(size), '-h', str(size), svg_file, '-o', png_file], 
                              check=True, stderr=subprocess.DEVNULL)
                return True
            except (subprocess.CalledProcessError, FileNotFoundError):
                pass
    
    # Try using ImageMagick convert
    magick_paths = ['convert', '/usr/local/bin/convert', '/opt/homebrew/bin/convert']
    for convert_cmd in magick_paths:
        if shutil.which(convert_cmd) or os.path.exists(convert_cmd):
            try:
                subprocess.run([convert_cmd, '-background', 'none', '-resize', f'{size}x{size}', svg_file, png_file],
                              check=True, stderr=subprocess.DEVNULL)
                return True
            except (subprocess.CalledProcessError, FileNotFoundError):
                pass
    
    return False

def main():
    svg_file = 'docs/infinity-7-layered.svg'
    
    if not os.path.exists(svg_file):
        print(f"Error: {svg_file} not found")
        sys.exit(1)
    
    # Generate different sizes
    sizes = [192, 512]
    
    for size in sizes:
        png_file = f'docs/icon-{size}.png'
        print(f"Generating {png_file}...")
        if convert_svg_to_png(svg_file, png_file, size):
            print(f"✅ Created {png_file}")
        else:
            print(f"⚠️  Could not convert {svg_file} to PNG")
            print("   Install one of: pip3 install cairosvg, brew install librsvg, or brew install imagemagick")
            sys.exit(1)
    
    print("\n✅ All PWA icons generated successfully!")

if __name__ == '__main__':
    main()
