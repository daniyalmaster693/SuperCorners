//
//  ActionsLibrary.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI
import Vision

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
        title: "Open Last File in Folder",
        description: "Opens the newest file in a folder you specify.",
        iconName: "folder",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter Folder Path",
        perform: { input in
            guard let folderPath = input, !folderPath.isEmpty else {
                showErrorToast("Please enter a valid folder path")
                return
            }

            let folderURL = URL(fileURLWithPath: folderPath)
            let fileManager = FileManager.default

            guard let files = try? fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.creationDateKey], options: [.skipsHiddenFiles]) else {
                showErrorToast("Error: Could not access folder")
                return
            }

            let sortedFiles = files.sorted {
                let date1 = (try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                let date2 = (try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                return date1 > date2
            }

            if let latestFile = sortedFiles.first {
                NSWorkspace.shared.open(latestFile)
                showSuccessToast()
            } else {
                showErrorToast("Error: No files found in folder")
            }
        }
    ),

    CornerAction(
        id: "4",
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
        id: "5",
        title: "Launch an Application",
        description: "Launch an application.",
        iconName: "square.grid.3x3",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter Application Path",
        perform: { input in
            guard let path = input, !path.isEmpty else {
                showErrorToast("Error: No path provided")
                return
            }
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "6",
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
        id: "7",
        title: "Open a Folder",
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
        id: "8",
        title: "Open Launchpad",
        description: "Open the Launchpad to see your apps.",
        iconName: "square.grid.2x2",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Applications/Launchpad.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "9",
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
        id: "10",
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
        id: "11",
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
        id: "12",
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
        id: "13",
        title: "Start Screen Recording",
        description: "Open QuickTime screen recording window.",
        iconName: "video.fill",
        tag: "Capture",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let quickTimePath = "/System/Applications/QuickTime Player.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: quickTimePath))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let src = CGEventSource(stateID: .hidSystemState)
                let keyCodeN: CGKeyCode = 45
                let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                keyDown?.flags = [.maskCommand, .maskControl]
                let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                keyUp?.flags = [.maskCommand, .maskControl]
                keyDown?.post(tap: .cghidEventTap)
                keyUp?.post(tap: .cghidEventTap)
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "14",
        title: "Start Movie Recording",
        description: "Open QuickTime movie recording window.",
        iconName: "film.fill",
        tag: "Capture",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let quickTimePath = "/System/Applications/QuickTime Player.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: quickTimePath))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let src = CGEventSource(stateID: .hidSystemState)
                let keyCodeN: CGKeyCode = 45
                let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: true)
                keyDown?.flags = [.maskCommand, .maskAlternate]
                let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeN, keyDown: false)
                keyUp?.flags = [.maskCommand, .maskAlternate]
                keyDown?.post(tap: .cghidEventTap)
                keyUp?.post(tap: .cghidEventTap)
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "15",
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
        id: "16",
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
        id: "17",
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
        id: "18",
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
        id: "19",
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
        id: "20",
        title: "Open Camera",
        description: "Launch the Camera (Photo Booth) app.",
        iconName: "camera.fill",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Applications/Photo Booth.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "21",
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
        id: "22",
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
        id: "23",
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
        id: "24",
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
        id: "25",
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
        id: "26",
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
        id: "27",
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
        id: "28",
        title: "Open AirDrop",
        description: "Open AirDrop in Finder.",
        iconName: "square.and.arrow.up",
        tag: "System",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let path = "/System/Library/CoreServices/Finder.app/Contents/Applications/AirDrop.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "29",
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
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "30",
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
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "31",
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
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "32",
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
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "33",
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
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "34",
        title: "Take a Photo",
        description: "Take a photo in PhotoBooth",
        iconName: "photo",
        tag: "App Actions",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let appPath = "/System/Applications/Photo Booth.app"
            let url = URL(fileURLWithPath: appPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.photobooth").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeReturn: CGKeyCode = 36 // Enter/Return key

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeReturn, keyDown: true)
                    keyDown?.flags = [.maskCommand]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeReturn, keyDown: false)
                    keyUp?.flags = [.maskCommand]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "35",
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
        id: "36",
        title: "Play/Pause Apple Music",
        description: "Opens Msuic and toggles Playback",
        iconName: "playpause",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let musicAppPath = "/System/Applications/Music.app"
            let url = URL(fileURLWithPath: musicAppPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let spaceKey: CGKeyCode = 49 // spacebar

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: spaceKey, keyDown: true)
                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: spaceKey, keyDown: false)

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "37",
        title: "Stop Playback Apple Music",
        description: "Stops Playback in Apple Music",
        iconName: "play.slash",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let musicAppPath = "/System/Applications/Music.app"
            let url = URL(fileURLWithPath: musicAppPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let periodKeyCode: CGKeyCode = 47 // '.' key

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: periodKeyCode, keyDown: true)
                    keyDown?.flags = .maskCommand

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: periodKeyCode, keyDown: false)
                    keyUp?.flags = .maskCommand

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "38",
        title: "Go to Current Song",
        description: "Opens album for currently playing song in Apple Music",
        iconName: "cursorarrow.click",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let musicAppPath = "/System/Applications/Music.app"
            let url = URL(fileURLWithPath: musicAppPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let lKeyCode: CGKeyCode = 37 // 'L' key

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: true)
                    keyDown?.flags = .maskCommand

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: false)
                    keyUp?.flags = .maskCommand

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "39",
        title: "Open Visualizer",
        description: "Opens Visualizer in Apple Music",
        iconName: "waveform.path",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let musicAppPath = "/System/Applications/Music.app"
            let url = URL(fileURLWithPath: musicAppPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let lKeyCode: CGKeyCode = 17

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: true)
                    keyDown?.flags = .maskCommand

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: false)
                    keyUp?.flags = .maskCommand

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "40",
        title: "Open Miniplayer",
        description: "Opens Miniplayer in Apple Music",
        iconName: "rectangle.inset.bottomleading.filled",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let musicAppPath = "/System/Applications/Music.app"
            let url = URL(fileURLWithPath: musicAppPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let lKeyCode: CGKeyCode = 46

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: true)
                    keyDown?.flags = [.maskCommand, .maskAlternate]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: false)
                    keyUp?.flags = [.maskCommand, .maskAlternate]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "41",
        title: "Open Fullscreen Player",
        description: "Opens Fullscreen Player in Apple Music",
        iconName: "arrow.up.left.and.arrow.down.right",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let musicAppPath = "/System/Applications/Music.app"
            let url = URL(fileURLWithPath: musicAppPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let lKeyCode: CGKeyCode = 3

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: true)
                    keyDown?.flags = [.maskCommand, .maskShift]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: false)
                    keyUp?.flags = [.maskCommand, .maskShift]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "42",
        title: "Open Equalizer",
        description: "Opens Equalizer in Apple Music",
        iconName: "slider.horizontal.3",
        tag: "Media",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let musicAppPath = "/System/Applications/Music.app"
            let url = URL(fileURLWithPath: musicAppPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let lKeyCode: CGKeyCode = 14

                    let keyDown = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: true)
                    keyDown?.flags = [.maskCommand, .maskAlternate]

                    let keyUp = CGEvent(keyboardEventSource: src, virtualKey: lKeyCode, keyDown: false)
                    keyUp?.flags = [.maskCommand, .maskAlternate]

                    keyDown?.post(tap: .cghidEventTap)
                    keyUp?.post(tap: .cghidEventTap)
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "43",
        title: "Empty Trash",
        description: "Opens Finder and Asks to Empty Trash",
        iconName: "trash",
        tag: "Finder",
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
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "44",
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

                let red = Int(color.redComponent * 255)
                let green = Int(color.greenComponent * 255)
                let blue = Int(color.blueComponent * 255)
                let hexString = String(format: "#%02X%02X%02X", red, green, blue)

                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(hexString, forType: .string)

                DispatchQueue.main.async {
                    let toast = ToastWindowController()
                    toast.showToast(message: "Copied \(hexString) to clipboard", icon: Image(systemName: "eyedropper"))
                }
            }
        }
    ),

    CornerAction(
        id: "45",
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
                        showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
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
        id: "46",
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

                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(notificationText, forType: .string)
                showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))

                panel.show()
            }
        }
    ),

    CornerAction(
        id: "47",
        title: "Open Font Panel",
        description: "Opens the macOS font panel to preview fonts",
        iconName: "character.circle",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            NSFontPanel.shared.makeKeyAndOrderFront(nil)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "48",
        title: "Zoom In",
        description: "Trigger the Zoom In Keyboard Shortcut.",
        iconName: "plus.magnifyingglass",
        tag: "Accessibility",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeEqual: CGKeyCode = 24 // '=' key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeEqual, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskAlternate]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeEqual, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskAlternate]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "49",
        title: "Zoom Out",
        description: "Trigger the Zoom Out keyboard shortcut.",
        iconName: "minus.magnifyingglass",
        tag: "Accessibility",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeMinus: CGKeyCode = 27 // '-' key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeMinus, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskAlternate]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeMinus, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskAlternate]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "50",
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
        id: "51",
        title: "Run an Apple Script",
        description: "Run an AppleScript file.",
        iconName: "curlybraces",
        tag: "Template Action",
        requiresInput: true,
        inputPrompt: "Enter File Path",
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
        id: "52",
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
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "53",
        title: "Toggle Hidden Files",
        description: "Show or hide hidden files in Finder.",
        iconName: "doc",
        tag: "Finder",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodePeriod: CGKeyCode = 47 // '.' key

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodePeriod, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskShift]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodePeriod, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskShift]

            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "54",
        title: "Create New Folder",
        description: "Creates a new folder in Finder.",
        iconName: "folder.badge.plus",
        tag: "Finder",
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
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "55",
        title: "Create New File",
        description: "Creates a new file in a user selected folder.",
        iconName: "doc.text",
        tag: "Finder",
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
        id: "56",
        title: "Open Go To Folder",
        description: "Open the Go To Folder dialog in Finder.",
        iconName: "folder",
        tag: "Finder",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let finderPath = "/System/Library/CoreServices/Finder.app"
            let url = URL(fileURLWithPath: finderPath)
            NSWorkspace.shared.openApplication(at: url, configuration: NSWorkspace.OpenConfiguration(), completionHandler: nil)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Finder").first?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let src = CGEventSource(stateID: .hidSystemState)
                    let keyCodeG: CGKeyCode = 5 // 'G' key

                    if let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeG, keyDown: true),
                       let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeG, keyDown: false)
                    {
                        keyDown.flags = [.maskCommand, .maskShift]
                        keyUp.flags = [.maskCommand, .maskShift]

                        keyDown.post(tap: .cghidEventTap)
                        keyUp.post(tap: .cghidEventTap)
                    }
                }
            }

            showSuccessToast()
        }
    ),

    CornerAction(
        id: "57",
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
        id: "58",
        title: "Show Battery Info",
        description: "Display detailed battery status and health.",
        iconName: "battery.100",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/sbin/system_profiler"
            task.arguments = ["SPPowerDataType"]

            let pipe = Pipe()
            task.standardOutput = pipe

            do {
                try task.run()
                task.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let batteryInfo = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        let panel = FloatingPanel(initialMessage: "Battery Info:\n\(batteryInfo)")
                        panel.show()

                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(batteryInfo, forType: .string)
                        showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
                    }
                }
            } catch {
                showErrorToast("Failed to get Battery Info")
            }
        }
    ),

    CornerAction(
        id: "59",
        title: "Show System Uptime",
        description: "Display how long your Mac has been running.",
        iconName: "timer",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/bin/uptime"

            let pipe = Pipe()
            task.standardOutput = pipe

            do {
                try task.run()
                task.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let uptime = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    DispatchQueue.main.async {
                        let panel = FloatingPanel(initialMessage: "System Uptime:\n\(uptime)")
                        panel.show()

                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(uptime, forType: .string)
                        showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
                    }
                }
            } catch {
                showErrorToast("Failed to Get System Uptime")
            }
        }
    ),

    CornerAction(
        id: "60",
        title: "Show System Information",
        description: "Displays information about your Mac",
        iconName: "desktopcomputer",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let info = ProcessInfo.processInfo
            let hostname = info.hostName
            let osVersion = info.operatingSystemVersion
            let osVersionString = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
            let cpuCount = info.processorCount
            let memoryGB = Double(info.physicalMemory) / 1024 / 1024 / 1024
            var lowPowerModeStatus = "Unknown"
            if #available(macOS 12.0, *) {
                lowPowerModeStatus = info.isLowPowerModeEnabled ? "Enabled" : "Disabled"
            }

            let systemInfo = """
            Hostname: \(hostname)
            OS Version: macOS \(osVersionString)
            CPU Cores: \(cpuCount)
            RAM: \(String(format: "%.2f", memoryGB)) GB
            Low Power Mode: \(lowPowerModeStatus)
            """

            DispatchQueue.main.async {
                let panel = FloatingPanel(initialMessage: systemInfo)
                panel.show()

                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(systemInfo, forType: .string)
                showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
            }
        }
    ),

    CornerAction(
        id: "61",
        title: "Floating Note Window",
        description: "Opens a floating note window",
        iconName: "note",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let notePanel = FloatingNotePanel()
            notePanel.show()
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "62",
        title: "Get App Info",
        description: "Get info about the currently running app.",
        iconName: "i.circle",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            if let app = NSWorkspace.shared.frontmostApplication,
               let bundleURL = app.bundleURL,
               let bundle = Bundle(url: bundleURL)
            {
                let appName = app.localizedName ?? "Unknown"
                let bundleID = app.bundleIdentifier ?? "Unknown"
                let version = bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
                let build = bundle.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
                let path = bundleURL.path

                let infoText = """
                App Name: \(appName)
                Bundle ID: \(bundleID)
                Version: \(version) (Build \(build))
                Path: \(path)
                """

                DispatchQueue.main.async {
                    let panel = FloatingPanel(initialMessage: infoText)
                    panel.show()

                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(infoText, forType: .string)
                    showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
                }
            } else {
                DispatchQueue.main.async {
                    let toast = ToastWindowController()
                    showErrorToast("Failed to get app info")
                }
            }
        }
    ),

    CornerAction(
        id: "63",
        title: "Restart Dock",
        description: "Restarts the macOS Dock process.",
        iconName: "rectangle.dock",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: nil,
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/bin/killall"
            task.arguments = ["Dock"]

            do {
                try task.run()
                task.waitUntilExit()
                showSuccessToast()
            } catch {
                showErrorToast("Failed to restart Dock")
            }
        }
    ),

    CornerAction(
        id: "64",
        title: "NL Calculator",
        description: "Perform Calcuations using Natural Language",
        iconName: "captions.bubble",
        tag: "Tool",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let calculatorPanel = FloatingCalculatorPanel()
            calculatorPanel.show()
            showSuccessToast()
        }
    ),

    CornerAction(
        id: "65",
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
        id: "66",
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
        id: "67",
        title: "List Network Services",
        description: "Shows the system's network service order",
        iconName: "list.bullet.rectangle",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/sbin/networksetup"
            task.arguments = ["-listnetworkserviceorder"]

            let outputPipe = Pipe()
            task.standardOutput = outputPipe

            do {
                try task.run()
                task.waitUntilExit()

                let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? "No output"

                DispatchQueue.main.async {
                    let panel = FloatingPanel(initialMessage: output)
                    panel.show()

                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(output, forType: .string)
                    showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
                }
            } catch {
                showErrorToast("Failed to list network services")
            }
        }
    ),

    CornerAction(
        id: "68",
        title: "Get DNS Server",
        description: "Displays current DNS servers for Wi-Fi",
        iconName: "globe",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/sbin/networksetup"
            task.arguments = ["-getdnsservers", "Wi-Fi"]

            let outputPipe = Pipe()
            task.standardOutput = outputPipe

            do {
                try task.run()
                task.waitUntilExit()

                let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? "No output"

                DispatchQueue.main.async {
                    let panel = FloatingPanel(initialMessage: output)
                    panel.show()

                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(output, forType: .string)
                    showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
                }
            } catch {
                showErrorToast("Failed to get DNS")
            }
        }
    ),

    CornerAction(
        id: "69",
        title: "Get Web Proxy",
        description: "Displays current web proxy settings for Wi-Fi",
        iconName: "network",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let task = Process()
            task.launchPath = "/usr/sbin/networksetup"
            task.arguments = ["-getwebproxy", "Wi-Fi"]

            let outputPipe = Pipe()
            task.standardOutput = outputPipe

            do {
                try task.run()
                task.waitUntilExit()

                let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? "No output"

                DispatchQueue.main.async {
                    let panel = FloatingPanel(initialMessage: output)
                    panel.show()

                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(output, forType: .string)
                    showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
                }
            } catch {
                showErrorToast("Failed to get web proxy status")
            }
        }
    ),

    CornerAction(
        id: "70",
        title: "Toggle Web Proxy",
        description: "Toggles the web proxy on or off",
        iconName: "network.badge.shield.half.filled",
        tag: "Developer",
        requiresInput: false,
        inputPrompt: "",
        perform: { _ in
            let statusTask = Process()
            statusTask.launchPath = "/usr/sbin/networksetup"
            statusTask.arguments = ["-getwebproxy", "Wi-Fi"]

            let statusPipe = Pipe()
            statusTask.standardOutput = statusPipe

            do {
                try statusTask.run()
                statusTask.waitUntilExit()

                let data = statusPipe.fileHandleForReading.readDataToEndOfFile()
                guard let output = String(data: data, encoding: .utf8) else {
                    showErrorToast("Could not read web proxy status")
                    return
                }

                let isEnabled = output.contains("Enabled: Yes")
                let newState = isEnabled ? "off" : "on"
                let toggleTask = Process()
                toggleTask.launchPath = "/usr/sbin/networksetup"
                toggleTask.arguments = ["-setwebproxystate", "Wi-Fi", newState]

                let errorPipe = Pipe()
                toggleTask.standardError = errorPipe

                try toggleTask.run()
                toggleTask.waitUntilExit()

                let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                let errorOutput = String(data: errorData, encoding: .utf8) ?? ""

                if !errorOutput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showErrorToast("Failed to toggle Web Proxy")
                } else {
                    showSuccessToast("Web Proxy turned \(newState.uppercased())")
                }

            } catch {
                showErrorToast("Failed to toggle Web Proxy")
            }
        }
    ),
]
