//
//  CornerActions.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI
import AppKit

var cornerActionBindings: [CornerPosition.Corner: CornerAction] = [
    .topLeft: cornerActions[0],
    .topRight: cornerActions[1],
    .bottomLeft: cornerActions[2],
    .bottomRight: cornerActions[3]
]

func triggerCornerAction(for corner: CornerPosition.Corner) {
    if let action = cornerActionBindings[corner] {
        action.perform()
    } else {
        print("No action assigned for \(corner)")
    }
}
