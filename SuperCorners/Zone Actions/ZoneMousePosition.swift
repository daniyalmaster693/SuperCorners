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
        let zones: [ZonePosition.Zone] = [.top, .bottom, .left, .right]

        for zone in zones {
            let position = ZonePosition(screen: screen, zone: zone)

            if position.contains(mousePoint: mousePosition) {
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
