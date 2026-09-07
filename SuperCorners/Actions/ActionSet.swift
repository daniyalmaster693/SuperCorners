//
//  ActionSet.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-06.
//

import Foundation

struct ActionsConfig: Codable {
    var actionSets: [ActionSet]
}

struct ActionSet: Codable, Identifiable {
    var id: String
    var name: String
    var targetBundleID: String?
    var corners: CornerAssignments
    var zones: ZoneAssignments
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
