//
//  FloatingColorConverter.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-07-19.
//

import AppKit
import SwiftUI

struct FloatingColorContentView: View {
    @State private var inputColor: String = ""
    @State private var selectedFormat: ColorFormat = .hex

    var body: some View {
        VStack {
            VSplitView {
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        if self.inputColor.isEmpty {
                            Text("Enter a Color Code...")
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(.leading, 5)
                        }

                        TextEditor(text: self.$inputColor)
                            .font(.system(size: 14))
                            .padding(.bottom, 12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Color Format", selection: self.$selectedFormat) {
                            ForEach(ColorFormat.allCases, id: \.self) { colorFormat in
                                Text(colorFormat.displayName).tag(colorFormat)
                            }
                        }
                        .pickerStyle(PopUpButtonPickerStyle())
                        .frame(width: 200)
                        .padding(.leading, 5)
                        .padding(.top, 12)

                        TextEditor(text: .constant(self.convertedColor(self.inputColor, using: self.selectedFormat)))
                            .font(.system(size: 14))
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
            }
            .frame(minHeight: 200)
        }
        .padding()
        .frame(minWidth: 425, minHeight: 260)
    }

    func convertedColor(_ input: String, using format: ColorFormat) -> String {
        func parseHex(_ str: String) -> (r: Int, g: Int, b: Int, a: Double)? {
            let hex = str.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "#", with: "")
            guard hex.count == 6 || hex.count == 8 else { return nil }
            var rgb: UInt64 = 0
            guard Scanner(string: hex).scanHexInt64(&rgb) else { return nil }
            let r = Int((rgb >> (hex.count == 8 ? 24 : 16)) & 0xFF)
            let g = Int((rgb >> (hex.count == 8 ? 16 : 8)) & 0xFF)
            let b = Int((rgb >> (hex.count == 8 ? 8 : 0)) & 0xFF)
            let a = hex.count == 8 ? Double(rgb & 0xFF)/255.0 : 1.0
            return (r, g, b, a)
        }

        func rgbToHSL(r: Int, g: Int, b: Int) -> (h: Int, s: Int, l: Int) {
            let rf = Double(r)/255.0, gf = Double(g)/255.0, bf = Double(b)/255.0
            let maxVal = max(rf, max(gf, bf))
            let minVal = min(rf, min(gf, bf))
            let l = (maxVal + minVal)/2
            var h = 0.0, s = 0.0
            if maxVal != minVal {
                let d = maxVal - minVal
                s = l > 0.5 ? d/(2.0 - maxVal - minVal) : d/(maxVal + minVal)
                if maxVal == rf {
                    h = (gf - bf)/d + (gf < bf ? 6 : 0)
                } else if maxVal == gf {
                    h = (bf - rf)/d + 2
                } else {
                    h = (rf - gf)/d + 4
                }
                h /= 6
            }
            return (Int(round(h*360)), Int(round(s*100)), Int(round(l*100)))
        }

        guard let (r, g, b, a) = parseHex(input) else {
            return ""
        }

        switch format {
        case .hex:
            return String(format: "#%02X%02X%02X", r, g, b)
        case .rgb:
            return "rgb(\(r), \(g), \(b))"
        case .rgba:
            let alphaStr = String(format: "%.2f", a)
            return "rgba(\(r), \(g), \(b), \(alphaStr))"
        case .hsl, .hsla:
            let (h, s, l) = rgbToHSL(r: r, g: g, b: b)
            if format == .hsl {
                return "hsl(\(h), \(s)%, \(l)%)"
            } else {
                let alphaStr = String(format: "%.2f", a)
                return "hsla(\(h), \(s)%, \(l)%, \(alphaStr))"
            }
        }
    }
}

enum ColorFormat: String, CaseIterable {
    case hex
    case rgb
    case rgba
    case hsl
    case hsla

    var displayName: String {
        switch self {
        case .hex: return "Hex"
        case .rgb: return "RGB"
        case .rgba: return "RGBA"
        case .hsl: return "HSL"
        case .hsla: return "HSLA"
        }
    }
}

class FloatingColorPanel: NSPanel {
    private var hostingView: NSHostingView<FloatingColorContentView>

    init() {
        self.hostingView = NSHostingView(rootView: FloatingColorContentView())

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 425, height: 280),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )

        self.minSize = NSSize(width: 425, height: 280)
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

struct FloatingColorPanelView: View {
    @State private var floatingPanel: FloatingPanel?
    @State private var message: String = "Initial message"

    var body: some View {
        VStack {
            Button("Toggle Floating Panel") {
                if self.floatingPanel == nil {
                    let panel = FloatingPanel(initialMessage: message)
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
