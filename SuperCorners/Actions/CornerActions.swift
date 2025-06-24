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
    .topRight: cornerActions[1],
    .bottomLeft: cornerActions[2],
    .bottomRight: cornerActions[3],
    .top: cornerActions[4],
    .left: cornerActions[5],
    .right: cornerActions[6],
    .bottom: cornerActions[7]
]

func triggerCornerAction(for corner: CornerPosition.Corner) {
    if let action = cornerActionBindings[corner] {
        action.perform()
        DispatchQueue.main.async {
            let toast = ToastWindowController()
            toast.showToast(
                message: "Action Completed",
                icon: Image(systemName: "checkmark.circle.fill")
            )
        }
    } else {
        print("No action assigned for \(corner)")
    }
}
