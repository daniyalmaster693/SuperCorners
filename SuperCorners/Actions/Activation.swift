//
//  Activation.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import KeyboardShortcuts

class ActivationManager {
    static let shared = ActivationManager()

    private var mouseMonitor: Any?
    private var clickMonitor: Any?
    private var modifierFlags: Any?

    private var currentFlags: NSEvent.ModifierFlags = []

    private init() {}

    func start() {
        stop()

        mouseEventMonitor()
        clickEventMonitor()

        modifierEventMonitor()
    }

    func stop() {
        if let mouseMonitor {
            NSEvent.removeMonitor(mouseMonitor)
            self.mouseMonitor = nil
        }

        if let clickMonitor {
            NSEvent.removeMonitor(clickMonitor)
            self.clickMonitor = nil
        }

        if let modifierFlags {
            NSEvent.removeMonitor(modifierFlags)
            self.modifierFlags = nil
        }
    }

    private func mouseEventMonitor() {}

    private func clickEventMonitor() {}

    private func modifierEventMonitor() {}
}
