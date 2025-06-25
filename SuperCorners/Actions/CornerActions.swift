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
    @AppStorage("enableTopLeftCorner") var enableTopLeftCorner = true
    @AppStorage("enableTopRightCorner") var enableTopRightCorner = true
    @AppStorage("enableBottomLeftCorner") var enableBottomLeftCorner = true
    @AppStorage("enableBottomRightCorner") var enableBottomRightCorner = true

    @AppStorage("enableTopZone") var enableTopZone = true
    @AppStorage("enableLeftZone") var enableLeftZone = true
    @AppStorage("enableRightZone") var enableRightZone = true
    @AppStorage("enableBottomZone") var enableBottomZone = true

    switch corner {
    case .topLeft:
        guard enableTopLeftCorner else { return }
    case .topRight:
        guard enableTopRightCorner else { return }
    case .bottomLeft:
        guard enableBottomLeftCorner else { return }
    case .bottomRight:
        guard enableBottomRightCorner else { return }
    case .top:
        guard enableTopZone else { return }
    case .left:
        guard enableLeftZone else { return }
    case .right:
        guard enableRightZone else { return }
    case .bottom:
        guard enableBottomZone else { return }
    }

    if let action = cornerActionBindings[corner] {
        action.perform()
    }
}
