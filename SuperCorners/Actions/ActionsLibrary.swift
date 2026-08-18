//
//  ActionsLibrary.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import KeyboardShortcuts
import SwiftUI
import Vision

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    var showRecentColors: Bool {
        UserDefaults.standard.bool(forKey: "showRecentColors")
    }

    var colorFormat: SettingsView.ColorFormat {
        get {
            SettingsView.ColorFormat(rawValue: UserDefaults.standard.string(forKey: "colorFormat") ?? "Hex") ?? .hex
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "colorFormat")
        }
    }

    var showRecentText: Bool {
        UserDefaults.standard.bool(forKey: "showRecentText")
    }
}

extension NSColor {
    func hslComponents() -> (hue: CGFloat, saturation: CGFloat, lightness: CGFloat) {
        guard let rgbColor = usingColorSpace(.deviceRGB) else {
            return (0, 0, 0)
        }

        let r = rgbColor.redComponent
        let g = rgbColor.greenComponent
        let b = rgbColor.blueComponent

        let maxVal = max(r, g, b)
        let minVal = min(r, g, b)
        let delta = maxVal - minVal

        let l = (maxVal + minVal) / 2

        let s: CGFloat
        if delta == 0 {
            s = 0
        } else {
            s = delta / (1 - abs(2 * l - 1))
        }

        let h: CGFloat
        if delta == 0 {
            h = 0
        } else if maxVal == r {
            h = 60 * fmod((g - b) / delta, 6)
        } else if maxVal == g {
            h = 60 * (((b - r) / delta) + 2)
        } else {
            h = 60 * (((r - g) / delta) + 4)
        }

        return (hue: h < 0 ? h + 360 : h, saturation: s, lightness: l)
    }
}

var caffeinateProcess: Process?

struct CornerAction: Identifiable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let tag: String
    let requiresInput: Bool
    let inputKey: String? = nil
    let inputPrompt: String?
    let perform: (_ input: String?) -> Void
}

