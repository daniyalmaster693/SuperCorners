//
//  ZoneActions.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import AppKit
import SwiftUI

var zoneActionBindings: [ZonePosition.Zone: CornerAction] = [
    .top: cornerActions[4],
    .bottom: cornerActions[5],
    .left: cornerActions[6],
    .right: cornerActions[7]
]

func triggerZoneAction(for zone: ZonePosition.Zone) {
    if let action = zoneActionBindings[zone] {
        action.perform()
    } else {
        print("No action assigned for \(zone)")
    }
}
