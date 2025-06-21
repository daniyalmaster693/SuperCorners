//
//  ZoneHotkey.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import KeyboardShortcuts
import SwiftUI

func activateZoneHotkey() {
    KeyboardShortcuts.setShortcut(.init(.z, modifiers: [.command, .option]), for: .zoneActivation)

    KeyboardShortcuts.onKeyDown(for: .zoneActivation) {
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            getZoneMousePosition()
            return event
        }

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            getZoneMousePosition()
        }
    }

    KeyboardShortcuts.onKeyUp(for: .zoneActivation) {
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
