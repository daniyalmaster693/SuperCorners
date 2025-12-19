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

    switch action.id {
    case "4":
        if let input, let url = URL(string: input), let host = url.host {
            return host.prefix(1).uppercased() + host.dropFirst()
        }

    case "5":
        if let input, !input.isEmpty {
            let appURL = URL(fileURLWithPath: input)
            let appName = appURL.deletingPathExtension().lastPathComponent
            return "Toggle \(appName.capitalized)"
        }

    case "6":
        if let input, !input.isEmpty {
            return input.capitalized
        }

    case "7":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst())"
        }

    case "50":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst())"
        }

    case "74":
        if let input, !input.isEmpty {
            return "Countdown to \(input.capitalized)"
        }

    case "96":
        if let input, !input.isEmpty {
            return input.capitalized
        }

    default:
        break
    }

    return action.title
}
