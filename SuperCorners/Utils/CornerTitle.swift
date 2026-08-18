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
    case "24":
        if let input, let url = URL(string: input), let host = url.host {
            return host.prefix(1).uppercased() + host.dropFirst()
        }

    case "23":
        if let input, !input.isEmpty {
            let appURL = URL(fileURLWithPath: input)
            let appName = appURL.deletingPathExtension().lastPathComponent
            return "Launch \(appName.capitalized)"
        }

    case "25":
        if let input, !input.isEmpty {
            return input.capitalized
        }

    case "26":
        if let input, !input.isEmpty {
            return input.capitalized
        }

    case "27":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst()) Folder"
        }

    case "28":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst())"
        }

    case "29":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst())"
        }

    case "73":
        if let input, !input.isEmpty {
            return "Countdown to \(input)"
        }

    default:
        break
    }

    return action.title
}
