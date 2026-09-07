//
//  VisualOverlay.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-07.
//

import AppKit
import SwiftUI

struct VisualOverlay: View {
    var body: some View {
        Rectangle()
            .fill(Color.accentColor.opacity(0.3))
            .overlay(
                Rectangle()
                    .stroke(Color.accentColor, lineWidth: 2)
            )
    }
}

@MainActor
final class VisualOverlayManager {
    static let shared = VisualOverlayManager()

    private var window: NSWindow?
    private var hideTask: Task<Void, Never>?

    private init() {}

    func show(in rect: CGRect) {
        guard UserDefaults.standard.bool(forKey: "showVisualFeedback") else {
            return
        }

        let keepPersistent = UserDefaults.standard.bool(forKey: "persistentVisualFeedback")
        let duration = UserDefaults.standard.double(forKey: "visualFeedbackDuration")

        guard !keepPersistent else {
            return
        }

        showWindow(in: rect)
        hideTask?.cancel()

        hideTask = Task { [weak self] in
            try? await Task.sleep(
                for: .seconds(duration)
            )

            guard !Task.isCancelled else {
                return
            }

            self?.hide()
        }
    }

    private func showWindow(in rect: CGRect) {
        window?.orderOut(nil)

        let window = NSWindow(
            contentRect: rect,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.ignoresMouseEvents = true
        window.hasShadow = false
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary
        ]

        window.contentView = NSHostingView(
            rootView: VisualOverlay()
        )

        window.orderFrontRegardless()

        self.window = window
    }

    func hide() {
        hideTask?.cancel()
        hideTask = nil

        window?.orderOut(nil)
        window = nil
    }
}
