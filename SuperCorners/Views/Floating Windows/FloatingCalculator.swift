//
//  FloatingCalculator.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-28.
//

import AppKit
import SoulverCore
import SwiftUI

struct FloatingCalculatorContentView: View {
    @AppStorage("floatingCalculatorMessage") private var calculatorInput: String = ""
    
    let calculator = Calculator(customization: .standard)
       
    var result: String {
        let cleanedInput = self.calculatorInput.replacingOccurrences(of: "=", with: "")
        return self.calculator.calculate(cleanedInput).stringValue
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if self.calculatorInput.isEmpty {
                Text("Use the = sign to calculate")
                    .foregroundColor(Color.gray.opacity(0.6))
                    .padding(.leading, 5)
            }

            HSplitView {
                ScrollView {
                    TextEditor(text: self.$calculatorInput)
                        .font(.system(size: 14))
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(minWidth: 240, alignment: .leading)
                        .padding(.trailing, 15)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(self.calculatorInput.components(separatedBy: .newlines), id: \.self) { line in
                            if line.contains("=") {
                                let cleaned = line.replacingOccurrences(of: "=", with: "")
                                let output = self.calculator.calculate(cleaned).stringValue
                                TextEditor(text: .constant(output))
                                    .font(.system(size: 14))
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(.leading, 8)
                    .frame(minWidth: 140, alignment: .leading)
                }
            }
            .frame(minHeight: 200)
        }
        .padding()
        .frame(minWidth: 425, minHeight: 260)
    }
}

class FloatingCalculatorPanel: NSPanel {
    private var hostingView: NSHostingView<FloatingCalculatorContentView>
    
    init() {
        self.hostingView = NSHostingView(rootView: FloatingCalculatorContentView())
        
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 425, height: 260),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )
        
        self.minSize = NSSize(width: 425, height: 260)
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

struct FloatingCalculatorPanelView: View {
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
