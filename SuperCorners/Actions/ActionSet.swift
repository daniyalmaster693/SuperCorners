//
//  ActionSet.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-06.
//

import Foundation
import SwiftUI

struct ActionsConfig: Codable {
    var actionSets: [ActionSet]
}

struct ActionSet: Codable, Identifiable {
    var id: String
    var name: String
    var targetBundleID: String?
    var corners: CornerAssignments
    var zones: ZoneAssignments
    var activation: SetActivation
}

struct CornerAssignments: Codable {
    var topLeft: ActionAssignment
    var topRight: ActionAssignment
    var bottomLeft: ActionAssignment
    var bottomRight: ActionAssignment
}

struct ZoneAssignments: Codable {
    var top: ActionAssignment
    var left: ActionAssignment
    var right: ActionAssignment
    var bottom: ActionAssignment
}

struct ActionAssignment: Codable {
    var actionID: String
    var input: String?
}

struct SetActivation: Codable {
    var method: ActivationMethod
    var trigger: ActivationTrigger
    var modifierKey: ModifierKey?
    var keyboardShortcut: String?
}

enum ModifierKey: String, Codable, CaseIterable, Identifiable {
    case command = "Command"
    case option = "Option"
    case control = "Control"
    case shift = "Shift"
    case capsLock = "CapsLock"

    var id: String { rawValue }
}

enum ActivationMethod: String, Codable, CaseIterable {
    case none
    case modifier
    case keyboardShortcut
}

enum ActivationTrigger: String, Codable, CaseIterable {
    case hover
    case click
}

extension ModifierKey {
    var flag: NSEvent.ModifierFlags? {
        switch self {
        case .command: return .command
        case .option: return .option
        case .control: return .control
        case .shift: return .shift
        case .capsLock: return .capsLock
        }
    }
}

extension ActionSet {
    func actionAssignment(for position: CornerPosition.Corner) -> ActionAssignment {
        switch position {
        case .topLeft:
            return corners.topLeft

        case .topRight:
            return corners.topRight

        case .bottomLeft:
            return corners.bottomLeft

        case .bottomRight:
            return corners.bottomRight

        case .top:
            return zones.top

        case .left:
            return zones.left

        case .right:
            return zones.right

        case .bottom:
            return zones.bottom
        }
    }
}
