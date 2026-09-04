//
//  ActionSets.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-08-17.
//

import AppKit
import Foundation

struct ActionAssignment: Codable {
    var actionID: String
    var input: String?
}

struct ActionSet: Codable, Identifiable {
    var id: UUID = .init()
    var name: String
    var targetBundleID: String?

    var topLeft: ActionAssignment
    var topRight: ActionAssignment
    var bottomLeft: ActionAssignment
    var bottomRight: ActionAssignment

    var top: ActionAssignment
    var left: ActionAssignment
    var right: ActionAssignment
    var bottom: ActionAssignment
}

final class ActionSetManager: ObservableObject {
    static let shared = ActionSetManager()

    @Published var availableSets: [ActionSet] = [
        ActionSet(
            name: "Global Actions",
            targetBundleID: nil,
            topLeft: ActionAssignment(
                actionID: "screenSaver",
                input: nil
            ),
            topRight: ActionAssignment(
                actionID: "sleepDisplay",
                input: nil
            ),
            bottomLeft: ActionAssignment(
                actionID: "lockScreen",
                input: nil
            ),
            bottomRight: ActionAssignment(
                actionID: "spotlightSearch",
                input: nil
            ),
            top: ActionAssignment(
                actionID: "spotlightApps",
                input: nil
            ),
            left: ActionAssignment(
                actionID: "missionControl",
                input: nil
            ),
            right: ActionAssignment(
                actionID: "applicationWindows",
                input: nil
            ),
            bottom: ActionAssignment(
                actionID: "notificationCenter",
                input: nil
            ),
        ),
        ActionSet(
            name: "Safari Actions",
            targetBundleID: "com.apple.safari",
            topLeft: ActionAssignment(
                actionID: "screenSaver",
                input: nil
            ),
            topRight: ActionAssignment(
                actionID: "sleepDisplay",
                input: nil
            ),
            bottomLeft: ActionAssignment(
                actionID: "toggleTheme",
                input: nil
            ),
            bottomRight: ActionAssignment(
                actionID: "toggleAwake",
                input: nil
            ),
            top: ActionAssignment(
                actionID: "spotlightApps",
                input: nil
            ),
            left: ActionAssignment(
                actionID: "missionControl",
                input: nil
            ),
            right: ActionAssignment(
                actionID: "applicationWindows",
                input: nil
            ),
            bottom: ActionAssignment(
                actionID: "notificationCenter",
                input: nil
            ),
        ),
        ActionSet(
            name: "Xcode Actions",
            targetBundleID: "com.apple.dt.xcode",
            topLeft: ActionAssignment(
                actionID: "screenSaver",
                input: nil
            ),
            topRight: ActionAssignment(
                actionID: "sleepDisplay",
                input: nil
            ),
            bottomLeft: ActionAssignment(
                actionID: "createNote",
                input: nil
            ),
            bottomRight: ActionAssignment(
                actionID: "createEvent",
                input: nil
            ),
            top: ActionAssignment(
                actionID: "spotlightApps",
                input: nil
            ),
            left: ActionAssignment(
                actionID: "missionControl",
                input: nil
            ),
            right: ActionAssignment(
                actionID: "applicationWindows",
                input: nil
            ),
            bottom: ActionAssignment(
                actionID: "notificationCenter",
                input: nil
            ),
        ),
    ]
}
