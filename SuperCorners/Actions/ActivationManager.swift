//
//  ActivationManager.swift
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

    // Initalize and Deinitalize Monitors

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

    // Event Monitors

    private func mouseEventMonitor() {
        localMouseMonitor = NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            self?.actionActivation(trigger: .hover)
            return event
        }

        globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] _ in
            self?.actionActivation(trigger: .hover)
        }
    }

    private func clickEventMonitor() {
        localClickMonitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
            self?.actionActivation(trigger: .click)
            return event
        }

        globalClickMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] _ in
            self?.actionActivation(trigger: .click)
        }
    }

    private func modifierEventMonitor() {
        localModifierMonitor = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.modifierFlags = event.modifierFlags
            return event
        }

        globalModifierMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .flagsChanged
        ) { [weak self] event in
            self?.modifierFlags = event.modifierFlags
        }
    }

    private func actionActivation(trigger: ActivationTrigger) {
        guard let frontMostApp = NSWorkspace.shared.frontmostApplication else {
            return
        }

        let actionSets = ActionSetManager.shared.findActionSets(bundleID: frontMostApp.bundleIdentifier)

        guard let actionSet = actionSets.first(where: { actionSet in
            let activation = actionSet.activation

            guard activation.trigger == trigger else {
                return false
            }

            switch activation.method {
            case .none:
                return modifierFlags.isEmpty

            case .modifier:
                guard let modifierKey = activation.modifierKey,
                      let requiredFlag = modifierKey.flag
                else {
                    return false
                }

                return modifierFlags.contains(requiredFlag)

            case .keyboardShortcut:
                return false
            }

        }) else {
            return
        }

        getCornerMousePosition(actionSet: actionSet)
    }
}
