//
//  ActionTrigger.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import SwiftUI

func triggerCornerAction(for corner: CornerPosition.Corner) {
    let assignment = actionSet.actionAssignment(for: corner)

    guard let action = cornerActions.first(where: {
        $0.id == assignment.actionID
    }) else {
        return
    }

    action.perform(assignment.input)
}
