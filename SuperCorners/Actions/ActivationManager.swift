//
//  ActivationManager.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import KeyboardShortcuts
import SwiftUI

private var localHoverMonitor: Any?
private var globalHoverMonitor: Any?

private var localClickMonitor: Any?
private var globalClickMonitor: Any?

func activation() {
    let actionSets = ActionSetManager.shared.actionSets

    // Activation Using Hover

    if actionSets.contains(where: {
        $0.activation.trigger == .hover &&
            $0.activation.method == .none
    }) {
        if localHoverMonitor == nil {
            localHoverMonitor = NSEvent.addLocalMonitorForEvents(
                matching: .mouseMoved
            ) { event in
                setActivation(trigger: .hover)
                return event
            }
        }

        if globalHoverMonitor == nil {
            globalHoverMonitor = NSEvent.addGlobalMonitorForEvents(
                matching: .mouseMoved
            ) { _ in
                setActivation(trigger: .hover)
            }
        }
    }

    // Activation Using Click

    if actionSets.contains(where: {
        $0.activation.trigger == .click &&
            $0.activation.method == .none
    }) {
        if localClickMonitor == nil {
            localClickMonitor = NSEvent.addLocalMonitorForEvents(
                matching: .leftMouseDown
            ) { event in
                setActivation(trigger: .click)
                return event
            }
        }

        if globalClickMonitor == nil {
            globalClickMonitor = NSEvent.addGlobalMonitorForEvents(
                matching: .leftMouseDown
            ) { _ in
                setActivation(trigger: .click)
            }
        }
    }
}

private func setActivation(trigger: ActivationTrigger) {
    guard let bundleID = NSWorkspace.shared
        .frontmostApplication?.bundleIdentifier
    else {
        return
    }

    let actionSets = ActionSetManager.shared.findActionSets(
        bundleID: bundleID
    )

    guard let actionSet = actionSets.first(where: {
        $0.activation.trigger == trigger &&
            $0.activation.method == .none
    }) else {
        return
    }

    getCornerMousePosition(actionSet: actionSet)
}
