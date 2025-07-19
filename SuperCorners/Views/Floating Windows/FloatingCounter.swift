//
//  FloatingCounter.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-07-19.
//

import AppKit
import SwiftUI

struct CounterView: View {
    @Binding var count: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("\(self.count)")
                .font(.system(size: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .semibold, design: .rounded))
                .padding()

            VStack(spacing: 16) {
                HStack(spacing: 20) {
                    Button(action: { self.count -= 1 }) {
                        Label("Decrement", systemImage: "minus")
                    }

                    Button(action: { self.count += 1 }) {
                        Label("Increment", systemImage: "plus")
                    }
                }

                Button(action: { self.count = 0 }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
            }
        }
        .padding()
    }
}

struct FloatingCounterContentView: View {
    @AppStorage("floatingCounterValue") private var count: Int = 0

    var body: some View {
        CounterView(count: self.$count)
            .frame(width: 300, height: 200)
    }
}

class FloatingCounterPanel: NSPanel {
    private var hostingView: NSHostingView<FloatingCounterContentView>

    init() {
        self.hostingView = NSHostingView(rootView: FloatingCounterContentView())

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )

        self.minSize = NSSize(width: 300, height: 200)
        self.isFloatingPanel = true
        self.level = .floating
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        self.isMovableByWindowBackground = true

        let visualEffectView = NSVisualEffectView(frame: self.contentView!.bounds)
        visualEffectView.autoresizingMask = [.width, .height]
        visualEffectView.material = .sidebar
        visualEffectView.state = .active
        visualEffectView.blendingMode = .behindWindow

        self.hostingView.frame = self.contentView!.bounds
        self.hostingView.autoresizingMask = [.width, .height]

        let containerView = NSView(frame: self.contentView!.bounds)
        containerView.autoresizingMask = [.width, .height]
        containerView.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
        containerView.addSubview(self.hostingView)

        self.contentView = containerView
        self.center()
        self.alphaValue = 0
    }

    func show() {
        self.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            self.animator().alphaValue = 1
        }
    }
}

struct FloatingCounterPanelView: View {
    @State private var floatingPanel: FloatingCounterPanel?

    var body: some View {
        VStack {
            Button("Toggle Floating Panel") {
                if self.floatingPanel == nil {
                    let panel = FloatingCounterPanel()
                    panel.show()
                    self.floatingPanel = panel
                } else {
                    self.floatingPanel?.close()
                    self.floatingPanel = nil
                }
            }
        }
    }
}
