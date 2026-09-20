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
        window.alphaValue = 0

        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary
        ]

        window.contentView = NSHostingView(
            rootView: VisualOverlay()
        )

        self.window = window
    }

    func show(in rect: CGRect) {
        guard UserDefaults.standard.bool(forKey: "showVisualFeedback") else {
            return
        }

        if window == nil {
            createWindow()
        }

        window?.setFrame(rect, display: true)
        window?.orderFrontRegardless()

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            window?.animator().alphaValue = 1
        }

        hideTask?.cancel()

        let duration = UserDefaults.standard.object(forKey: "visualDismissTimer") as? Double ?? 3.0

        hideTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(duration))

            guard !Task.isCancelled else {
                return
            }

            self?.hide()
        }
    }

    func hide() {
        hideTask?.cancel()
        hideTask = nil

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            window?.animator().alphaValue = 0
        }
    }
}

struct VisualOverlay: View {
    @AppStorage("visualOverlayColor") private var visualOverlayColor = "Red"

    private var overlayColor: Color {
        switch visualOverlayColor {
        case "Red":
            return .red
        case "Orange":
            return .orange
        case "Yellow":
            return .yellow
        case "Green":
            return .green
        case "Blue":
            return .blue
        case "Purple":
            return .purple
        case "Pink":
            return .pink
        case "White":
            return .white
        default:
            return .red
        }
    }

    var body: some View {
        Rectangle()
            .fill(overlayColor.opacity(0.3))
            .overlay(
                Rectangle()
                    .stroke(overlayColor, lineWidth: 2)
            )
    }
}
