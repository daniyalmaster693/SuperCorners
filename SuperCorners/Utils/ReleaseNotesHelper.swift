//
//  ReleaseNotesHelper.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-26.
//

import SwiftUI

func showReleaseNotes() {
    let releaseNotesWindow = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 750, height: 425),
        styleMask: [.titled, .closable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    )
    
    // Transparency Effects
    
    let visualEffectView = NSVisualEffectView(frame: releaseNotesWindow.contentView!.bounds)
    visualEffectView.autoresizingMask = [.width, .height]
    visualEffectView.material = .sidebar
    visualEffectView.state = .active
    visualEffectView.blendingMode = .behindWindow
    
    let hostingView = NSHostingView(rootView: NewFeaturesView())
    hostingView.frame = releaseNotesWindow.contentView!.bounds
    hostingView.autoresizingMask = [.width, .height]
    releaseNotesWindow.contentView?.addSubview(visualEffectView, positioned: .below, relativeTo: nil)
    releaseNotesWindow.contentView?.addSubview(hostingView)
    
    // Window Details
    
    releaseNotesWindow.center()
    releaseNotesWindow.titleVisibility = .hidden
    releaseNotesWindow.titlebarAppearsTransparent = true
    releaseNotesWindow.isMovableByWindowBackground = true
    
    releaseNotesWindow.makeKeyAndOrderFront(nil)
    releaseNotesWindow.isReleasedWhenClosed = false
    NSApp.activate(ignoringOtherApps: true)
}
 
