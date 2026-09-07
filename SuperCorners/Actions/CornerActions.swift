//
//  CornerActions.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import SwiftUI

var cornerActionBindings: [CornerPosition.Corner: CornerAction] {
    var bindings: [CornerPosition.Corner: CornerAction] = [:]

    func action(forKey key: String, defaultIndex: Int) -> CornerAction {
        let savedID = UserDefaults.standard.string(forKey: key)
        return cornerActions.first(where: { $0.id == savedID }) ?? cornerActions[defaultIndex]
    }

    bindings[.topLeft] = action(forKey: "cornerBinding_topLeft", defaultIndex: 0)
    bindings[.topRight] = action(forKey: "cornerBinding_topRight", defaultIndex: 1)
    bindings[.bottomLeft] = action(forKey: "cornerBinding_bottomLeft", defaultIndex: 2)
    bindings[.bottomRight] = action(forKey: "cornerBinding_bottomRight", defaultIndex: 3)
    bindings[.top] = action(forKey: "cornerBinding_top", defaultIndex: 4)
    bindings[.left] = action(forKey: "cornerBinding_left", defaultIndex: 5)
    bindings[.right] = action(forKey: "cornerBinding_right", defaultIndex: 6)
    bindings[.bottom] = action(forKey: "cornerBinding_bottom", defaultIndex: 7)

    return bindings
}

func triggerCornerAction(for corner: CornerPosition.Corner) {
    @AppStorage("enableTopLeftCorner") var enableTopLeftCorner = true
    @AppStorage("enableTopRightCorner") var enableTopRightCorner = true
    @AppStorage("enableBottomLeftCorner") var enableBottomLeftCorner = true
    @AppStorage("enableBottomRightCorner") var enableBottomRightCorner = true

    @AppStorage("enableTopZone") var enableTopZone = true
    @AppStorage("enableLeftZone") var enableLeftZone = true
    @AppStorage("enableRightZone") var enableRightZone = true
    @AppStorage("enableBottomZone") var enableBottomZone = true

    switch corner {
    case .topLeft:
        guard enableTopLeftCorner else { return }
    case .topRight:
        guard enableTopRightCorner else { return }
    case .bottomLeft:
        guard enableBottomLeftCorner else { return }
    case .bottomRight:
        guard enableBottomRightCorner else { return }
    case .top:
        guard enableTopZone else { return }
    case .left:
        guard enableLeftZone else { return }
    case .right:
        guard enableRightZone else { return }
    case .bottom:
        guard enableBottomZone else { return }
    }

    // Get the focused app info

    guard let focusedApp = NSWorkspace.shared.frontmostApplication else {
        return
    }

    guard let bundleID = focusedApp.bundleIdentifier else {
        return
    }

    // Ignored Applications Check

    if let focusedAppPath = focusedApp.bundleURL?.path {
        if let data = UserDefaults.standard.data(forKey: "ignoredAppPaths"),
           let ignoredPaths = try? JSONDecoder().decode([String].self, from: data),
           ignoredPaths.contains(focusedAppPath)
        {
            return
        }
    }

    // Check for an app specfic set otherwise fallback to global set

    guard let actionSet = ActionSetManager.shared.findActionSet(bundleID: bundleID) else {
        return
    }

    // Find and Perform the Action

    let assignment = actionSet.actionAssignment(for: corner)

    guard let action = cornerActions.first(where: {
        $0.id == assignment.actionID
    }) else {
        return
    }

    action.perform(assignment.input)
}
