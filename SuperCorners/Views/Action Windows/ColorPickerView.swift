//
//  ColorPickerView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-07-19.
//

import SwiftUI

class ColorHistoryManager: ObservableObject {
    static let shared = ColorHistoryManager()
    private let key = "RecentColors"

    var recentColors: [NSColor] {
        get {
            let hexes = UserDefaults.standard.stringArray(forKey: self.key) ?? []
            return hexes.compactMap { NSColor(hex: $0) }
        }
        set {
            let hexes = newValue.map { $0.hexString }
            UserDefaults.standard.set(hexes, forKey: self.key)
        }
    }

    func addColor(_ color: NSColor) {
        var updated = [color] + self.recentColors.filter { $0.hexString != color.hexString }
        if updated.count > 20 {
            updated = Array(updated.prefix(20))
        }
        self.recentColors = updated
    }
}

extension NSColor {
    var hexString: String {
        let r = Int(self.redComponent * 255)
        let g = Int(self.greenComponent * 255)
        let b = Int(self.blueComponent * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    convenience init?(hex: String) {
        let r, g, b: CGFloat

        var hexColor = hex
        if hex.hasPrefix("#") {
            hexColor = String(hex.dropFirst())
        }

        if hexColor.count == 6,
           let intCode = Int(hexColor, radix: 16)
        {
            r = CGFloat((intCode >> 16) & 0xFF) / 255
            g = CGFloat((intCode >> 8) & 0xFF) / 255
            b = CGFloat(intCode & 0xFF) / 255

            self.init(calibratedRed: r, green: g, blue: b, alpha: 1.0)
            return
        }

        return nil
    }
}

struct ColorPickerView: View {
    @ObservedObject private var colorHistory = ColorHistoryManager.shared
    var body: some View {
        GeometryReader { _ in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(self.colorHistory.recentColors.prefix(20).enumerated()), id: \.offset) { _, nsColor in
                        let color = Color(nsColor: nsColor)
                        let red = Int(nsColor.redComponent * 255)
                        let green = Int(nsColor.greenComponent * 255)
                        let blue = Int(nsColor.blueComponent * 255)
                        let hex = String(format: "#%02X%02X%02X", red, green, blue)

                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(color)
                                .frame(width: 30, height: 30)

                            Text(hex)
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()

                            Button(action: {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(hex, forType: .string)
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

struct FloatingPickerContentView: View {
    @AppStorage("floatingCounterValue") private var count: Int = 0

    var body: some View {
        ColorPickerView()
    }
}

class FloatingPickerPanel: NSPanel {
    private var hostingView: NSHostingView<FloatingPickerContentView>

    init() {
        self.hostingView = NSHostingView(rootView: FloatingPickerContentView())

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

struct FloatingPickerPanelView: View {
    @State private var floatingPanel: FloatingPickerPanel?

    var body: some View {
        VStack {
            Button("Toggle Floating Panel") {
                if self.floatingPanel == nil {
                    let panel = FloatingPickerPanel()
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
