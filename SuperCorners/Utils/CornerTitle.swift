//
//  CornerTitle.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-19.
//

import SwiftUI

func titleForCorner(_ corner: CornerPosition.Corner, currentSet: ActionSet) -> String {
    let assignment = currentSet.actionAssignment(for: corner)

    guard let action = cornerActions.first(where: {
        $0.id == assignment.actionID
    }) else {
        return "Add Action"
    }

    let input = assignment.input

    switch action.id {
    case "launchApp":
        if let input, !input.isEmpty {
            let appURL = URL(fileURLWithPath: input)
            let appName = appURL.deletingPathExtension().lastPathComponent
            return "Launch \(appName.capitalized)"
        }

    case "openWebsite":
        if let input,
           let url = URL(string: input)
        {
            if url.scheme == "http" || url.scheme == "https" {
                return url.host ?? input
            }

            if input.hasPrefix("raycast://extensions") {
                return url.lastPathComponent
            }

            if input.hasPrefix("tinycast://extensions") {
                return url.lastPathComponent
            }

            if input.hasPrefix("alfred://") {
                return url.lastPathComponent
            }

            if input.hasPrefix("alfredpreferences://") {
                return url.lastPathComponent
            }

            return url.scheme?.capitalized ?? input
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

    case "runTerminalCommand":
        if let input, !input.isEmpty {
            let command = input
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: .whitespacesAndNewlines)
                .first ?? ""

            let commandName = URL(fileURLWithPath: command).lastPathComponent
            return commandName.isEmpty ? action.title : commandName
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
