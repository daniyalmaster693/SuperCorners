//
//  CornerHotkey.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import KeyboardShortcuts
import SwiftUI

var localMonitor: Any?
var globalMonitor: Any?

func activateCornerHotkey() {
    KeyboardShortcuts.setShortcut(.init(.c, modifiers: [.command, .option]), for: .cornerActivation)

    KeyboardShortcuts.onKeyDown(for: .cornerActivation) {
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            getMousePosition()
            return event
        }

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            getMousePosition()
        }
    }

    KeyboardShortcuts.onKeyUp(for: .cornerActivation) {
        if let local = localMonitor {
            NSEvent.removeMonitor(local)
            localMonitor = nil
        }

        if let global = globalMonitor {
            NSEvent.removeMonitor(global)
            globalMonitor = nil
        }
    }
}
