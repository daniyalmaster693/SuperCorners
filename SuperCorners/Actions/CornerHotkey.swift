//
//  CornerHotkey.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import KeyboardShortcuts
import SwiftUI

var localCornerMonitor: Any?
var globalCornerMonitor: Any?

func activateCornerHotkey() {
    // Activation Using Modifier Key

    var modifierKeyPressed = false

    NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
        let modifierPressed = event.modifierFlags.contains(.command)

        if modifierPressed, !modifierKeyPressed {
            modifierKeyPressed = true
            localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                getCornerMousePosition()
                return event
            }

            globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
                getCornerMousePosition()
            }
        } else if !modifierPressed, modifierKeyPressed {
            modifierKeyPressed = false
            if let local = localCornerMonitor {
                NSEvent.removeMonitor(local)
                localCornerMonitor = nil
            }

            if let global = globalCornerMonitor {
                NSEvent.removeMonitor(global)
                globalCornerMonitor = nil
            }
        }
        return event
    }

    // Activation Using Keyboard Shortcut

    if KeyboardShortcuts.Name.cornerActivation.shortcut == nil {
        KeyboardShortcuts.setShortcut(.init(.space, modifiers: [.control, .shift]), for: .cornerActivation)
    }

    KeyboardShortcuts.onKeyDown(for: .cornerActivation) {
        localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            getCornerMousePosition()
            return event
        }

        globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            getCornerMousePosition()
        }
    }

    KeyboardShortcuts.onKeyUp(for: .cornerActivation) {
        if let local = localCornerMonitor {
            NSEvent.removeMonitor(local)
            localCornerMonitor = nil
        }

        if let global = globalCornerMonitor {
            NSEvent.removeMonitor(global)
            globalCornerMonitor = nil
        }
    }
}
