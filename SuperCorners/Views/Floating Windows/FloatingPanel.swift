//
//  FloatingPanel.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-24.
//

import AppKit
import SwiftUI

struct FloatingPanelContentView: View {
    var message: String

    var body: some View {
        ScrollView {
            Text(self.message)
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 300, height: 200)
    }
}

class FloatingPanel: NSPanel {
    private var hostingView: NSHostingView<FloatingPanelContentView>
    
    init(initialMessage: String) {
        self.hostingView = NSHostingView(rootView: FloatingPanelContentView(message: initialMessage))
        
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 375, height: 230),
            styleMask: [.nonactivatingPanel, .titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
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
    
    func updateMessage(_ newMessage: String) {
        self.hostingView.rootView = FloatingPanelContentView(message: newMessage)
    }
       
    func show() {
        self.makeKeyAndOrderFront(nil)
           
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            self.animator().alphaValue = 1
        }
    }
}

struct FloatingPanelView: View {
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
