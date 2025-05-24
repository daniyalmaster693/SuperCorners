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
]
