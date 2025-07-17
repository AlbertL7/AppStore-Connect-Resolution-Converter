#!/bin/bash

# Apple App Store Preview Converter - Using ACCEPTED resolutions
# Based on official Apple specifications

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create output directory
OUTPUT_DIR="app_store_previews"
mkdir -p "$OUTPUT_DIR"

# Apple's ACCEPTED resolutions (not device resolutions!)
# Most sizes use 886x1920 for portrait
STANDARD_PORTRAIT="886x1920"
IPHONE_55_PORTRAIT="1080x1920"
IPHONE_47_PORTRAIT="750x1334"

# Create subdirectories
mkdir -p "$OUTPUT_DIR/standard_886x1920"
mkdir -p "$OUTPUT_DIR/iphone_5.5_1080x1920"
mkdir -p "$OUTPUT_DIR/iphone_4.7_750x1334"

echo -e "${BLUE}Apple App Store Preview Converter${NC}"
echo -e "${BLUE}Using Apple's accepted resolutions${NC}"
echo ""

# Function to convert video
convert_video() {
    local input_file="$1"
    local filename="${input_file%.mov}"
    local basename=$(basename "$filename")
    
    echo -e "${GREEN}Processing: $input_file${NC}"
    
    # 1. Standard resolution (886x1920) - covers 6.9", 6.5", 6.3", 6.1", and 4" displays
    echo -e "${YELLOW}  Creating standard preview (886x1920) for most iPhone sizes...${NC}"
    
    ffmpeg -i "$input_file" \
        -vf "scale=886:1920:force_original_aspect_ratio=decrease,pad=886:1920:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -c:v libx264 \
        -profile:v high -level 4.0 \
        -crf 20 \
        -r 30 \
        -b:v 10M \
        -maxrate 12M \
        -bufsize 12M \
        -movflags +faststart \
        -pix_fmt yuv420p \
        -c:a aac -b:a 256k -ar 48000 \
        -hide_banner -loglevel error \
        "$OUTPUT_DIR/standard_886x1920/${basename}_886x1920.mp4"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Created standard preview${NC}"
    else
        echo -e "${RED}  ✗ Failed to create standard preview${NC}"
    fi
    
    # 2. iPhone 5.5" resolution (1080x1920)
    echo -e "${YELLOW}  Creating 5.5\" preview (1080x1920)...${NC}"
    
    ffmpeg -i "$input_file" \
        -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -c:v libx264 \
        -profile:v high -level 4.0 \
        -crf 20 \
        -r 30 \
        -b:v 10M \
        -maxrate 12M \
        -bufsize 12M \
        -movflags +faststart \
        -pix_fmt yuv420p \
        -c:a aac -b:a 256k -ar 48000 \
        -hide_banner -loglevel error \
        "$OUTPUT_DIR/iphone_5.5_1080x1920/${basename}_1080x1920.mp4"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Created 5.5\" preview${NC}"
    else
        echo -e "${RED}  ✗ Failed to create 5.5\" preview${NC}"
    fi
    
    # 3. iPhone 4.7" resolution (750x1334)
    echo -e "${YELLOW}  Creating 4.7\" preview (750x1334)...${NC}"
    
    ffmpeg -i "$input_file" \
        -vf "scale=750:1334:force_original_aspect_ratio=decrease,pad=750:1334:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -c:v libx264 \
        -profile:v high -level 4.0 \
        -crf 20 \
        -r 30 \
        -b:v 10M \
        -maxrate 12M \
        -bufsize 12M \
        -movflags +faststart \
        -pix_fmt yuv420p \
        -c:a aac -b:a 256k -ar 48000 \
        -hide_banner -loglevel error \
        "$OUTPUT_DIR/iphone_4.7_750x1334/${basename}_750x1334.mp4"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✓ Created 4.7\" preview${NC}"
    else
        echo -e "${RED}  ✗ Failed to create 4.7\" preview${NC}"
    fi
    
    echo ""
}

# Check for ffmpeg
if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}Error: ffmpeg not installed${NC}"
    exit 1
fi

# Find .mov files
mov_files=(*.mov)

if [ ! -e "${mov_files[0]}" ]; then
    echo -e "${RED}No .mov files found${NC}"
    exit 1
fi

echo -e "${GREEN}Found ${#mov_files[@]} .mov file(s)${NC}"
echo ""

# Process each file
for mov_file in "${mov_files[@]}"; do
    convert_video "$mov_file"
done

# Summary
echo -e "${GREEN}Conversion complete!${NC}"
echo ""
echo -e "${YELLOW}Upload Instructions:${NC}"
echo "1. Go to App Store Connect > Your App > App Previews"
echo ""
echo "2. Upload files based on device size:"
echo "   - For 6.9\", 6.5\", 6.3\", 6.1\" displays → Use files from 'standard_886x1920'"
echo "   - For 5.5\" displays (iPhone 8 Plus, etc.) → Use files from 'iphone_5.5_1080x1920'"
echo "   - For 4.7\" displays (iPhone SE, iPhone 8) → Use files from 'iphone_4.7_750x1334'"
echo ""
echo "3. Apple will automatically scale these to fit each specific device"
echo ""

# Show created files
echo "Created files:"
find "$OUTPUT_DIR" -name "*.mp4" -type f | while read file; do
    size=$(ls -lh "$file" | awk '{print $5}')
    echo "  $file ($size)"
done
