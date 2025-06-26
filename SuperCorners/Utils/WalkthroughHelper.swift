//
//  FloatingViewHelpers.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-26.
//

import SwiftUI

func showWalkthrough() {
    let walkthroughWindow = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 750, height: 425),
        styleMask: [.titled, .closable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    )
    
    // Transparency Effects
    
    let visualEffectView = NSVisualEffectView(frame: walkthroughWindow.contentView!.bounds)
    visualEffectView.autoresizingMask = [.width, .height]
    visualEffectView.blendingMode = .behindWindow
    visualEffectView.state = .active
    visualEffectView.material = .underWindowBackground
    
    let hostingView = NSHostingView(rootView: WalkthroughView())
    hostingView.frame = walkthroughWindow.contentView!.bounds
    hostingView.autoresizingMask = [.width, .height]
    walkthroughWindow.contentView?.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
    walkthroughWindow.contentView?.addSubview(hostingView)
    
    // Window Details
    
    walkthroughWindow.center()
    walkthroughWindow.titleVisibility = .hidden
    walkthroughWindow.titlebarAppearsTransparent = true
    walkthroughWindow.isMovableByWindowBackground = true
    
    walkthroughWindow.makeKeyAndOrderFront(nil)
    walkthroughWindow.isReleasedWhenClosed = false
    NSApp.activate(ignoringOtherApps: true)
}

