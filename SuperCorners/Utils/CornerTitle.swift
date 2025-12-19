//
//  CornerTitle.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-19.
//

import SwiftUI

func titleForCorner(_ corner: CornerPosition.Corner) -> String {
    guard let action = cornerActionBindings[corner] else {
        return "Add Action"
    }

    let input = UserDefaults.standard.string(forKey: "cornerInput_\(corner.rawValue)")

    if action.id == "96",
       let input,
       !input.isEmpty
    {
        return input
    }

    return action.title
}
