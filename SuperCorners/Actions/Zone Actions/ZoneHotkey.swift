//
//  ZoneHotkey.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import KeyboardShortcuts
import SwiftUI

var localZoneMonitor: Any?
var globalZoneMonitor: Any?

func activateZoneHotkey() {
    KeyboardShortcuts.setShortcut(.init(.z, modifiers: [.command, .option]), for: .zoneActivation)

    KeyboardShortcuts.onKeyDown(for: .zoneActivation) {
        localZoneMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            getZoneMousePosition()
            return event
        }

        globalZoneMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            getZoneMousePosition()
        }
    }

    KeyboardShortcuts.onKeyUp(for: .zoneActivation) {
        if let local = localZoneMonitor {
            NSEvent.removeMonitor(local)
            localZoneMonitor = nil
        }

        if let global = globalZoneMonitor {
            NSEvent.removeMonitor(global)
            globalZoneMonitor = nil
        }
    }
}