let cornerActions: [CornerAction] = [
    CornerAction(
        id: "0",
        title: "Start Screen Saver",
        description: "Activate the screen saver",
        iconName: "display",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Library/CoreServices/ScreenSaverEngine.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "1",
        title: "Put Display to Sleep",
        description: "Sleep your Mac",
        iconName: "moon.fill",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/bin/pmset"
            task.arguments = ["displaysleepnow"]
            try? task.run()
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "2",
        title: "Lock Screen",
        description: "Locks your Mac and returns to the login screen.",
        iconName: "lock.fill",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: 12, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskControl]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: 12, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskControl]

            let loc = CGEventTapLocation.cghidEventTap
            keyDown?.post(tap: loc)
            keyUp?.post(tap: loc)
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "3",
        title: "Open Spotlight Search",
        description: "Open the Spotlight Search Window",
        iconName: "magnifyingglass",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let spaceKeyCode: CGKeyCode = 49 // Space key code
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: spaceKeyCode, keyDown: true)
            keyDown?.flags = [.maskCommand]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: spaceKeyCode, keyDown: false)
            keyUp?.flags = [.maskCommand]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "4",
        title: "Open Spotlight Apps",
        description: "Open the Spotlight Applications Folder.",
        iconName: "square.grid.2x2",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Applications/Apps.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "5",
        title: "Show Mission Control",
        description: "Display all open windows and spaces.",
        iconName: "rectangle.stack.fill",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Applications/Mission Control.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "6",
        title: "Application Windows",
        description: "Show all windows for the current application.",
        iconName: "rectangle.on.rectangle.angled",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let script = """
                tell application "System Events"
                    key code 125 using control down -- Down Arrow
                end tell
                """
                let task = Process()
                task.launchPath = "/usr/bin/osascript"
                task.arguments = ["-e", script]

                do {
                    try task.run()
                    task.waitUntilExit()
                    showSuccessToast()
                } catch {
                    showErrorToast("Failed to show application windows")
                }
            }
        }
    ),

    CornerAction(
        id: "7",
        title: "Open Notification Center",
        description: "Open Notification Center",
        iconName: "bell.badge",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeN: CGKeyCode = 45
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
            keyDown?.flags = [.maskSecondaryFn]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
            keyUp?.flags = [.maskSecondaryFn]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "8",
        title: "Toggle WiFi",
        description: "Toggles WiFi on or off based on current state.",
        iconName: "wifi",
        tag: "System",
        requiresInput: false,
        inputPrompt: nil,
        perform: { _ in
            let statusTask = Process()
            statusTask.launchPath = "/usr/sbin/networksetup"
            statusTask.arguments = ["-getairportpower", "en0"]

            let outputPipe = Pipe()
            statusTask.standardOutput = outputPipe

            do {
                try statusTask.run()
                statusTask.waitUntilExit()

                let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
                guard let output = String(data: outputData, encoding: .utf8) else {
                    showErrorToast("Could not read Wi-Fi status.")
                    return
                }

                let isOn = output.contains("On")
                let newState = isOn ? "off" : "on"

                let toggleTask = Process()
                toggleTask.launchPath = "/usr/sbin/networksetup"
                toggleTask.arguments = ["-setairportpower", "en0", newState]

                let errorPipe = Pipe()
                toggleTask.standardError = errorPipe

                try toggleTask.run()
                toggleTask.waitUntilExit()

                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                let errorOutput = String(data: errorData, encoding: .utf8) ?? ""

                if !errorOutput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showErrorToast("Failed to toggle Wi-Fi")
                } else {
                    showSuccessToast("Wi-Fi turned \(newState.uppercased()) successfully")
                }

            } catch {
                showErrorToast("Failed to toggle Wi-Fi")
            }
        }
    ),

    CornerAction(
        id: "9",
        title: "Toggle Theme",
        description: "Toggle dark or light mode",
        iconName: "sun.max",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let toggleScript = """
            tell application "System Events"
                tell appearance preferences
                    set dark mode to not dark mode
                end tell
            end tell
            """

            let checkScript = """
            tell application "System Events"
                tell appearance preferences
                    return dark mode
                end tell
            end tell
            """

            let toggleTask = Process()
            toggleTask.launchPath = "/usr/bin/osascript"
            toggleTask.arguments = ["-e", toggleScript]

            do {
                try toggleTask.run()
                toggleTask.waitUntilExit()

                let checkTask = Process()
                checkTask.launchPath = "/usr/bin/osascript"
                checkTask.arguments = ["-e", checkScript]

                let pipe = Pipe()
                checkTask.standardOutput = pipe

                try checkTask.run()
                checkTask.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "false"

                if output.lowercased() == "true" {
                    showSuccessToast("Toggled Dark Mode", icon: Image(systemName: "moon.fill"))
                } else {
                    showSuccessToast("Toggled Light Mode", icon: Image(systemName: "sun.max.fill"))
                }

            } catch {
                showErrorToast("Failed to toggle Dark Mode")
            }
        }
    ),

    CornerAction(
        id: "10",
        title: "Toggle Keep Awake",
        description: "Toggle system sleep prevention indefinitely on or off.",
        iconName: "powerplug.fill",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            if let existingProcess = caffeinateProcess, existingProcess.isRunning {
                existingProcess.terminate()
                caffeinateProcess = nil
                showSuccessToast("Caffeinate Turned Off", icon: Image(systemName: "powerplug.fill"))
            } else {
                let newProcess = Process()
                newProcess.launchPath = "/usr/bin/caffeinate"
                do {
                    try newProcess.run()
                    caffeinateProcess = newProcess
                    showSuccessToast("Caffeinate Turned On", icon: Image(systemName: "powerplug.fill"))
                } catch {
                    showErrorToast("Failed to Toggle Caffeinate")
                }
            }
        }
    ),

    CornerAction(
        id: "11",
        title: "Create a New Note",
        description: "Create a New Note in Apple Notes",
        iconName: "note.text",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let appPath = "/System/Applications/Notes.app"
            let url = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Notes").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeN: CGKeyCode = 45

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                    keyDown?.flags = [.maskCommand]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                    keyUp?.flags = [.maskCommand]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "12",
        title: "Create a New Event",
        description: "Create a New Event in Calendar",
        iconName: "calendar.badge.plus",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let appPath = "/System/Applications/Calendar.app"
            let url = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.calendar").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeN: CGKeyCode = 45

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                    keyDown?.flags = [.maskCommand]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                    keyUp?.flags = [.maskCommand]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "13",
        title: "Create a New Reminder",
        description: "Create a New Reminder in Reminders",
        iconName: "list.bullet",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let appPath = "/System/Applications/Reminder.app"
            let url = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.reminder.calendar").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeN: CGKeyCode = 45

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                    keyDown?.flags = [.maskCommand]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                    keyUp?.flags = [.maskCommand]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "14",
        title: "Compose a New Email",
        description: "Compose a New Email in Mail",
        iconName: "envelope",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let appPath = "/System/Applications/Mail.app"
            let url = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.mail").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeN: CGKeyCode = 45

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                    keyDown?.flags = [.maskCommand]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                    keyUp?.flags = [.maskCommand]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "15",
        title: "Start a Voice Recording",
        description: "Start a voice recording in voice memos",
        iconName: "waveform",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let voiceMemosPath = "/System/Applications/VoiceMemos.app"
            let url = URL(fileURLWithPath: voiceMemosPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.VoiceMemos").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeN: CGKeyCode = 45

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                    keyDown?.flags = [.maskCommand]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                    keyUp?.flags = [.maskCommand]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "16",
        title: "Open AirDrop",
        description: "Open AirDrop in Finder.",
        iconName: "square.and.arrow.up",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Library/CoreServices/Finder.app/Contents/Applications/AirDrop.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "17",
        title: "Copy Current Page in Safari",
        description: "Copy the current page url in safari.",
        iconName: "link",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let script = """
            tell application "Safari"
                if exists front document then
                    return URL of front document
                else
                    return ""
                end if
            end tell
            """

            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", script]

            let pipe = Pipe()
            task.standardOutput = pipe
            do {
                try task.run()
                task.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let url = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !url.isEmpty
                {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(url, forType: .string)
                    showSuccessToast()
                } else {
                    showErrorToast("No page open in Safari")
                }
            } catch {
                showErrorToast("Failed to fetch URL")
            }
        }
    ),

    CornerAction(
        id: "18",
        title: "Create New Folder",
        description: "Creates a new folder in Finder.",
        iconName: "folder.badge.plus",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let finderPath = "/System/Library/CoreServices/Finder.app"
            let url = URL(fileURLWithPath: finderPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Finder").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let nKeyCode: CGKeyCode = 45 // 'N' key
                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: nKeyCode, keyDown: true)
                    keyDown?.flags = [.maskCommand, .maskShift]
                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: nKeyCode, keyDown: false)
                    keyUp?.flags = [.maskCommand, .maskShift]
                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "19",
        title: "Create New File",
        description: "Creates a new file in a user selected folder.",
        iconName: "doc.text",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
            panel.allowsMultipleSelection = false
            panel.prompt = "Select Folder"

            panel.begin { result in
                guard result == .OK, let folderURL = panel.url else {
                    showErrorToast("Error: No folder selected.")
                    return
                }

                let task = Process()
                task.launchPath = "/usr/bin/touch"
                task.arguments = ["file.txt"]
                task.currentDirectoryURL = folderURL

                let errorPipe = Pipe()
                task.standardError = errorPipe

                do {
                    try task.run()
                    task.waitUntilExit()

                    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                    if let errorOutput = String(data: errorData, encoding: .utf8),
                       !errorOutput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    {
                        showErrorToast("Error creating file")
                    } else {
                        showSuccessToast("Created file.txt in \(folderURL.path)")
                    }
                } catch {
                    showErrorToast("Failed to create new file")
                }
            }
        }
    ),

    CornerAction(
        id: "20",
        title: "Open Last Download",
        description: "Open the most recently downloaded file.",
        iconName: "arrow.down.doc",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

            do {
                let files = try FileManager.default.contentsOfDirectory(at: downloadsURL, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)

                let sortedFiles = files
                    .compactMap { url -> (url: URL, date: Date)? in
                        let values = try? url.resourceValues(forKeys: [.contentModificationDateKey])
                        return values?.contentModificationDate != nil ? (url, values!.contentModificationDate!) : nil
                    }
                    .sorted { $0.date > $1.date }

                if let mostRecent = sortedFiles.first?.url {
                    NSWorkspace.shared.open(mostRecent)
                    showSuccessToast()
                } else {
                    showErrorToast("No recent downloads found")
                }
            } catch {
                showErrorToast("Failed to open last download")
            }
        }
    ),

    CornerAction(
        id: "21",
        title: "Create Zip Archive",
        description: "Create a zip archive for a specified folder.",
        iconName: "doc.zipper",
        tag: "App Actions",
        requiresInput: true,
        inputPrompt: "Enter Folder Path",
        perform: { input in
            guard let folderPath = input, !folderPath.isEmpty else {
                showErrorToast("Error: Folder path is required")
                return
            }

            let fileManager = FileManager.default
            var isDirectory: ObjCBool = false
            guard fileManager.fileExists(atPath: folderPath, isDirectory: &isDirectory), isDirectory.boolValue else {
                showErrorToast("Error: Folder does not exist")
                return
            }

            let folderURL = URL(fileURLWithPath: folderPath)
            let archiveURL = folderURL.appendingPathExtension("zip")

            let process = Process()
            process.launchPath = "/usr/bin/zip"
            process.currentDirectoryURL = folderURL.deletingLastPathComponent()
            process.arguments = ["-r", archiveURL.lastPathComponent, folderURL.lastPathComponent]

            do {
                try process.run()
                process.waitUntilExit()
                if process.terminationStatus == 0 {
                    showSuccessToast("Zip archive created!")
                } else {
                    showErrorToast("Failed to create zip archive")
                }
            } catch {
                showErrorToast("Error running zip process")
            }
        }
    ),

    CornerAction(
        id: "22",
        title: "Empty Trash",
        description: "Opens Finder and Asks to Empty Trash",
        iconName: "trash",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let finderPath = "/System/Library/CoreServices/Finder.app"
            let url = URL(fileURLWithPath: finderPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Finder").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let deleteKeyCode: CGKeyCode = 51 // Delete key code
                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: deleteKeyCode, keyDown: true)
                    keyDown?.flags = [.maskCommand, .maskShift]
                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: deleteKeyCode, keyDown: false)
                    keyUp?.flags = [.maskCommand, .maskShift]
                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "23",
        title: "Launch Application",
        description: "Opens an app or hides it if already focused.",
        iconName: "square.grid.3x3",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter Application Path",
        perform: { input in
            guard let path = input, !path.isEmpty else {
                showErrorToast("Error: No path provided")
                return
            }

            if let frontApp = NSWorkspace.shared.frontmostApplication,
               frontApp.bundleURL?.path == path
            {
                frontApp.hide()
                showSuccessToast()
            } else {
                NSWorkspace.shared.open(URL(fileURLWithPath: path))
                showSuccessToast()
            }
        }
    ),

    CornerAction(
        id: "24",
        title: "Open a Website",
        description: "Open a website in your default browser.",
        iconName: "globe",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter Website URL",
        perform: { input in
            if let urlStr = input, let url = URL(string: urlStr) {
                NSWorkspace.shared.open(url)
                showSuccessToast()
            } else {
                showErrorToast("Error: Invalid URL")
            }
        }
    ),

    CornerAction(
        id: "25",
        title: "Run Shortcut",
        description: "Run an Apple Shortcut.",
        iconName: "sparkles",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter Shortcut Name",
        perform: { input in
            guard let shortcutName = input, !shortcutName.isEmpty else {
                showErrorToast("Error: No shortcut name provided")
                return
            }

            let task = Process()
            task.launchPath = "/usr/bin/shortcuts"
            task.arguments = ["run", shortcutName]

            let errorPipe = Pipe()
            task.standardError = errorPipe

            do {
                try task.run()
                task.waitUntilExit()

                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                if let errorOutput = String(data: errorData, encoding: .utf8),
                   errorOutput.lowercased().contains("error")
                {
                    showErrorToast("Error: Failed to Run Shortcut")
                } else {
                    showSuccessToast()
                }

            } catch {
                showErrorToast("Error: Failed to Launch Shortcut Process")
            }
        }
    ),

    CornerAction(
        id: "26",
        title: "Simulate Hotkey",
        description: "Simulate a keyboard shortcut",
        iconName: "keyboard",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Record Hotkey",
        perform: { input in
            guard let input = input, !input.isEmpty else {
                showErrorToast("No hotkey name provided")
                return
            }

            let dynamicName = KeyboardShortcuts.Name(input)

            if let shortcutString = KeyboardShortcuts.getShortcut(for: dynamicName) {
                if let parsed = parseShortcutString("\(shortcutString)") {
                    keypress.hotkey(modifiers: parsed.modifiers, key: parsed.key)
                    disableAllShortcuts()
                    showSuccessToast()
                } else {
                    showErrorToast("Failed to parse shortcut")
                    disableAllShortcuts()
                }
            } else {
                showErrorToast("No shortcut set")
            }
        }
    ),

    CornerAction(
        id: "27",
        title: "Open Folder",
        description: "Open a folder in Finder.",
        iconName: "folder.fill",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter Folder Path",
        perform: { input in
            guard let path = input, !path.isEmpty else {
                showErrorToast("Error: No folder path provided")
                return
            }
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "28",
        title: "Open File",
        description: "Open a file in Finder.",
        iconName: "doc",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter File Path",
        perform: { input in
            guard let path = input, !path.isEmpty else {
                showErrorToast("Error: No folder path provided")
                return
            }
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "29",
        title: "Run an Apple Script",
        description: "Run an AppleScript file.",
        iconName: "curlybraces",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter AppleScript Path",
        perform: { input in
            guard let path = input, !path.isEmpty else {
                showErrorToast("Error: No file path provided")
                return
            }

            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = [path]

            let errorPipe = Pipe()
            task.standardError = errorPipe

            do {
                try task.run()
                task.waitUntilExit()

                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                if let errorOutput = String(data: errorData, encoding: .utf8),
                   !errorOutput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                {
                    showErrorToast("AppleScript Error")
                } else {
                    showSuccessToast("")
                }
            } catch {
                showErrorToast("Failed to run AppleScript")
            }
        }
    ),

    CornerAction(
        id: "30",
        title: "Run Terminal Command",
        description: "Run a terminal command.",
        iconName: "terminal",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "",
        perform: { input in
            guard let command = input, !command.isEmpty else {
                showErrorToast("No command entered")
                return
            }

            let process = Process()
            process.launchPath = "/bin/zsh"
            process.arguments = ["-c", command]

            do {
                try process.run()
                showSuccessToast()
            } catch {
                showErrorToast("Failed to run command")
            }
        }
    ),

    CornerAction(
        id: "31",
        title: "Extract Text (OCR)",
        description: "Select a region of the screen to extract text",
        iconName: "text.viewfinder",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("ocr_capture.png")
            let captureTask = Process()
            captureTask.launchPath = "/usr/sbin/screencapture"
            captureTask.arguments = ["-i", tempURL.path]
            captureTask.launch()
            captureTask.waitUntilExit()

            if FileManager.default.fileExists(atPath: tempURL.path),
               let image = NSImage(contentsOfFile: tempURL.path),
               let tiffData = image.tiffRepresentation,
               let ciImage = CIImage(data: tiffData)
            {
                let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
                let request = VNRecognizeTextRequest { request, _ in
                    guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

                    let recognizedText = observations.compactMap {
                        $0.topCandidates(1).first?.string
                    }.joined(separator: "\n")

                    DispatchQueue.main.async {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(recognizedText, forType: .string)

                        TextExtractorManager.shared.addText(recognizedText)
                        showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))

                        if SettingsManager.shared.showRecentText {
                            let extractorPanel = FloatingExtractorPanel()
                            extractorPanel.show()
                        }
                    }
                }

                request.recognitionLevel = .accurate
                try? handler.perform([request])
            } else {
                showErrorToast("Error: No Text was captured.")
            }
        }
    ),

    CornerAction(
        id: "32",
        title: "Color Picker",
        description: "Pick a color and copy its hex code",
        iconName: "eyedropper",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let sampler = NSColorSampler()
            sampler.show { pickedColor in
                guard let color = pickedColor?.usingColorSpace(.displayP3) else {
                    DispatchQueue.main.async {
                        showErrorToast("Error: No color selected")
                    }
                    return
                }

                func formattedColorString(for color: NSColor, format: SettingsView.ColorFormat) -> String {
                    switch format {
                    case .hex:
                        let r = Int(color.redComponent * 255)
                        let g = Int(color.greenComponent * 255)
                        let b = Int(color.blueComponent * 255)
                        return String(format: "#%02X%02X%02X", r, g, b)

                    case .rgb:
                        let r = Int(color.redComponent * 255)
                        let g = Int(color.greenComponent * 255)
                        let b = Int(color.blueComponent * 255)
                        return "rgb(\(r), \(g), \(b))"

                    case .hsl:
                        let hsl = color.usingColorSpace(.deviceRGB)?.hslComponents() ?? (0, 0, 0)
                        return String(format: "hsl(%.0f, %.0f%%, %.0f%%)", hsl.0, hsl.1 * 100, hsl.2 * 100)

                    case .rgba:
                        let r = Int(color.redComponent * 255)
                        let g = Int(color.greenComponent * 255)
                        let b = Int(color.blueComponent * 255)
                        let a = String(format: "%.2f", color.alphaComponent)
                        return "rgba(\(r), \(g), \(b), \(a))"

                    case .hsla:
                        let hsl = color.usingColorSpace(.deviceRGB)?.hslComponents() ?? (0, 0, 0)
                        let a = String(format: "%.2f", color.alphaComponent)
                        return String(format: "hsla(%.0f, %.0f%%, %.0f%%, %@)", hsl.0, hsl.1 * 100, hsl.2 * 100, a)
                    }
                }

                let format = SettingsManager.shared.colorFormat
                let formattedString = formattedColorString(for: color, format: format)

                DispatchQueue.main.async {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(formattedString, forType: .string)

                    ColorHistoryManager.shared.addColor(color)
                    showSuccessToast("Copied \(formattedString) to clipboard", icon: Image(systemName: "eyedropper"))

                    if SettingsManager.shared.showRecentColors {
                        let pickerPanel = FloatingPickerPanel()
                        pickerPanel.show()
                    }
                }
            }
        }
    ),

    CornerAction(
        id: "33",
        title: "Clipboard Text Count",
        description: "Receive count statistics for your last copied text.",
        iconName: "text.magnifyingglass",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let pasteboard = NSPasteboard.general

            guard let text = pasteboard.string(forType: .string), !text.isEmpty else {
                showErrorToast("Clipboard is Empty or Does not Contain Text")
                return
            }

            let words = text.split { !$0.isLetter && !$0.isNumber }
            let wordCount = words.count

            let characterCountNoSpaces = text.filter { !$0.isWhitespace }.count
            let characterCountWithSpaces = text.count

            let paragraphCount = text
                .split(separator: "\n", omittingEmptySubsequences: true)
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                .count

            let sentenceCount = text.split { ".!?".contains($0) }.count

            let readingSpeed = 90.0
            let speakingSpeed = 65.0

            let readingTimeMinutes = Double(wordCount) / readingSpeed
            let speakingTimeMinutes = Double(wordCount) / speakingSpeed

            func formatTime(_ time: Double) -> String {
                let secondsTotal = max(Int((time * 60).rounded()), 1)
                let minutes = secondsTotal / 60
                let seconds = secondsTotal % 60
                return minutes > 0 ? "\(minutes)m \(seconds)s" : "\(seconds)s"
            }

            let readingTimeString = formatTime(readingTimeMinutes)
            let speakingTimeString = formatTime(speakingTimeMinutes)

            let notificationText =
                """
                Words: \(wordCount)
                Sentences: \(sentenceCount)
                Paragraphs: \(paragraphCount)

                Characters (no spaces): \(characterCountNoSpaces)
                Characters (including spaces): \(characterCountWithSpaces)

                Estimated Reading Time: \(readingTimeString)
                Estimated Speaking Time: \(speakingTimeString)
                """

            DispatchQueue.main.async {
                let panel = FloatingPanel(initialMessage: "\n\(notificationText)")
                panel.show()
                showSuccessToast()
            }
        }
    ),

    CornerAction(
        id: "34",
        title: "Emoji & Symbol Viewer",
        description: "Open the Emoji and Symbol viewer.",
        iconName: "smiley.fill",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 49 // Space key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskControl, .maskCommand]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskControl, .maskCommand]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "35",
        title: "Year In Progress",
        description: "Get the current year progress",
        iconName: "clock.arrow.2.circlepath",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let calendar = Calendar.current
            let now = Date()

            guard
                let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now)),
                let endOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: now) + 1))
            else {
                showErrorToast("Failed to calculate year progress")
                return
            }

            let totalDays = calendar.dateComponents([.day], from: startOfYear, to: endOfYear).day ?? 365
            let daysPassed = calendar.dateComponents([.day], from: startOfYear, to: now).day ?? 0

            let percentage = (Double(daysPassed) / Double(totalDays)) * 100
            let formattedPercentage = String(format: "%.1f", percentage)

            showSuccessToast("Year Progress: \(formattedPercentage)% - \(daysPassed) / \(totalDays)", icon: Image(systemName: "clock.fill"))
        }
    ),

    CornerAction(
        id: "36",
        title: "Network Speed Test",
        description: "Run a network speed test.",
        iconName: "gauge",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/bin/env"
            task.arguments = ["bash", "-c", "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"]

            let pipe = Pipe()
            task.standardOutput = pipe

            do {
                try task.run()

                showSuccessToast("Running Speed Test...", icon: Image(systemName: "circle.dotted"))
                task.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? "No output"

                let lines = output.components(separatedBy: "\n")
                var ip = "", isp = "", server = "", ping = "", download = "", upload = ""

                var lastLineWasServer = false

                for line in lines {
                    if line.contains("Testing from") {
                        if let range = line.range(of: #"Testing from (.+?) \((.+?)\)"#, options: .regularExpression) {
                            let match = String(line[range])
                            let parts = match.replacingOccurrences(of: "Testing from ", with: "").dropLast().components(separatedBy: " (")
                            isp = parts.first ?? ""
                            ip = parts.last?.replacingOccurrences(of: ")", with: "") ?? ""
                        }
                    } else if line.contains("Hosted by") {
                        let components = line.components(separatedBy: ":")
                        if components.count == 2 {
                            let full = components[0].replacingOccurrences(of: "Hosted by ", with: "").trimmingCharacters(in: .whitespaces)

                            if let range = full.range(of: #"[\(\[].*"#, options: .regularExpression) {
                                server = String(full[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
                            } else {
                                server = full
                            }

                            ping = components[1].trimmingCharacters(in: .whitespaces)
                        }
                    } else if lastLineWasServer, line.contains("ms"), ping.isEmpty {
                        ping = line.trimmingCharacters(in: .whitespaces)
                        lastLineWasServer = false
                    } else {
                        lastLineWasServer = false
                    }

                    if line.contains("Download:") {
                        download = line.replacingOccurrences(of: "Download: ", with: "").trimmingCharacters(in: .whitespaces)
                    } else if line.contains("Upload:") {
                        upload = line.replacingOccurrences(of: "Upload: ", with: "").trimmingCharacters(in: .whitespaces)
                    }
                }

                let cleanedOutput = """
                Network Speed Test Results

                ISP: \(isp)
                IP: \(ip)
                Server: \(server)
                Ping: \(ping)
                Download: \(download)
                Upload: \(upload)
                """

                let panel = FloatingPanel(initialMessage: cleanedOutput)
                panel.show()
                showSuccessToast("Speed Test Completed")
            } catch {
                showErrorToast("Failed to run speed test")
            }
        }
    ),

    CornerAction(
        id: "37",
        title: "Open Screenshot Utility",
        description: "Launch the macOS Screenshot utility.",
        iconName: "camera.viewfinder",
        tag: "Capture",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Applications/Utilities/Screenshot.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "38",
        title: "Capture Selected Area",
        description: "Captures a custom area of the screen.",
        iconName: "selection.pin.in.out",
        tag: "Capture",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 21

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskShift]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskShift]

            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "39",
        title: "Capture Entire Screen",
        description: "Captures the entire screen.",
        iconName: "rectangle.on.rectangle",
        tag: "Capture",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 20

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskShift]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskShift]

            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "40",
        title: "Previous Track",
        description: "Play previous media track",
        iconName: "backward.fill",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let keyCodePrev = 18

            let eventDown = NSEvent.otherEvent(
                with: .systemDefined,
                location: .zero,
                modifierFlags: NSEvent.ModifierFlags(rawValue: 0xa00),
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: (keyCodePrev << 16) | (0xa << 8),
                data2: -1
            )

            let eventUp = NSEvent.otherEvent(
                with: .systemDefined,
                location: .zero,
                modifierFlags: NSEvent.ModifierFlags(rawValue: 0xb00),
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: (keyCodePrev << 16) | (0xb << 8),
                data2: -1
            )

            eventDown?.cgEvent?.post(tap: .cghidEventTap)
            eventUp?.cgEvent?.post(tap: .cghidEventTap)

            showSuccessToast("Returned to Previous Track", icon: Image(systemName: "backward.fill"))
        }
    ),

    CornerAction(
        id: "41",
        title: "Next Track",
        description: "Play next media track",
        iconName: "forward.fill",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let keyCodeNext = 17

            let eventDown = NSEvent.otherEvent(
                with: .systemDefined,
                location: .zero,
                modifierFlags: NSEvent.ModifierFlags(rawValue: 0xa00),
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: (keyCodeNext << 16) | (0xa << 8),
                data2: -1
            )

            let eventUp = NSEvent.otherEvent(
                with: .systemDefined,
                location: .zero,
                modifierFlags: NSEvent.ModifierFlags(rawValue: 0xb00),
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: (keyCodeNext << 16) | (0xb << 8),
                data2: -1
            )

            eventDown?.cgEvent?.post(tap: .cghidEventTap)
            eventUp?.cgEvent?.post(tap: .cghidEventTap)

            showSuccessToast("Skipped to Next Track", icon: Image(systemName: "forward.fill"))
        }
    ),

    CornerAction(
        id: "42",
        title: "Volume Down",
        description: "Decrease system volume by one step.",
        iconName: "speaker.wave.1.fill",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", "set volume output volume ((output volume of (get volume settings)) - 10) --0% min"]
            try? task.run()

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "43",
        title: "Volume Up",
        description: "Increase system volume by one step.",
        iconName: "speaker.wave.2.fill",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", "set volume output volume ((output volume of (get volume settings)) + 10) --100% max"]
            try? task.run()

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "44",
        title: "Toggle Mute",
        description: "Toggles system volume mute state.",
        iconName: "speaker.slash.circle.fill",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let getTask = Process()
            getTask.launchPath = "/usr/bin/osascript"
            getTask.arguments = ["-e", "output muted of (get volume settings)"]

            let outputPipe = Pipe()
            getTask.standardOutput = outputPipe

            do {
                try getTask.run()
                getTask.waitUntilExit()

                let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                let isMuted = output.lowercased() == "true"

                let toggleTask = Process()
                toggleTask.launchPath = "/usr/bin/osascript"
                toggleTask.arguments = [
                    "-e",
                    isMuted ? "set volume without output muted" : "set volume with output muted",
                ]

                try toggleTask.run()
                toggleTask.waitUntilExit()

                showSuccessToast(isMuted ? "Unmuted Volume" : "Muted Volume")
            } catch {
                showErrorToast("Error: Failed to toggle mute")
            }
        }
    ),

    CornerAction(
        id: "45",
        title: "Set Volume",
        description: "Set system volume to a specific level.",
        iconName: "speaker.wave.2.fill",
        tag: "Media",
        requiresInput: true,
        inputPrompt: "Enter a volume percentage (0–100):",
        perform: { input in
            guard let value = input, let percent = Double(value),
                  percent >= 0, percent <= 100
            else {
                showErrorToast("Invalid volume")
                return
            }

            let volumeValue = percent / 100.0
            let script = "set volume output volume \(Int(percent))"
            let process = Process()
            process.launchPath = "/usr/bin/osascript"
            process.arguments = ["-e", script]

            do {
                try process.run()
                showSuccessToast("Volume set to \(Int(percent))%", icon: Image(systemName: "speaker.wave.2.fill"))
            } catch {
                showErrorToast("Failed to set volume")
            }
        }
    ),

    CornerAction(
        id: "46",
        title: "Maximize Window",
        description: "Expand the active window to fill the desktop.",
        iconName: "rectangle.inset.fill",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeF: CGKeyCode = 3
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeF, keyDown: true)
            keyDown?.flags = [.maskControl, .maskSecondaryFn]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeF, keyDown: false)
            keyUp?.flags = [.maskControl, .maskSecondaryFn]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "47",
        title: "Return to Previous Size",
        description: "Restore the active window to it's previous size",
        iconName: "arrow.uturn.left.circle",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeR: CGKeyCode = 15
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeR, keyDown: true)
            keyDown?.flags = [.maskControl, .maskSecondaryFn]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeR, keyDown: false)
            keyUp?.flags = [.maskControl, .maskSecondaryFn]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "48",
        title: "Center Window",
        description: "Center the active window on the desktop.",
        iconName: "rectangle.center.inset.fill",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeC: CGKeyCode = 8
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeC, keyDown: true)
            keyDown?.flags = [.maskControl, .maskSecondaryFn]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeC, keyDown: false)
            keyUp?.flags = [.maskControl, .maskSecondaryFn]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "49",
        title: "Minimize Window",
        description: "Minimize the active window.",
        iconName: "minus.square.fill",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 46 // M key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "50",
        title: "Minimize All Windows",
        description: "Minimize all windows of the current app.",
        iconName: "rectangle.compress.vertical",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 46 // M key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskAlternate]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskAlternate]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "51",
        title: "Hide App",
        description: "Hide the active app.",
        iconName: "eye.slash.fill",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 4 // H key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "52",
        title: "Hide Other Apps",
        description: "Hide all apps except the active one.",
        iconName: "eye.slash.circle.fill",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 4 // H key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskAlternate]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskAlternate]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "53",
        title: "Reveal Desktop",
        description: "Show the desktop by hiding all windows.",
        iconName: "desktopcomputer",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeH: CGKeyCode = 4 // 'H' key

            if let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeH, keyDown: true),
               let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeH, keyDown: false)
            {
                keyDown.flags = [.maskSecondaryFn] // fn key
                keyUp.flags = [.maskSecondaryFn]
                keyDown.post(tap: .cghidEventTap)
                keyUp.post(tap: .cghidEventTap)

                showSuccessToast()
            }
        }
    ),

    CornerAction(
        id: "54",
        title: "Previous Desktop",
        description: "Switch to the previous desktop.",
        iconName: "arrow.left.square",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let script = """
                tell application "System Events"
                    key code 123 using control down -- Left Arrow
                end tell
                """
                let task = Process()
                task.launchPath = "/usr/bin/osascript"
                task.arguments = ["-e", script]

                do {
                    try task.run()
                    task.waitUntilExit()
                    showSuccessToast()
                } catch {
                    showErrorToast("Failed to switch desktop")
                }
            }
        }
    ),

    CornerAction(
        id: "55",
        title: "Next Desktop",
        description: "Switch to the next desktop.",
        iconName: "arrow.right.square",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let script = """
                tell application "System Events"
                    key code 124 using control down -- Right Arrow
                end tell
                """
                let task = Process()
                task.launchPath = "/usr/bin/osascript"
                task.arguments = ["-e", script]

                do {
                    try task.run()
                    task.waitUntilExit()
                    showSuccessToast()
                } catch {
                    showErrorToast("Failed to switch desktop")
                }
            }
        }
    ),

    CornerAction(
        id: "56",
        title: "Toggle Media Playback",
        description: "Toggle Media Playback",
        iconName: "playpause",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let keyCodePlayPause = 16

            let eventDown = NSEvent.otherEvent(
                with: .systemDefined,
                location: .zero,
                modifierFlags: NSEvent.ModifierFlags(rawValue: 0xa00),
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: (keyCodePlayPause << 16) | (0xa << 8),
                data2: -1
            )

            let eventUp = NSEvent.otherEvent(
                with: .systemDefined,
                location: .zero,
                modifierFlags: NSEvent.ModifierFlags(rawValue: 0xb00),
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 8,
                data1: (keyCodePlayPause << 16) | (0xb << 8),
                data2: -1
            )

            eventDown?.cgEvent?.post(tap: .cghidEventTap)
            eventUp?.cgEvent?.post(tap: .cghidEventTap)

            showSuccessToast("Toggled Playback", icon: Image(systemName: "playpause"))
        }
    ),

    CornerAction(
        id: "57",
        title: "Copy Last Download Path",
        description: "Copy the path to your most recent download.",
        iconName: "doc.on.clipboard",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!

            do {
                let files = try FileManager.default.contentsOfDirectory(at: downloadsURL, includingPropertiesForKeys: [.contentModificationDateKey], options: .skipsHiddenFiles)

                let sortedFiles = files
                    .compactMap { url -> (url: URL, date: Date)? in
                        let values = try? url.resourceValues(forKeys: [.contentModificationDateKey])
                        return values?.contentModificationDate != nil ? (url, values!.contentModificationDate!) : nil
                    }
                    .sorted { $0.date > $1.date }

                if let mostRecent = sortedFiles.first?.url {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(mostRecent.path, forType: .string)
                    showSuccessToast()
                } else {
                    showErrorToast("No recent downloads found")
                }
            } catch {
                showErrorToast("Failed to copy path")
            }
        }
    ),

    CornerAction(
        id: "58",
        title: "Do Nothing",
        description: "Blank action that does nothing",
        iconName: "nosign",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
        }
    ),

    CornerAction(
        id: "59",
        title: "Open Reader Mode",
        description: "Toggle Reader Mode in Safari.",
        iconName: "book",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let appPath = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
            let url = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.safari").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeR: CGKeyCode = 15

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeR, keyDown: true)
                    keyDown?.flags = [.maskCommand, .maskShift]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeR, keyDown: false)
                    keyUp?.flags = [.maskCommand, .maskShift]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "60",
        title: "Compose New Message",
        description: "Compose a new message in Messages",
        iconName: "message",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let appPath = "/System/Applications/Messages.app"
            let url = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Notes").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeN: CGKeyCode = 45

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                    keyDown?.flags = [.maskCommand]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                    keyUp?.flags = [.maskCommand]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)

                    showSuccessToast()
                }
            }
        }
    ),

    CornerAction(
        id: "61",
        title: "New Window",
        description: "Open a new window for the focused app",
        iconName: "macwindow.on.rectangle",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeN: CGKeyCode = 45
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
            keyDown?.flags = [.maskCommand]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
            keyUp?.flags = [.maskCommand]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "62",
        title: "Close Window",
        description: "Close a window for the focused app",
        iconName: "macwindow.and.cursorarrow",
        tag: "Window Management",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeW: CGKeyCode = 13
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeW, keyDown: true)
            keyDown?.flags = [.maskCommand]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeW, keyDown: false)
            keyUp?.flags = [.maskCommand]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),
]
