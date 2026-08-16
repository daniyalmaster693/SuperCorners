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

<img src="/Assets/Mockups/SuperCorners-Cover.png" width="100%" alt="SuperCorners"/><br/>

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
- **Menubar Component** - Access your corner and zone actions right from the menubar for instant control.
- **Visual Feedback** - Subtle toast notifications appear briefly to provide visual feedback for actions.
- **Configurable** - Disable any corner or zone and control app behaviors.
- **Native** - Built with Swift and SwiftUI for a seamless experience that feels well integrated with macOS.

...and more...

## Installation

**Requires macOS 13.0 and later**

### Manual Installation

1. Open the [latest release](https://github.com/daniyalmaster693/SuperCorners/releases/latest) and download `SuperCorners.zip`.
2. Open the `.zip` file and drag the app file into your **Applications** folder.

**Note:** Because the app is not signed, on first launch, macOS may warn that the app couldn't be verified. To open it:

1. Click **Done** on the warning prompt.
2. Open **System Settings → Privacy & Security**.
3. Scroll down to the security section and click **Open Anyway**.

4. Download the latest release.
5. Move the app to your **Applications folder**.
6. Run the app and grant necessary permissions when prompted.

### Homebrew

You can also install SuperCorners using Homebrew:

```bash
brew tap daniyalmaster693/casks
brew trust --cask daniyalmaster693/casks/supercorners
brew install --cask supercorners
xattr -dr com.apple.quarantine /Applications/SuperCorners.app
```

## Usage

1. Launch **SuperCorners**.
2. Grant Necessary Permissions (**Accessibility permission must be enabled for certain actions to function**).
3. Trigger corners and zones by moving your mouse to a corner or the middle of a screen edge. You can also optionally choose to require a modifier key or keyboard shortcut to prevent accidental activation.
4. Additional behaviors can be configured in the settings tab, such as the sensitivity, an action delay, toast messages, sound effects, and more.

For more information visit the [Getting Started Guide](./GettingStarted.md)

## Roadmap

- [x] ~~Additional trigger methods for corners and zones~~
- [x] ~~Trigger Actions using only a modifier key~~
- [x] ~~Trigger Actions by clicking~~
- [x] ~~Trigger Actions without any key presses~~
- [ ] Simulating keyboard shortcuts
- [ ] Automation based action profiles
- [ ] Allow assigning actions per focus mode
- [ ] Allow assigning actions per app
- [ ] Allow assigning actions per display
- [ ] Additional in app actions

...and more to come...

## Dependencies

- [Keyboard Shortcuts](https://github.com/sindresorhus/KeyboardShortcuts)
- [TourKit](https://github.com/rampatra/TourKit)

## Contributions

Any contributions and feedback is welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the [GPLv3 License](License).
