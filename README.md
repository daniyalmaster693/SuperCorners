<div align="center">
<img src="https://github.com/daniyalmaster693/SuperCorners/blob/main/SuperCorners/Assets.xcassets/TahoeIcon.imageset/SuperCorners-Tahoe.png" width="140">

  <h1>SuperCorners</h1>
  <p>Supercharge your Mac's Corners</p>

</div>

<div align="center">

[![GitHub License](https://img.shields.io/github/license/daniyalmaster693/SuperCorners)](License)
[![Downloads](https://img.shields.io/github/downloads/daniyalmaster693/SuperCorners/total.svg)](https://github.com/daniyalmaster693/SuperCorners/releases)
[![macOS Version](https://img.shields.io/badge/macOS-13.0%2B-blue.svg)](https://www.apple.com/macos/)

</div>

<br>
<br>

<img src="/Assets/SuperCorners-1.png" width="100%" alt="SuperCorners"/><br/>

SuperCorners is a macOS app that supercharges your screen corners.

I've always loved the Hot Corners feature on macOS, but it's always felt very limited. So I built SuperCorners, which aims to provide a more polished and powerful experience. It builds on Apple's built in Hot Corners with extra trigger zones while providing more control and smarter automation, transforming each corner and zone into a powerful part of your productivity system.

## Features

- **Additional Zones** - Trigger actions when moving your mouse the middle of any screen edge.
- **Launch Apps** - Launch apps directly from corners and zones.
- **Run Shortcuts** - Run shortcuts directly from corners and zones.
- **Open Files and Folders** - Open Files and Folders directly from corners and zones.
- **Run Apple Scripts** - Run apple scripts directly from corners and zones.
- **Open Websites** - Open Websites directly from corners and zones.
- **In App Actions** - Trigger in app actions directly from corners and zones.
- **System Commands** - Run system commands directly from your screen corners and zones.
- **Tools** - Access useful tools from your screen corners and zones.
- **Developer Utilities** - Access useful developer related info directly from your screen corners and zones.
- **Menubar Component** - Access your corner and zone actions right from the menubar for instant control.
- **Visual Feedback** - Subtle toast notifications appear briefly to provide visual feedback for actions.
- **Configurable** - Disable any corner or zone and control app behaviors.
- **Native** - Built with Swift and SwiftUI for a seamless experience that feels well integrated with macOS.

...and more...

## Installation

**Requires macOS 13.0 and later**

### Manual Installation

1. Download the latest release.
2. Move the app to your **Applications folder**.
3. Run the app and grant necessary permissions when prompted.

### Homebrew

You can also install SuperCorners using Homebrew:

```bash
brew tap daniyalmaster693/casks
brew install --cask supercorners
```

**Note**: On first launch, macOS may warn that the app couldn't be verified. Click **OK**, then go to **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** to launch the app.

## Usage

1. Launch **SuperCorners**.
2. Grant Necessary Permissions (**Accessibility permission must be enabled for the app to work correctly**).
3. Use the activation hotkey or modifier key (set in the settings window) to trigger corners and zones when moving your mouse to a corner or the middle of any screen edge.
4. Enjoy the upgraded hot corners experience!

For more information visit the [Getting Started Guide](./GettingStarted.md)

## Roadmap

- [x] ~~Fix toast messages not showing up when app is not active~~
- [x] ~~Improve toast success and error logic~~
- [x] ~~Additional trigger methods for corners and zones~~
- [x] ~~Trigger Actions using only a modifier key~~
- [x] ~~Trigger Actions by clicking~~
- [x] ~~Action List for the Menubar Command (a seperate menu to trigger more actions)~~
- [x] ~~Trigger Actions without any key presses~~
- [ ] Allow assigning seperate actions per monitor
- [ ] Automation based action profiles
- [ ] Allow assigning actions per focus mode
- [ ] Allow creating different global action profiles
- [ ] Allow assigning actions per app
- [ ] Additional in app actions

...and more to come...

## Dependencies

- [Keyboard Shortcuts](https://github.com/sindresorhus/KeyboardShortcuts)
- [LaunchAtLogin Modern](https://github.com/sindresorhus/LaunchAtLogin-Modern)
- [SoulverCore](https://github.com/soulverteam/SoulverCore)
- [Sparkle](https://github.com/sparkle-project/Sparkle)

## Contributions

Any contributions and feedback is welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the [GPLv3 License](License).
