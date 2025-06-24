//
//  CornerActions.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import SwiftUI

var cornerActionBindings: [CornerPosition.Corner: CornerAction] = [
    .topLeft: cornerActions[0],
    .topRight: cornerActions[30],
    .bottomLeft: cornerActions[44],
    .bottomRight: cornerActions[45],
    .top: cornerActions[4],
    .left: cornerActions[46],
    .right: cornerActions[6],
    .bottom: cornerActions[58]
]

func triggerCornerAction(for corner: CornerPosition.Corner) {
    if let action = cornerActionBindings[corner] {
        action.perform()
    } else { return }
}
