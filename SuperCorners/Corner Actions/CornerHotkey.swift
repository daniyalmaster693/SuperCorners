//
//  CornerHotkey.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import HotKey
import SwiftUI

let cornerHotKey = HotKey(key: .c, modifiers: [.control, .option])
var localMonitor: Any?
var globalMonitor: Any?

func activateCornerHotkey() {
    cornerHotKey.keyDownHandler = {
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
            getMousePosition()
            return event
        }

        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            getMousePosition()
        }
    }

    cornerHotKey.keyUpHandler = {
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
