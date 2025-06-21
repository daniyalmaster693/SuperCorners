//
//  SuperCornersApp.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
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
    NSApp.activate(ignoringOtherApps: true)
}
 
@main
struct SuperCornersApp: App {
    // Menubar Refresh Variable
    
    @State private var refreshID = UUID()
    
    // Walkthrough
    
    init() {
        DispatchQueue.main.async {
            activateCornerHotkey()
        }
        
        let hasLaunchedBeforeKey = "hasLaunchedBefore"
        let userDefaults = UserDefaults.standard

        if !userDefaults.bool(forKey: hasLaunchedBeforeKey) {
            showWalkthrough()
            userDefaults.set(true, forKey: hasLaunchedBeforeKey)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        MenuBarExtra("Menu", systemImage: "rectangle.3.group") {
            VStack {
                let topLeftTitle = cornerActionBindings[.topLeft]?.title
                let topRightTitle = cornerActionBindings[.topRight]?.title
                let bottomLeftTitle = cornerActionBindings[.bottomLeft]?.title
                let bottomRightTitle = cornerActionBindings[.bottomRight]?.title
                
                Menu("Corners") {
                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "inset.filled.topleft.rectangle")
                            Text(topLeftTitle ?? "Add Action")
                        }
                    }

                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "inset.filled.topright.rectangle")
                            Text(topRightTitle ?? "Add Action")
                        }
                    }

                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "inset.filled.bottomleft.rectangle")
                            Text(bottomLeftTitle ?? "Add Action")
                        }
                    }

                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "inset.filled.bottomright.rectangle")
                            Text(bottomRightTitle ?? "Add Action")
                        }
                    }
                }

                Menu("Zones") {
                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.topthird.inset.filled")
                            Text("Top Zone")
                        }
                    }

                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.leadingthird.inset.filled")
                            Text("Left Zone")
                        }
                    }

                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.trailingthird.inset.filled")
                            Text("Right Zone")
                        }
                    }

                    Button {
                        // Action
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.bottomthird.inset.filled")
                            Text("Bottom Zone")
                        }
                    }
                }
            
                Divider()
            
                Button("Refresh") {
                    refreshID = UUID()
                }
                .keyboardShortcut("r")

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
            .id(refreshID)
        }

        Settings {
            SettingsView()
        }
    }
}
