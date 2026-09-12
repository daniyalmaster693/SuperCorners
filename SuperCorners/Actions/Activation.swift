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

    private var localMouseMonitor: Any?
    private var globalMouseMonitor: Any?

    private var localClickMonitor: Any?
    private var globalClickMonitor: Any?

    private var localModifierMonitor: Any?
    private var globalModifierMonitor: Any?

    private var modifierFlags: NSEvent.ModifierFlags = []

    private init() {}

    func start() {
        stop()

        mouseEventMonitor()
        clickEventMonitor()

        modifierEventMonitor()
    }

    func stop() {
        if let localMouseMonitor {
            NSEvent.removeMonitor(localMouseMonitor)
            self.localMouseMonitor = nil
        }

        if let globalMouseMonitor {
            NSEvent.removeMonitor(globalMouseMonitor)
            self.globalMouseMonitor = nil
        }

        if let localClickMonitor {
            NSEvent.removeMonitor(localClickMonitor)
            self.localClickMonitor = nil
        }

        if let globalClickMonitor {
            NSEvent.removeMonitor(globalClickMonitor)
            self.globalClickMonitor = nil
        }

        if let localModifierMonitor {
            NSEvent.removeMonitor(localModifierMonitor)
            self.localModifierMonitor = nil
        }

        if let globalModifierMonitor {
            NSEvent.removeMonitor(globalModifierMonitor)
            self.globalModifierMonitor = nil
        }

        modifierFlags = []
    }

    private func mouseEventMonitor() {}

    private func clickEventMonitor() {}

    private func modifierEventMonitor() {}
}
