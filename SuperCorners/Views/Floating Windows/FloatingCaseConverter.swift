//
//  FloatingCaseConverter.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-07-19.
//

import AppKit
import SwiftUI

struct FloatingCaseContentView: View {
    @State private var inputText: String = ""
    @State private var selectedCase: TextCase = .lower

    var body: some View {
        VStack {
            VSplitView {
                ScrollView {
                    ZStack(alignment: .topLeading) {
                        if self.inputText.isEmpty {
                            Text("Click to Start Writing...")
                                .foregroundColor(Color.gray.opacity(0.6))
                                .padding(.leading, 5)
                        }

                        TextEditor(text: self.$inputText)
                            .font(.system(size: 14))
                            .padding(.bottom, 12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Text Case", selection: self.$selectedCase) {
                            ForEach(TextCase.allCases, id: \.self) { textCase in
                                Text(textCase.displayName).tag(textCase)
                            }
                        }
                        .pickerStyle(PopUpButtonPickerStyle())
                        .frame(width: 200)
                        .padding(.leading, 5)
                        .padding(.top, 12)

                        TextEditor(text: .constant(self.convertedText(self.inputText, using: self.selectedCase)))
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

    func convertedText(_ text: String, using style: TextCase) -> String {
        func words(from text: String) -> [String] {
            let separators = CharacterSet.alphanumerics.inverted
            return text
                .components(separatedBy: separators)
                .filter { !$0.isEmpty }
        }

        let w = words(from: text)

        switch style {
        case .camel:
            guard let first = w.first?.lowercased() else { return "" }
            return ([first] + w.dropFirst().map { $0.capitalized }).joined()
        case .capital:
            return text.uppercased()
        case .constant:
            return w.map { $0.uppercased() }.joined(separator: "_")
        case .dot:
            return w.map { $0.lowercased() }.joined(separator: ".")
        case .header:
            return w.map { $0.capitalized }.joined(separator: "-")
        case .kebab:
            return w.map { $0.lowercased() }.joined(separator: "-")
        case .lower:
            return text.lowercased()
        case .noCase:
            return w.joined()
        case .pascal:
            return w.map { $0.capitalized }.joined()
        case .sentence:
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return text }
            let first = trimmed.prefix(1).capitalized
            let rest = trimmed.dropFirst().lowercased()
            return first + rest
        case .title:
            return w.map { $0.capitalized }.joined(separator: " ")
        case .upper:
            return text.uppercased()
        }
    }
}

enum TextCase: String, CaseIterable {
    case camel, capital, constant, dot, header, kebab, lower
    case noCase, pascal, sentence, title, upper

    var displayName: String {
        switch self {
        case .camel: return "Camel"
        case .capital: return "Capital"
        case .constant: return "Constant"
        case .dot: return "Dot"
        case .header: return "Header"
        case .kebab: return "Kebab"
        case .lower: return "Lower"
        case .noCase: return "No Case"
        case .pascal: return "Pascal"
        case .sentence: return "Sentence"
        case .title: return "Title"
        case .upper: return "Upper"
        }
    }
}

class FloatingCasePanel: NSPanel {
    private var hostingView: NSHostingView<FloatingCaseContentView>

    init() {
        self.hostingView = NSHostingView(rootView: FloatingCaseContentView())

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

struct FloatingCasePanelView: View {
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
