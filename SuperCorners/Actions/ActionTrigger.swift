//
//  ActionTrigger.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import SwiftUI

func triggerCornerAction(for corner: CornerPosition.Corner) {
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

    guard let actionSet = ActionSetManager.shared.findActionSets(bundleID: bundleID) else {
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
