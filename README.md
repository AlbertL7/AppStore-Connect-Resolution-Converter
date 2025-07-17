# AppStore-Connect-Resolution-Converter
Apple App Store Preview Converter
A bash script that automatically converts iPhone screen recordings to Apple's accepted App Store preview resolutions.
🎯 Purpose
When you record app previews using QuickTime or iPhone screen recording, the videos are captured at device resolution (e.g., 1290x2796 for iPhone 15 Pro Max). However, Apple requires specific "accepted resolutions" that are different from device resolutions. This script handles the conversion automatically.
📱 Supported Resolutions
The script creates three accepted resolutions that cover all iPhone models:
ResolutionCoversiPhone Models886 x 19206.9", 6.5", 6.3", 6.1", 4.0" displaysiPhone 16/15/14/13/12 (all variants), iPhone SE 1st gen1080 x 19205.5" displaysiPhone 8 Plus, 7 Plus, 6s Plus, 6 Plus750 x 13344.7" displaysiPhone SE 2nd/3rd gen, iPhone 8, 7, 6s, 6
🚀 Quick Start
bash# Clone or download the script
curl -O https://raw.githubusercontent.com/albertl7/app-preview-converter/main/convert_previews.sh

# Make it executable
chmod +x convert_previews.sh

# Run in directory with .mov files
./convert_previews.sh
📋 Requirements

macOS (tested on macOS 10.15+)
FFmpeg installed (brew install ffmpeg)
.mov files from QuickTime or iPhone screen recording

💻 Installation
Install FFmpeg (if not already installed)
bash# Using Homebrew
brew install ffmpeg

# Verify installation
ffmpeg -version
🎬 Usage

Place all your .mov screen recordings in a directory
Copy the script to the same directory
Run the script:

bash./convert_previews.sh
The script will:

Process all .mov files in the current directory
Create an app_store_previews folder with subfolders for each resolution
Convert videos to Apple's specifications (H.264, 30fps, 10-12 Mbps)

📁 Output Structure
app_store_previews/
├── standard_886x1920/
│   ├── MyApp_Demo_886x1920.mp4
│   └── MyApp_Tutorial_886x1920.mp4
├── iphone_5.5_1080x1920/
│   ├── MyApp_Demo_1080x1920.mp4
│   └── MyApp_Tutorial_1080x1920.mp4
└── iphone_4.7_750x1334/
    ├── MyApp_Demo_750x1334.mp4
    └── MyApp_Tutorial_750x1334.mp4
📤 Uploading to App Store Connect

Sign in to App Store Connect
Navigate to your app → App Information → App Previews
Upload files based on device size:

For most modern iPhones → Use files from standard_886x1920/
For iPhone 8 Plus and similar → Use files from iphone_5.5_1080x1920/
For iPhone SE, iPhone 8 → Use files from iphone_4.7_750x1334/



⚙️ Technical Specifications
The script ensures compliance with Apple's requirements:

Video Format: H.264, High Profile Level 4.0
Bitrate: 10-12 Mbps (target 10 Mbps)
Frame Rate: 30 fps
Audio: AAC 256kbps, 48kHz stereo
Pixel Format: yuv420p
Duration: Must be 15-30 seconds (script doesn't trim)
File Size: Max 500MB

🐛 Troubleshooting
"declare: -A: invalid option" error
Your bash version is too old. Use zsh instead:
bashzsh ./convert_previews.sh
No output files created
Check if FFmpeg is properly installed:
bashffmpeg -codecs | grep h264
Files too large
The script uses CRF 20 for quality. Increase to 23-25 for smaller files:
bash# Edit the script and change -crf 20 to -crf 23
📝 Important Notes

Input videos must be 15-30 seconds (script doesn't trim)
Apple will automatically scale the uploaded previews to fit each device
You can upload up to 3 preview videos per resolution
Landscape orientation is also supported (script maintains original orientation)

🤝 Contributing
Feel free to submit issues or pull requests. Some ideas for improvement:

Auto-trim to 30 seconds
Batch processing with progress bar
GUI version
Support for iPad resolutions

📄 License
MIT License - feel free to use and modify as needed.
🔗 Resources

Apple's App Preview Specifications
App Store Connect Help
FFmpeg Documentation


Note: This script is not affiliated with Apple Inc. Always refer to the latest official Apple documentation for the most current requirements.
