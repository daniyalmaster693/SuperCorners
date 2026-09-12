//
//  Activation.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import KeyboardShortcuts

final class ActivationManager {
    static let shared = ActivationManager()

    private var mouseMonitor: Any?
    private var clickMonitor: Any?
    private var modifierFlags: Any?

    private var currentFlags: NSEvent.ModifierFlags = []

    private init() {}
}
