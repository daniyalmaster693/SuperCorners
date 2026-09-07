//
//  VisualOverlay.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-07.
//

import AppKit
import SwiftUI

@MainActor
final class VisualOverlayManager {
    static let shared = VisualOverlayManager()

    private var window: NSWindow?
    private var hideTask: Task<Void, Never>?

    private init() {}

    private func createWindow() {
        let window = NSWindow(
            contentRect: .zero,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.ignoresMouseEvents = true

        window.level = .statusBar

        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary
        ]

        window.contentView = NSHostingView(
            rootView: VisualOverlay()
        )

        self.window = window
    }
}

struct VisualOverlay: View {
    var body: some View {
        Rectangle()
            .fill(Color.red.opacity(0.3))
            .overlay(
                Rectangle()
                    .stroke(Color.red, lineWidth: 2)
            )
    }
}
