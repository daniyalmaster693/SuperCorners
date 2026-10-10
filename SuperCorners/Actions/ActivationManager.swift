//
//  ActivationManager.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

var localHoverMonitor: Any?
var globalHoverMonitor: Any?

var localClickMonitor: Any?
var globalClickMonitor: Any?

private let supportedModifierFlags: NSEvent.ModifierFlags = [
    .command,
    .option,
    .control,
    .shift,
    .capsLock
]

func cornerActivation() {
    if localHoverMonitor == nil {
        localHoverMonitor = NSEvent.addLocalMonitorForEvents(
            matching: .mouseMoved
        ) { event in
            setActivation(
                trigger: .hover,
                modifierFlags: event.modifierFlags
            )

            return event
        }
    }

    if localClickMonitor == nil {
        localClickMonitor = NSEvent.addLocalMonitorForEvents(
            matching: .leftMouseDown
        ) { event in
            setActivation(
                trigger: .click,
                modifierFlags: event.modifierFlags
            )

            return event
        }
    }

    if globalHoverMonitor == nil {
        globalHoverMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .mouseMoved
        ) { event in
            setActivation(
                trigger: .hover,
                modifierFlags: event.modifierFlags
            )
        }
    }

    if globalClickMonitor == nil {
        globalClickMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .leftMouseDown
        ) { event in
            setActivation(
                trigger: .click,
                modifierFlags: event.modifierFlags
            )
        }
    }
}

private func setActivation(trigger: ActivationTrigger, modifierFlags: NSEvent.ModifierFlags) {
    guard let bundleID = NSWorkspace.shared
        .frontmostApplication?.bundleIdentifier
    else {
        return
    }

    let actionSets = ActionSetManager.shared.findActionSets(
        bundleID: bundleID
    )

    let heldModifiers = modifierFlags.intersection(
        supportedModifierFlags
    )

    guard let actionSet = actionSets.first(where: { actionSet in
        let activation = actionSet.activation

        guard activation.trigger == trigger else {
            return false
        }

        switch activation.method {
            case .none:
                return heldModifiers.isEmpty

            case .modifier:
                guard let modifierKey = activation.modifierKey,
                      let requiredFlag = modifierKey.flag
                else {
                    return false
                }

                return heldModifiers == requiredFlag

            case .keyboardShortcut:
                return false
        }
    }) else {
        return
    }

    getCornerMousePosition(actionSet: actionSet)
}
