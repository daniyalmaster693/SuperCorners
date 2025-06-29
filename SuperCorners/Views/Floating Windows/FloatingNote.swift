//
//  FloatingNote.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-25.
//

import AppKit
import SwiftUI

struct FloatingNoteContentView: View {
    @AppStorage("floatingNoteMessage") private var textInput: String = ""

    var wordCount: Int {
        self.textInput.split { $0.isWhitespace || $0.isNewline }.count
    }

    var characterCount: Int {
        self.textInput.count
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if self.textInput.isEmpty {
                Text("Click to Start Writing...")
                    .foregroundColor(Color.gray.opacity(0.6))
                    .padding(.top, 12)
                    .padding(.leading, 5)
            }

            VStack(spacing: 0) {
                ScrollView {
                    TextEditor(text: self.$textInput)
                        .font(.system(size: 14))
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                }

                HStack {
                    Text("Words: \(self.wordCount)")
                    Spacer()
                    Text("Characters: \(self.characterCount)")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
        }
        .frame(width: 300, height: 200)
    }
}

class FloatingNotePanel: NSPanel {
    private var hostingView: NSHostingView<FloatingNoteContentView>
    
    init() {
        self.hostingView = NSHostingView(rootView: FloatingNoteContentView())
        
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 375, height: 230),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )
        
        self.minSize = NSSize(width: 375, height: 230)
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

struct FloatingNotePanelView: View {
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
            
            Button("Update Message") {
                let newMessage = "Updated message at \(Date())"
                self.message = newMessage
                self.floatingPanel?.updateMessage(newMessage)
            }
        }
    }
}
