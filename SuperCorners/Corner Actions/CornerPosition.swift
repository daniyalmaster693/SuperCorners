//
//  CornerPosition.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit

struct CornerPosition {
    enum Corner {
        case topLeft, topRight, bottomLeft, bottomRight
    }

    let screen: NSScreen
    let corner: Corner

    var coordinate: CGPoint {
        let frame = screen.frame

        switch corner {
        case .topLeft:
            return CGPoint(x: frame.minX, y: frame.maxY)
        case .topRight:
            return CGPoint(x: frame.maxX, y: frame.maxY)
        case .bottomLeft:
            return CGPoint(x: frame.minX, y: frame.minY)
        case .bottomRight:
            return CGPoint(x: frame.maxX, y: frame.minY)
        }
    }
}
