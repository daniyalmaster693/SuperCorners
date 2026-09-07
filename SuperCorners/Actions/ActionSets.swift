//
//  ActionSets.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-08-17.
//

import AppKit
import Foundation

struct ActionAssignmentArray: Codable {
    var actionID: String
    var input: String?
}

struct ActionSetArray: Codable, Identifiable {
    var id: UUID = .init()
    var name: String
    var targetBundleID: String?

    var topLeft: ActionAssignmentArray
    var topRight: ActionAssignmentArray
    var bottomLeft: ActionAssignmentArray
    var bottomRight: ActionAssignmentArray

    var top: ActionAssignmentArray
    var left: ActionAssignmentArray
    var right: ActionAssignmentArray
    var bottom: ActionAssignmentArray
}

final class ActionSetManager: ObservableObject {
    static let shared = ActionSetManager()

    @Published var availableSets: [ActionSetArray] = [
        ActionSetArray(
            name: "Global Actions",
            targetBundleID: nil,
            topLeft: ActionAssignmentArray(
                actionID: "screenSaver",
                input: nil
            ),
            topRight: ActionAssignmentArray(
                actionID: "sleepDisplay",
                input: nil
            ),
            bottomLeft: ActionAssignmentArray(
                actionID: "lockScreen",
                input: nil
            ),
            bottomRight: ActionAssignmentArray(
                actionID: "spotlightSearch",
                input: nil
            ),
            top: ActionAssignmentArray(
                actionID: "spotlightApps",
                input: nil
            ),
            left: ActionAssignmentArray(
                actionID: "missionControl",
                input: nil
            ),
            right: ActionAssignmentArray(
                actionID: "applicationWindows",
                input: nil
            ),
            bottom: ActionAssignmentArray(
                actionID: "notificationCenter",
                input: nil
            ),
        ),
        ActionSetArray(
            name: "Safari Actions",
            targetBundleID: "com.apple.safari",
            topLeft: ActionAssignmentArray(
                actionID: "createEmail",
                input: nil
            ),
            topRight: ActionAssignmentArray(
                actionID: "createEvent",
                input: nil
            ),
            bottomLeft: ActionAssignmentArray(
                actionID: "copyPage",
                input: nil
            ),
            bottomRight: ActionAssignmentArray(
                actionID: "readerMode",
                input: nil
            ),
            top: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            left: ActionAssignmentArray(
                actionID: "openWebsite",
                input: "https://menuscores.vercel.app"
            ),
            right: ActionAssignmentArray(
                actionID: "openWebsite",
                input: "https://supercorners.vercel.app"
            ),
            bottom: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
        ),
        ActionSetArray(
            name: "Finder Actions",
            targetBundleID: "com.apple.finder",
            topLeft: ActionAssignmentArray(
                actionID: "createFile",
                input: nil
            ),
            topRight: ActionAssignmentArray(
                actionID: "createFolder",
                input: nil
            ),
            bottomLeft: ActionAssignmentArray(
                actionID: "openAirDrop",
                input: nil
            ),
            bottomRight: ActionAssignmentArray(
                actionID: "goToFolder",
                input: nil
            ),
            top: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            left: ActionAssignmentArray(
                actionID: "openDownload",
                input: nil
            ),
            right: ActionAssignmentArray(
                actionID: "copyDownload",
                input: nil
            ),
            bottom: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
        ),
    ]

    // Set Management

    func createSet(name: String, targetBundleID: String) {
        let newSet = ActionSetArray(
            name: name,
            targetBundleID: targetBundleID,
            topLeft: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            topRight: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            bottomLeft: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            bottomRight: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            top: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            left: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            right: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            ),
            bottom: ActionAssignmentArray(
                actionID: "doNothing",
                input: nil
            )
        )

        availableSets.append(newSet)
    }

    func deleteSet(_ set: ActionSetArray) {
        guard set.targetBundleID != nil else {
            return
        }

        availableSets.removeAll {
            $0.id == set.id
        }
    }
}

extension ActionSet {
    func ActionAssignmentArray(for corner: CornerPosition.Corner) -> ActionAssignmentArray {
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
