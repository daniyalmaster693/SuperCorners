//
//  CornerActions.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import SwiftUI

var cornerActionBindings: [CornerPosition.Corner: CornerAction] {
    var bindings: [CornerPosition.Corner: CornerAction] = [:]

    func action(forKey key: String, defaultIndex: Int) -> CornerAction {
        let savedID = UserDefaults.standard.string(forKey: key)
        return cornerActions.first(where: { $0.id == savedID }) ?? cornerActions[defaultIndex]
    }

    bindings[.topLeft] = action(forKey: "cornerBinding_topLeft", defaultIndex: 0)
    bindings[.topRight] = action(forKey: "cornerBinding_topRight", defaultIndex: 62)
    bindings[.bottomLeft] = action(forKey: "cornerBinding_bottomLeft", defaultIndex: 44)
    bindings[.bottomRight] = action(forKey: "cornerBinding_bottomRight", defaultIndex: 45)
    bindings[.top] = action(forKey: "cornerBinding_top", defaultIndex: 4)
    bindings[.left] = action(forKey: "cornerBinding_left", defaultIndex: 46)
    bindings[.right] = action(forKey: "cornerBinding_right", defaultIndex: 6)
    bindings[.bottom] = action(forKey: "cornerBinding_bottom", defaultIndex: 58)

    return bindings
}

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
        if let frontApp = NSWorkspace.shared.frontmostApplication,
           let frontAppPath = frontApp.bundleURL?.path
        {
            if let data = UserDefaults.standard.data(forKey: "ignoredAppPaths"),
               let ignoredPaths = try? JSONDecoder().decode([String].self, from: data),
               ignoredPaths.contains(frontAppPath)
            {
                return
            }
        }

        let input = UserDefaults.standard.string(forKey: "cornerInput_\(corner.rawValue)")
        action.perform(input)
    }
}
