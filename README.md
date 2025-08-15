# 🛜 Vibe WiFi Monitor

<div align="center">
  
  ![Platform](https://img.shields.io/badge/platform-macOS-blue)
  ![Language](https://img.shields.io/badge/language-Objective--C-orange)
  ![License](https://img.shields.io/badge/license-MIT-green)
  ![macOS](https://img.shields.io/badge/macOS-12.0%2B-brightgreen)
  
  <img src="icon.png" width="128" height="128" alt="Vibe WiFi Monitor Icon">
  
  **Native macOS app for real-time WiFi signal monitoring**
  
  [Features](#features) • [Installation](#installation) • [Usage](#usage) • [Localization](#localization) • [Building](#building)
  
</div>

## 📱 About

Vibe WiFi Monitor is a lightweight native macOS application that displays your WiFi signal strength in real-time. Perfect for finding dead zones in your space or optimizing router placement.

## ✨ Features

- 📊 **Real-time Signal Monitoring** - Updates every 500ms
- 📈 **Signal History Graph** - Visual representation of signal changes over time
- 🎨 **Color-coded Quality Indicators** - Instantly see connection quality
- 🌍 **Multi-language Support** - English and Russian (auto-detects system language)
- 📍 **RSSI & Percentage Display** - Both technical and user-friendly metrics
- 🎯 **Native Performance** - Built with Objective-C and CoreWLAN

## 📸 Screenshots

<div align="center">
  <i>Coming soon...</i>
</div>

## 💻 Requirements

- macOS 12.0 (Monterey) or later
- WiFi-enabled Mac
- Location Services permission (for SSID display)

## 📦 Installation

### Option 1: Download Release
1. Go to [Releases](https://github.com/seeingred/vibe-wifi-monitor/releases)
2. Download the latest `.app` file
3. Move to Applications folder
4. Open and enjoy!

### Option 2: Build from Source
```bash
# Clone the repository
git clone https://github.com/seeingred/vibe-wifi-monitor.git
cd vibe-wifi-monitor

# Open in Xcode
open WiFiMonitor.xcodeproj

# Build and run (Cmd+R)
```

## 🚀 Usage

1. Launch the app
2. Grant location permission if prompted (required for SSID display)
3. Walk around your space to map WiFi coverage
4. Watch the real-time signal updates!

### Signal Quality Indicators

| Signal Strength | RSSI Range | Quality | Color |
|----------------|------------|---------|--------|
| Excellent | -50 dBm or higher | Отличный / Excellent | 🟢 Green |
| Good | -60 to -50 dBm | Хороший / Good | 🟢 Light Green |
| Fair | -70 to -60 dBm | Средний / Fair | 🟡 Yellow |
| Weak | -80 to -70 dBm | Слабый / Weak | 🟠 Orange |
| Very Weak | Below -80 dBm | Очень слабый / Very Weak | 🔴 Red |

## 🌐 Localization

The app automatically detects your system language and displays the interface accordingly:

- 🇬🇧 **English** - Default language
- 🇷🇺 **Русский** - Полная поддержка русского языка

To add more languages, contribute to the `Localizable.strings` files in the project.

## 🛠 Building from Source

### Prerequisites
- Xcode 14.0 or later
- Apple Developer Account (for signing)
- macOS 12.0+ SDK

### Build Steps

1. Clone the repository:
```bash
git clone https://github.com/seeingred/vibe-wifi-monitor.git
cd vibe-wifi-monitor
```

2. Open in Xcode:
```bash
open WiFiMonitor.xcodeproj
```

3. Configure signing:
   - Select the project in navigator
   - Go to "Signing & Capabilities"
   - Select your development team

4. Build and run:
   - Press `Cmd+R` or click the Play button

## 🤝 Contributing

Contributions are welcome! Feel free to:

- Report bugs
- Suggest new features
- Submit pull requests
- Add translations

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with Apple's CoreWLAN framework
- Icon design by [Your Name]
- Inspired by the need for better WiFi coverage visibility

## 📮 Contact

- GitHub: [@seeingred](https://github.com/seeingred)
- Issues: [Report a bug](https://github.com/seeingred/vibe-wifi-monitor/issues)

---

<div align="center">
  Made with ❤️ for the macOS community
  
  ⭐ Star this repo if you find it useful!
</div>