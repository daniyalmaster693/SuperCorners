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
                setActivation(method: .none, trigger: .hover)
                return event
            }
        }

        if globalHoverMonitor == nil {
            globalHoverMonitor = NSEvent.addGlobalMonitorForEvents(
                matching: .mouseMoved
            ) { _ in
                setActivation(method: .none, trigger: .hover)
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
                setActivation(method: .none, trigger: .click)
                return event
            }
        }

        if globalClickMonitor == nil {
            globalClickMonitor = NSEvent.addGlobalMonitorForEvents(
                matching: .leftMouseDown
            ) { _ in
                setActivation(method: .none, trigger: .click)
            }
        }
    }

    // Activation using Modifer + Hover

    if actionSets.contains(where: {
        $0.activation.method == .modifier &&
            $0.activation.trigger == .hover
    }) {
        if localHoverMonitor == nil {
            localHoverMonitor = NSEvent.addLocalMonitorForEvents(
                matching: .mouseMoved
            ) { event in
                setActivation(method: .modifier, trigger: .hover)
                return event
            }
        }

        if globalHoverMonitor == nil {
            globalHoverMonitor = NSEvent.addGlobalMonitorForEvents(
                matching: .mouseMoved
            ) { _ in
                setActivation(method: .modifier, trigger: .hover)
            }
        }
    }

    // Activation using Modifer + Click

    if actionSets.contains(where: {
        $0.activation.method == .modifier &&
            $0.activation.trigger == .click
    }) {
        if localClickMonitor == nil {
            localClickMonitor = NSEvent.addLocalMonitorForEvents(
                matching: .leftMouseDown
            ) { event in
                setActivation(method: .modifier, trigger: .click)
                return event
            }
        }

        if globalClickMonitor == nil {
            globalClickMonitor = NSEvent.addGlobalMonitorForEvents(
                matching: .leftMouseDown
            ) { _ in
                setActivation(method: .modifier, trigger: .click)
            }
        }
    }

    // Activation using Keyboard Shortcut + Hover

    // Activation using Keyboard Shortcut + Click
}

private func setActivation(method: ActivationMethod, trigger: ActivationTrigger) {
    guard let bundleID = NSWorkspace.shared
        .frontmostApplication?.bundleIdentifier
    else {
        return
    }

    let actionSets = ActionSetManager.shared.findActionSets(
        bundleID: bundleID
    )

    guard let actionSet = actionSets.first(where: {
        $0.activation.method == method &&
            $0.activation.trigger == trigger
    }) else {
        return
    }

    if method == .modifier {
        guard let modifierKey = actionSet.activation.modifierKey,
              let requiredFlag = modifierKey.flag,
              NSEvent.modifierFlags.contains(requiredFlag)
        else {
            return
        }
    }

    getCornerMousePosition(actionSet: actionSet)
}
