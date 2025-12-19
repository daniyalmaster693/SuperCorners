//
//  SimulateKeyHelper.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-19.
//

import KeyboardShortcuts
import SwiftUI

let symbolToModifier: [Character: String] = [
    "⌃": "control",
    "⌥": "option",
    "⇧": "shift",
    "⌘": "command"
]

func parseShortcutString(_ shortcut: String) -> (modifiers: [String], key: String)? {
    var modifiers: [String] = []
    var key = ""

    for char in shortcut {
        if let modName = symbolToModifier[char] {
            modifiers.append(modName)
        } else {
            key.append(char)
        }
    }

    guard !key.isEmpty else { return nil }
    return (modifiers, key.lowercased())
}
