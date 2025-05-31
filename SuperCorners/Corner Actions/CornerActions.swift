//
//  CornerActions.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI
import AppKit

var topLeftAction = 0
var topRightAction = 1
var bottomLeftAction = 2
var bottomRightAction = 3

var cornerActionBindings: [CornerPosition.Corner: CornerAction] = [
    .topLeft: cornerActions[topLeftAction],
    .topRight: cornerActions[topRightAction],
    .bottomLeft: cornerActions[bottomLeftAction],
    .bottomRight: cornerActions[bottomRightAction]
]

func triggerCornerAction(for corner: CornerPosition.Corner) {
    if let action = cornerActionBindings[corner] {
        action.perform()
    } else {
        print("No action assigned for \(corner)")
    }
}
