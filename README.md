<div align="center">
  
  <!-- PLACE YOUR LOGO HERE -->
  <img src="https://github.com/user-attachments/assets/49b4898d-e443-4232-866b-17a18369dfaf" alt="Bloom Logo" width="150"/>
  <br/>

  # Bloom
  
  **🔒 Secured as a Bank • ☎️ Simple as SMS • 🏎 Fast as Formula 1**
  
  <p align="center">
    <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-26.0%2B-black?style=for-the-badge&logo=apple" alt="iOS 26+"/></a>
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0-orange?style=for-the-badge&logo=swift" alt="Swift 6.0"/></a>
    <a href="https://github.com/airbnb/lottie-ios"><img src="https://img.shields.io/badge/Lottie-4.6.1-blue?style=for-the-badge" alt="Lottie"/></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-green?style=for-the-badge" alt="License GPLv3"/></a>
  </p>

  <p align="center">
    A next-generation iOS messaging experience built purely in Swift & SwiftUI. Features heavy emphasis on UX, FaceID security, custom Metal shaders, and Liquid glass.
  </p>
</div>

---

## ✨ What makes it cool?

- **Custom Navigation Engine:** Goodbye default `NavigationStack`. Bloom uses a custom, highly responsive, gesture-driven AppRouter with spring physics and depth-scaled transitions.
- **Metal Shaders at the Core:** Hardware-accelerated UI features including the buttery smooth **Ambient Underglow** and a hypnotic **Gooey Effect** (`.metal` shaders integrated directly with SwiftUI).
- **Liquid glass Built-in:** Built-in native Liquid glass support with planning for iOS 18
- **Zero-Compromise Security:** Native, root-level biometric barrier (`FaceID`) required to unlock the experience.
- **Performant by Design:** Fully built on the new SwiftUI `@Observable` macro framework ensuring minimal view reloads and top-tier frame rates.

## 🛠 Tech Stack & Under the Hood

- **UI Framework:** SwiftUI & Custom CoreGraphics
- **Language:** Swift 6.0+ (Utilizing modern concurrency: `async/await`, `Task`, `@MainActor`)
- **State Management:** Native `@Observable`
- **Authentication:** `LocalAuthentication` (Biometrics / Face ID)
- **External SPM Dependencies:**
  - `LiquidGlassKit` — Liquid glass components and iOS 18 support.
  - `BlurUIKit / BlurSwiftUI` — Advanced varying blurs and dimming overshoot.
  - `lottie-spm` — High quality vector animations (e.g. animated Face ID icon).

### Highlighted Architecture Features
*   **Custom Bottom Sheets:** Highly interactable, drag-aware, pan-gesture-based modal controllers without relying on iOS native partial sheets.
*   **Intelligent Keyboard Awareness:** Uses custom UIViewController wrappers (`KeyboardPinnedView`) to magically pin inputs atop keyboards perfectly matched with UIKit physics.
*   **Theme Engine:** Global configuration handling typography (`Open Runde` font family), line spacing, and dynamic hex colors effortlessly (`Theme.swift`).

## 🚀 Getting Started

### Requirements
- **Xcode 26.0+**
- **iOS 26.0+ target device/simulator**
- *An iOS device with FaceID is heavily recommended to test the native auth flow properly.*

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/slipe-fun/Bloom-iOS.git
   cd Bloom-iOS
   ```
2. Open the project in Xcode:
   ```bash
   open Bloom.xcodeproj
   ```
3. Let SPM resolve dependencies automatically.
4. Set your Signing / Team in the target settings.
5. Hit `Cmd + R` (▶) to build and run!

## 🔐 Security Note
The application requests FaceID immediately upon booting (`WelcomeScreen`). The fake `BiometricAuthManager` demonstrates unlocking the internal router. Since iOS Simulator can test FaceID (Features > FaceID > Enrolled), verify you've enrolled it before tapping "Continue with FaceID".

## 📄 License
Bloom is released under the **GNU GPLv3** license. See the [LICENSE](LICENSE) file for more details. 
You are free to use, study, share and modify the software as long as you open-source the derivative work!

---
<div align="center">
  <i>Crafted with ❤️ for best UX and uncompromising performance.</i>
</div>
