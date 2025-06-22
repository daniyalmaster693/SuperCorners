//
//  ZonePosition.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import AppKit

struct ZonePosition {
    enum Zone {
        case top, left, right, bottom
    }

    let screen: NSScreen
    let zone: Zone

    var coordinate: CGPoint {
        let frame = screen.frame

        switch zone {
        case .top:
            return CGPoint(x: frame.maxX / 2, y: frame.maxY)
        case .left:
            return CGPoint(x: frame.minX, y: frame.maxY / 2)
        case .right:
            return CGPoint(x: frame.maxX, y: frame.maxY / 2)
        case .bottom:
            return CGPoint(x: frame.maxX / 2, y: frame.minY)
        }
    }
}
