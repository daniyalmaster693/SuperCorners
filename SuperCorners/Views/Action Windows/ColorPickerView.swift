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

    struct StoredColor: Codable {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
    }

    func formattedColorString(for color: NSColor, format: ActionSettingsView.ColorFormat) -> String {
        switch format {
        case .hex:
            let r = Int(color.redComponent * 255)
            let g = Int(color.greenComponent * 255)
            let b = Int(color.blueComponent * 255)
            return String(format: "#%02X%02X%02X", r, g, b)

        case .rgb:
            let r = Int(color.redComponent * 255)
            let g = Int(color.greenComponent * 255)
            let b = Int(color.blueComponent * 255)
            return "rgb(\(r), \(g), \(b))"

        case .hsl:
            let hsl = color.usingColorSpace(.deviceRGB)?.hslComponents() ?? (0, 0, 0)
            return String(format: "hsl(%.0f, %.0f%%, %.0f%%)", hsl.0, hsl.1 * 100, hsl.2 * 100)

        case .rgba:
            let r = Int(color.redComponent * 255)
            let g = Int(color.greenComponent * 255)
            let b = Int(color.blueComponent * 255)
            let a = String(format: "%.2f", color.alphaComponent)
            return "rgba(\(r), \(g), \(b), \(a))"

        case .hsla:
            let hsl = color.usingColorSpace(.deviceRGB)?.hslComponents() ?? (0, 0, 0)
            let a = String(format: "%.2f", color.alphaComponent)
            return String(format: "hsla(%.0f, %.0f%%, %.0f%%, %@)", hsl.0, hsl.1 * 100, hsl.2 * 100, a)
        }
    }

    var recentColors: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: self.key) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }

    func addColor(_ color: NSColor) {
        let format = SettingsManager.shared.colorFormat
        let formatted = self.formattedColorString(for: color, format: format)
        var updated = [formatted] + self.recentColors.filter { $0 != formatted }
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
                    ForEach(Array(self.colorHistory.recentColors.prefix(20).enumerated()), id: \.offset) { _, string in
                        let displayString = string
                        let color: NSColor = {
                            if string.hasPrefix("#") {
                                return NSColor(hex: string) ?? .clear
                            } else if string.starts(with: "rgb") || string.starts(with: "rgba") {
                                return NSColor.fromRGBString(string) ?? .clear
                            } else if string.starts(with: "hsl") || string.starts(with: "hsla") {
                                return NSColor.fromHSLString(string) ?? .clear
                            } else {
                                return .clear
                            }
                        }()

                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color(color))
                                .frame(width: 30, height: 30)

                            Text(displayString)
                                .font(.body)
                                .foregroundColor(.primary)

                            Spacer()

                            Button(action: {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(displayString, forType: .string)

                                showSuccessToast("Copied \(displayString) to clipboard", icon: Image(systemName: "eyedropper"))
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

extension NSColor {
    static func fromRGBString(_ string: String) -> NSColor? {
        let pattern = #"rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)"#
        let regex = try? NSRegularExpression(pattern: pattern)
        guard let match = regex?.firstMatch(in: string, range: NSRange(string.startIndex..., in: string)),
              let r = Range(match.range(at: 1), in: string),
              let g = Range(match.range(at: 2), in: string),
              let b = Range(match.range(at: 3), in: string)
        else {
            return nil
        }

        let red = CGFloat(Int(string[r]) ?? 0) / 255.0
        let green = CGFloat(Int(string[g]) ?? 0) / 255.0
        let blue = CGFloat(Int(string[b]) ?? 0) / 255.0
        let alpha: CGFloat = {
            if let aRange = Range(match.range(at: 4), in: string),
               let a = Double(string[aRange])
            {
                return CGFloat(a)
            }
            return 1.0
        }()

        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
    }

    static func fromHSLString(_ string: String) -> NSColor? {
        let pattern = #"hsla?\((\d+),\s*(\d+)%?,\s*(\d+)%?(?:,\s*([\d.]+))?\)"#
        let regex = try? NSRegularExpression(pattern: pattern)
        guard let match = regex?.firstMatch(in: string, range: NSRange(string.startIndex..., in: string)),
              let hRange = Range(match.range(at: 1), in: string),
              let sRange = Range(match.range(at: 2), in: string),
              let lRange = Range(match.range(at: 3), in: string)
        else {
            return nil
        }

        let h = Double(string[hRange]) ?? 0
        let s = (Double(string[sRange]) ?? 0) / 100.0
        let l = (Double(string[lRange]) ?? 0) / 100.0
        let a: CGFloat = {
            if let aRange = Range(match.range(at: 4), in: string),
               let alpha = Double(string[aRange])
            {
                return CGFloat(alpha)
            }
            return 1.0
        }()

        return NSColor(hue: CGFloat(h / 360.0), saturation: CGFloat(s), brightness: CGFloat(l), alpha: a)
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
