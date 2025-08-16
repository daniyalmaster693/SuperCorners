//
//  OCRView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-07-19.
//

import SwiftUI

class TextExtractorManager: ObservableObject {
    static let shared = TextExtractorManager()
    private let key = "RecentTextExtractions"

    var recentTexts: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: self.key) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }

    func addText(_ text: String) {
        var updated = [text] + self.recentTexts.filter { $0 != text }
        if updated.count > 20 {
            updated = Array(updated.prefix(20))
        }
        self.recentTexts = updated
    }
}

struct TextExtractorView: View {
    @ObservedObject private var colorHistory = TextExtractorManager.shared
    var body: some View {
        GeometryReader { _ in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(self.colorHistory.recentTexts.prefix(20).enumerated()), id: \.offset) { _, text in
                        HStack(spacing: 12) {
                            Text(text)
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineLimit(3)

                            Spacer()

                            Button(action: {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(text, forType: .string)

                                showSuccessToast("Copied Text to Clipboard", icon: Image(systemName: "clipboard.fill"))
                            }) {
                                Image(systemName: "square.on.square")
                                    .padding(6)
                                    .background(Color.primary.opacity(0.1))
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .frame(minHeight: 200)
    }
}

struct FloatingExtractorContentView: View {
    @AppStorage("floatingCounterValue") private var count: Int = 0

    var body: some View {
        TextExtractorView()
    }
}

class FloatingExtractorPanel: NSPanel {
    private var hostingView: NSHostingView<FloatingExtractorContentView>

    init() {
        self.hostingView = NSHostingView(rootView: FloatingExtractorContentView())

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 260),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )

        self.minSize = NSSize(width: 450, height: 260)
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

struct FloatingExtractorPanelView: View {
    @State private var floatingPanel: FloatingExtractorPanel?

    var body: some View {
        VStack {
            Button("Toggle Floating Panel") {
                if self.floatingPanel == nil {
                    let panel = FloatingExtractorPanel()
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
