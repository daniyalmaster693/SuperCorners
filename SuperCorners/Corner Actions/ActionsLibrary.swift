//
//  ActionsLibrary.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct CornerAction: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let perform: () -> Void
}

let cornerActions: [CornerAction] = [
    CornerAction(
        title: "Start Screen Saver",
        description: "Activate the screen saver",
        iconName: "display",
        perform: {
            let path = "/System/Library/CoreServices/ScreenSaverEngine.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Trigger Hotkey",
        description: "Simulate a custom hotkey press.",
        iconName: "keyboard",
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
        title: "Put Display to Sleep",
        description: "Sleep your Mac",
        iconName: "moon.fill",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/pmset"
            task.arguments = ["displaysleepnow"]
            try? task.run()
        }
    ),
    
    CornerAction(
        title: "Open Website",
        description: "Launch a website in your default browser.",
        iconName: "safari",
        perform: {
            if let url = URL(string: "https://apple.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        title: "Open Apple Music",
        description: "Open the Apple Music application.",
        iconName: "music.note",
        perform: {
            let path = "/System/Applications/Music.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Clock",
        description: "Open the Clock application.",
        iconName: "clock",
        perform: {
            let path = "/System/Applications/Clock.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Calculator",
        description: "Open the Calculator application.",
        iconName: "plus.slash.minus",
        perform: {
            let path = "/System/Applications/Calculator.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Reminders",
        description: "Open the Reminders application.",
        iconName: "list.bullet",
        perform: {
            let path = "/System/Applications/Reminders.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Safari",
        description: "Open the Safari web browser.",
        iconName: "safari",
        perform: {
            let path = "/System/Applications/Safari.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Finder",
        description: "Open a new Finder window.",
        iconName: "folder",
        perform: {
            let path = "/System/Library/CoreServices/Finder.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Terminal",
        description: "Open the Terminal application.",
        iconName: "terminal",
        perform: {
            let path = "/System/Applications/Utilities/Terminal.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Calendar",
        description: "Open the Calendar application.",
        iconName: "calendar",
        perform: {
            let path = "/System/Applications/Calendar.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Messages",
        description: "Open the Messages application.",
        iconName: "message",
        perform: {
            let path = "/System/Applications/Messages.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open Mail",
        description: "Open the Mail application.",
        iconName: "envelope",
        perform: {
            let path = "/System/Applications/Mail.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Open iPhone Mirroring",
        description: "Open the iPhone Mirroring feature.",
        iconName: "iphone",
        perform: {
            let path = "/System/Applications/Phone Mirroring.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
]
