//
//  ZoneMousePosition.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import SwiftUI

private var lastZone: ZonePosition.Zone?

func getZoneMousePosition() {
    let mousePosition: NSPoint = NSEvent.mouseLocation

    for screen in NSScreen.screens {
        let zones: [ZonePosition.Zone] = [.top, .left, .right, .bottom]

        for zone in zones {
            let position = ZonePosition(screen: screen, zone: zone)
            let cornerPoint = position.coordinate

            let tolerance: CGFloat = 40.0
            let hitZone = CGRect(x: cornerPoint.x - tolerance/2, y: cornerPoint.y - tolerance/2, width: tolerance, height: tolerance)

            if hitZone.contains(mousePosition) {
                if zone != lastZone {
                    lastZone = zone
                    triggerZoneAction(for: zone)
                }
                return
            }
        }
    }

    lastZone = nil
}
