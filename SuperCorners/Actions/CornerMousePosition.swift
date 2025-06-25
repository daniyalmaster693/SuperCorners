//
//  CornerMousePosition.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

private var lastCorner: CornerPosition.Corner?

func getCornerMousePosition() {
    @AppStorage("triggerSensitivity") var triggerSensitivity = 5.0
    @AppStorage("disableInFullScreen") var disableInFullScreen = false

    let mousePosition: NSPoint = NSEvent.mouseLocation

    if disableInFullScreen {
        for window in NSApplication.shared.windows {
            if window.styleMask.contains(.fullScreen) {
                let windowFrame = window.frame
                if windowFrame.contains(mousePosition) {
                    lastCorner = nil
                    return
                }
            }
        }
    }

    for screen in NSScreen.screens {
        let corners: [CornerPosition.Corner] = [.topLeft, .topRight, .bottomLeft, .bottomRight, .top, .left, .right, .bottom]

        for corner in corners {
            let position = CornerPosition(screen: screen, corner: corner)
            let cornerPoint = position.coordinate

            let tolerance: CGFloat = triggerSensitivity * 10
            let hitZone = CGRect(x: cornerPoint.x - tolerance/2, y: cornerPoint.y - tolerance/2, width: tolerance, height: tolerance)

            if hitZone.contains(mousePosition) {
                if corner != lastCorner {
                    lastCorner = corner
                    triggerCornerAction(for: corner)
                }
                return
            }
        }
    }

    lastCorner = nil
}
