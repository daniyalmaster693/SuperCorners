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
                actionID: "createEmail",
                input: nil
            ),
            topRight: ActionAssignment(
                actionID: "createEvent",
                input: nil
            ),
            bottomLeft: ActionAssignment(
                actionID: "copyPage",
                input: nil
            ),
            bottomRight: ActionAssignment(
                actionID: "readerMode",
                input: nil
            ),
            top: ActionAssignment(
                actionID: "doNothing",
                input: nil
            ),
            left: ActionAssignment(
                actionID: "doNothing",
                input: nil
            ),
            right: ActionAssignment(
                actionID: "doNothing",
                input: nil
            ),
            bottom: ActionAssignment(
                actionID: "doNothing",
                input: nil
            ),
        ),
        ActionSet(
            name: "Finder Actions",
            targetBundleID: "/System/Library/CoreServices/Finder.app",
            topLeft: ActionAssignment(
                actionID: "createFile",
                input: nil
            ),
            topRight: ActionAssignment(
                actionID: "createFolder",
                input: nil
            ),
            bottomLeft: ActionAssignment(
                actionID: "openAirDrop",
                input: nil
            ),
            bottomRight: ActionAssignment(
                actionID: "goToFolder",
                input: nil
            ),
            top: ActionAssignment(
                actionID: "doNothing",
                input: nil
            ),
            left: ActionAssignment(
                actionID: "openDownload",
                input: nil
            ),
            right: ActionAssignment(
                actionID: "copyDownload",
                input: nil
            ),
            bottom: ActionAssignment(
                actionID: "doNothing",
                input: nil
            ),
        ),
    ]
}

extension ActionSet {
    func actionAssignment(for corner: CornerPosition.Corner) -> ActionAssignment {
        switch corner {
        case .topLeft:
            return topLeft
        case .topRight:
            return topRight
        case .bottomLeft:
            return bottomLeft
        case .bottomRight:
            return bottomRight
        case .top:
            return top
        case .left:
            return left
        case .right:
            return right
        case .bottom:
            return bottom
        }
    }
}
