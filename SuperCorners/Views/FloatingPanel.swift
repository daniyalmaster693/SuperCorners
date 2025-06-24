//
//  FloatingPanel.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-24.
//

import AppKit
import SwiftUI

struct FloatingPanelContentView: View {
    var body: some View {
        Text("This is a floating panel")
            .frame(width: 300, height: 200)
            .padding()
    }
}

class FloatingPanel: NSPanel {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 350),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        self.isFloatingPanel = true
        self.level = .floating
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.standardWindowButton(.miniaturizeButton)?.isEnabled = false
        self.standardWindowButton(.zoomButton)?.isEnabled = false
        self.isMovableByWindowBackground = true

        titlebarAppearsTransparent = true
        isMovableByWindowBackground = true
        hasShadow = true

        let visualEffectView = NSVisualEffectView(frame: self.contentView!.bounds)
        visualEffectView.autoresizingMask = [.width, .height]
        visualEffectView.material = .sidebar
        visualEffectView.state = .active
        visualEffectView.blendingMode = .behindWindow

        let hostingView = NSHostingView(rootView: FloatingPanelContentView())
        hostingView.frame = self.contentView!.bounds
        hostingView.autoresizingMask = [.width, .height]

        let containerView = NSView(frame: self.contentView!.bounds)
        containerView.autoresizingMask = [.width, .height]
        containerView.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
        containerView.addSubview(hostingView)

        self.contentView = containerView
    }
}

struct FloatingPanelView: View {
    @State private var floatingPanel: FloatingPanel?

    var body: some View {
        Button("Toggle Floating Panel") {
            if self.floatingPanel == nil {
                let panel = FloatingPanel()
                panel.center()
                panel.makeKeyAndOrderFront(nil)
                self.floatingPanel = panel
            } else {
                self.floatingPanel?.close()
                self.floatingPanel = nil
            }
        }
    }
}
