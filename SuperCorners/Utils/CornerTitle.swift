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
    case "launchApp":
        if let input, !input.isEmpty {
            let appURL = URL(fileURLWithPath: input)
            let appName = appURL.deletingPathExtension().lastPathComponent
            return "Launch \(appName.capitalized)"
        }

    case "openWebsite":
        if let input, let url = URL(string: input), let host = url.host {
            return host.prefix(1).uppercased() + host.dropFirst()
        }

    case "runShortcut":
        if let input, !input.isEmpty {
            return input.capitalized
        }

    case "simulateHotkey":
        if let input, !input.isEmpty {
            return input.capitalized
        }

    case "openFolder":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst()) Folder"
        }

    case "openFile":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst())"
        }

    case "runAppleScript":
        if let input, !input.isEmpty {
            let url = URL(fileURLWithPath: input)
            let lastComponent = url.lastPathComponent
            return "Open \(lastComponent.prefix(1).uppercased() + lastComponent.dropFirst())"
        }

    case "dateCountdown":
        if let input, !input.isEmpty {
            return "Countdown to \(input)"
        }

    default:
        break
    }

    return action.title
}
