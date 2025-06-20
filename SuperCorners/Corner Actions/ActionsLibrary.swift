//
//  ActionsLibrary.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct CornerAction: Identifiable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let tag: String
    let perform: () -> Void
}

let cornerActions: [CornerAction] = [
    CornerAction(
        id: "0",
        title: "Start Screen Saver",
        description: "Activate the screen saver",
        iconName: "display",
        tag: "System",
        perform: {
            let path = "/System/Library/CoreServices/ScreenSaverEngine.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),

    CornerAction(
        id: "1",
        title: "Put Display to Sleep",
        description: "Sleep your Mac",
        iconName: "moon.fill",
        tag: "System",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/pmset"
            task.arguments = ["displaysleepnow"]
            try? task.run()
        }
    ),

    CornerAction(
        id: "2",
        title: "Lock Screen",
        description: "Locks your Mac and returns to the login screen.",
        iconName: "lock.fill",
        tag: "System",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: 12, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskControl]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: 12, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskControl]

            let loc = CGEventTapLocation.cghidEventTap
            keyDown?.post(tap: loc)
            keyUp?.post(tap: loc)
        }
    ),

    CornerAction(
        id: "3",
        title: "Trigger Hotkey",
        description: "Simulate a custom hotkey press.",
        iconName: "keyboard",
        tag: "Template Action",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeO: CGKeyCode = 31

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeO, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskShift]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeO, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskShift]

            let loc = CGEventTapLocation.cghidEventTap
            keyDown?.post(tap: loc)
            keyUp?.post(tap: loc)
        }
    ),

    CornerAction(
        id: "4",
        title: "Open a Website",
        description: "Open a website in your default browser.",
        iconName: "globe",
        tag: "Template Action",
        perform: {
            if let url = URL(string: "https://apple.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),

    CornerAction(
        id: "5",
        title: "Launch an Application",
        description: "Launch an application.",
        iconName: "square.grid.3x3",
        tag: "Template Action",
        perform: {
            let path = "/System/Applications/Safari.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),

    CornerAction(
        id: "6",
        title: "Run Shortcut",
        description: "Run an Apple Shortcut.",
        iconName: "sparkles",
        tag: "Template Action",
        perform: {
            let shortcutName = "Start Pomodoro"

            let task = Process()
            task.launchPath = "/usr/bin/shortcuts"
            task.arguments = ["run", shortcutName]

            do {
                try task.run()
            } catch {
                print("❌ Failed to run shortcut: \(error)")
            }
        }
    ),

    CornerAction(
        id: "7",
        title: "Open a Folder",
        description: "Open a folder in Finder.",
        iconName: "folder.fill",
        tag: "Template Action",
        perform: {
            let path = "/Applications"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),

    CornerAction(
        id: "8",
        title: "Open Launchpad",
        description: "Open the Launchpad to see your apps.",
        iconName: "square.grid.2x2",
        tag: "System",
        perform: {
            let path = "/System/Applications/Launchpad.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),

    CornerAction(
        id: "9",
        title: "Show Mission Control",
        description: "Display all open windows and spaces.",
        iconName: "rectangle.stack.fill",
        tag: "System",
        perform: {
            let path = "/System/Applications/Mission Control.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),

    CornerAction(
        id: "10",
        title: "Open Screenshot Utility",
        description: "Launch the macOS Screenshot utility.",
        iconName: "camera.viewfinder",
        tag: "Capture",
        perform: {
            let path = "/System/Applications/Utilities/Screenshot.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),

    CornerAction(
        id: "11",
        title: "Capture Entire Screen",
        description: "Captures the entire screen.",
        iconName: "rectangle.on.rectangle",
        tag: "Capture",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 20

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskShift]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskShift]

            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        }
    ),

    CornerAction(
        id: "12",
        title: "Capture Selected Area",
        description: "Captures a custom area of the screen.",
        iconName: "selection.pin.in.out",
        tag: "Capture",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 21

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskShift]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskShift]

            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        }
    ),

    CornerAction(
        id: "13",
        title: "Start Screen Recording",
        description: "Open QuickTime screen recording window.",
        iconName: "video.fill",
        tag: "Capture",
        perform: {
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
        }
    ),

    CornerAction(
        id: "14",
        title: "Start Movie Recording",
        description: "Open QuickTime movie recording window.",
        iconName: "film.fill",
        tag: "Capture",
        perform: {
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
        }
    ),

    CornerAction(
        id: "15",
        title: "Volume Up",
        description: "Increase system volume by one step.",
        iconName: "speaker.wave.2.fill",
        tag: "Media",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", "set volume output volume ((output volume of (get volume settings)) + 10) --100% max"]
            try? task.run()
        }
    ),

    CornerAction(
        id: "16",
        title: "Volume Down",
        description: "Decrease system volume by one step.",
        iconName: "speaker.wave.1.fill",
        tag: "Media",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", "set volume output volume ((output volume of (get volume settings)) - 10) --0% min"]
            try? task.run()
        }
    ),

    CornerAction(
        id: "17",
        title: "Unmute Volume",
        description: "Unmute system volume.",
        iconName: "speaker.wave.2.fill",
        tag: "Media",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", "set volume without output muted"]
            try? task.run()
        }
    ),

    CornerAction(
        id: "18",
        title: "Mute Volume",
        description: "Mute system volume.",
        iconName: "speaker.slash.fill",
        tag: "Media",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", "set volume with output muted"]
            try? task.run()
        }
    ),

    CornerAction(
        id: "19",
        title: "Emoji & Symbol Viewer",
        description: "Open the Emoji and Symbol viewer.",
        iconName: "smiley.fill",
        tag: "System",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCode: CGKeyCode = 49 // Space key
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
            keyDown?.flags = [.maskControl, .maskCommand]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
            keyUp?.flags = [.maskControl, .maskCommand]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        }
    ),

    CornerAction(
        id: "20",
        title: "Open Camera",
        description: "Launch the Camera (Photo Booth) app.",
        iconName: "camera.fill",
        tag: "System",
        perform: {
            let path = "/System/Applications/Photo Booth.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),

    CornerAction(
        id: "21",
        title: "Maximize Window",
        description: "Expand active window to fill desktop.",
        iconName: "arrow.up.left.and.arrow.down.right.square",
        tag: "Window Management",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeF: CGKeyCode = 3
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeF, keyDown: true)
            keyDown?.flags = [.maskControl, .maskSecondaryFn]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeF, keyDown: false)
            keyUp?.flags = [.maskControl, .maskSecondaryFn]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        }
    ),

    CornerAction(
        id: "22",
        title: "Return to Previous Size",
        description: "Restore window to its previous size before tiling.",
        iconName: "arrow.uturn.left.circle",
        tag: "Window Management",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeR: CGKeyCode = 15
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeR, keyDown: true)
            keyDown?.flags = [.maskControl, .maskSecondaryFn]
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeR, keyDown: false)
            keyUp?.flags = [.maskControl, .maskSecondaryFn]
            keyDown?.post(tap: .cghidEventTap)
            keyUp?.post(tap: .cghidEventTap)
        }
    ),
]
