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
    let iconName: String
    let perform: () -> Void
}

let availableCornerActions: [CornerAction] = [
    CornerAction(
        title: "Start Screen Saver",
        iconName: "playpause",
        perform: {
            let path = "/System/Library/CoreServices/ScreenSaverEngine.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        title: "Trigger Hotkey",
        iconName: "playpause",
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
        iconName: "display",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/pmset"
            task.arguments = ["displaysleepnow"]
            try? task.run()
        }
    ),
    
    CornerAction(
        title: "Open Website",
        iconName: "globe",
        perform: {
            if let url = URL(string: "https://apple.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        title: "Open Apple Music",
        iconName: "music",
        perform: {
            let path = "/System/Applications/Music.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
]
