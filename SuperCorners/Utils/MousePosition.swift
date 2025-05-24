//
//  Corners.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

private var lastCorner: CornerPosition.Corner? = nil

func getMousePosition() {
    let mousePosition: NSPoint = NSEvent.mouseLocation

    for screen in NSScreen.screens {
        let corners: [CornerPosition.Corner] = [.topLeft, .topRight, .bottomLeft, .bottomRight]

        for corner in corners {
            let position = CornerPosition(screen: screen, corner: corner)
            let cornerPoint = position.coordinate

            let tolerance: CGFloat = 10.0
            let hitZone = CGRect(x: cornerPoint.x - tolerance/2, y: cornerPoint.y - tolerance/2, width: tolerance, height: tolerance)

            if hitZone.contains(mousePosition) {
                if corner != lastCorner {
                    print("Mouse is at \(corner)")
                    lastCorner = corner
                    triggerCornerAction(for: corner)
                }
                return
            }
        }
    }

    lastCorner = nil
}
