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

private var activeKeyboardShortcuts: Set<String> = []

func activation() {
    let actionSets = ActionSetManager.shared.actionSets

    for actionSet in actionSets
        where actionSet.activation.method == .keyboardShortcut
    {
        guard let shortcutName = actionSet.activation.keyboardShortcut else {
            continue
        }

        let name = KeyboardShortcuts.Name(shortcutName)

        KeyboardShortcuts.onKeyDown(for: name) {
            activeKeyboardShortcuts.insert(shortcutName)
        }

        KeyboardShortcuts.onKeyUp(for: name) {
            activeKeyboardShortcuts.remove(shortcutName)
        }
    }

    if localHoverMonitor == nil {
        localHoverMonitor = NSEvent.addLocalMonitorForEvents(
            matching: .mouseMoved
        ) { event in
            if actionSets.contains(where: {
                $0.activation.method == .none && $0.activation.trigger == .hover
            }) {
                setActivation(method: .none, trigger: .hover)
            }

            if actionSets.contains(where: {
                $0.activation.method == .modifier && $0.activation.trigger == .hover
            }) {
                setActivation(method: .modifier, trigger: .hover)
            }

            if actionSets.contains(where: {
                $0.activation.method == .keyboardShortcut && $0.activation.trigger == .hover
            }) {
                setActivation(method: .keyboardShortcut, trigger: .hover)
            }

            return event
        }
    }

    if localClickMonitor == nil {
        localClickMonitor = NSEvent.addLocalMonitorForEvents(
            matching: .leftMouseDown
        ) { event in
            if actionSets.contains(where: {
                $0.activation.method == .none && $0.activation.trigger == .click

            }) {
                setActivation(method: .none, trigger: .click)
            }

            if actionSets.contains(where: {
                $0.activation.method == .modifier && $0.activation.trigger == .click

            }) {
                setActivation(method: .modifier, trigger: .click)
            }

            if actionSets.contains(where: {
                $0.activation.method == .keyboardShortcut && $0.activation.trigger == .click
            }) {
                setActivation(method: .keyboardShortcut, trigger: .click)
            }

            return event
        }
    }

    if globalHoverMonitor == nil {
        globalHoverMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .mouseMoved
        ) { _ in
            if actionSets.contains(where: {
                $0.activation.method == .none && $0.activation.trigger == .hover
            }) {
                setActivation(method: .none, trigger: .hover)
            }

            if actionSets.contains(where: {
                $0.activation.method == .modifier && $0.activation.trigger == .hover
            }) {
                setActivation(method: .modifier, trigger: .hover)
            }

            if actionSets.contains(where: {
                $0.activation.method == .keyboardShortcut && $0.activation.trigger == .hover
            }) {
                setActivation(method: .keyboardShortcut, trigger: .hover)
            }
        }
    }

    if globalClickMonitor == nil {
        globalClickMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .leftMouseDown
        ) { _ in
            if actionSets.contains(where: {
                $0.activation.method == .none && $0.activation.trigger == .click

            }) {
                setActivation(method: .none, trigger: .click)
            }

            if actionSets.contains(where: {
                $0.activation.method == .modifier && $0.activation.trigger == .click

            }) {
                setActivation(method: .modifier, trigger: .click)
            }

            if actionSets.contains(where: {
                $0.activation.method == .keyboardShortcut && $0.activation.trigger == .click
            }) {
                setActivation(method: .keyboardShortcut, trigger: .click)
            }
        }
    }
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

    if method == .keyboardShortcut {
        guard let shortcutName = actionSet.activation.keyboardShortcut,
              activeKeyboardShortcuts.contains(shortcutName)
        else {
            return
        }
    }

    getCornerMousePosition(actionSet: actionSet)
}
