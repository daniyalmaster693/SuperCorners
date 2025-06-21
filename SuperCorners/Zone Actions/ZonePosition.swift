//
//  ZonePosition.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import AppKit

struct ZonePosition {
    enum Zone {
        case top, bottom, left, right
    }

    let screen: NSScreen
    let zone: Zone

    func contains(mousePoint: CGPoint, threshold: CGFloat = 10) -> Bool {
        let frame = screen.frame
        switch zone {
        case .top:
            return abs(mousePoint.y - frame.maxY) <= threshold &&
                mousePoint.x >= frame.minX && mousePoint.x <= frame.maxX
        case .bottom:
            return abs(mousePoint.y - frame.minY) <= threshold &&
                mousePoint.x >= frame.minX && mousePoint.x <= frame.maxX
        case .left:
            return abs(mousePoint.x - frame.minX) <= threshold &&
                mousePoint.y >= frame.minY && mousePoint.y <= frame.maxY
        case .right:
            return abs(mousePoint.x - frame.maxX) <= threshold &&
                mousePoint.y >= frame.minY && mousePoint.y <= frame.maxY
        }
    }
}
