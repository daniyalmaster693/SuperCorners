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
    // Settings Variables
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("showInDock") private var showInDock = true
    
    // Corner and Zone Variables
    
    @AppStorage("enableTopLeftCorner") var enableTopLeftCorner = true
    @AppStorage("enableTopRightCorner") var enableTopRightCorner = true
    @AppStorage("enableBottomLeftCorner") var enableBottomLeftCorner = true
    @AppStorage("enableBottomRightCorner") var enableBottomRightCorner = true

    @AppStorage("enableTopZone") var enableTopZone = true
    @AppStorage("enableLeftZone") var enableLeftZone = true
    @AppStorage("enableRightZone") var enableRightZone = true
    @AppStorage("enableBottomZone") var enableBottomZone = true
    
    // Menubar Variables
    
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
    
    func updateActivationPolicy() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if #available(macOS 15.0, *) {
                ContentView()
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                    .containerBackground(.ultraThickMaterial, for: .window)
                    .onAppear {
                        updateActivationPolicy()
                    }
            } else {
                ContentView()
                    .onAppear {
                        updateActivationPolicy()
                    }
            }
        }
        
        MenuBarExtra("Menu", systemImage: "rectangle.3.group", isInserted: $showMenuBarExtra) {
            VStack {
                let topLeftTitle = cornerActionBindings[.topLeft]?.title
                let topRightTitle = cornerActionBindings[.topRight]?.title
                let bottomLeftTitle = cornerActionBindings[.bottomLeft]?.title
                let bottomRightTitle = cornerActionBindings[.bottomRight]?.title
                
                let topTitle = cornerActionBindings[.top]?.title
                let leftTitle = cornerActionBindings[.left]?.title
                let rightTitle = cornerActionBindings[.right]?.title
                let bottomTitle = cornerActionBindings[.bottom]?.title

                Menu("Corners") {
                    if enableTopLeftCorner {
                        Button {
                            triggerCornerAction(for: .topLeft)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.topleft.rectangle")
                                Text(topLeftTitle ?? "Add Action")
                            }
                        }
                    }

                    if enableTopRightCorner {
                        Button {
                            triggerCornerAction(for: .topRight)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.topright.rectangle")
                                Text(topRightTitle ?? "Add Action")
                            }
                        }
                    }

                    if enableBottomLeftCorner {
                        Button {
                            triggerCornerAction(for: .bottomLeft)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.bottomleft.rectangle")
                                Text(bottomLeftTitle ?? "Add Action")
                            }
                        }
                    }

                    if enableBottomRightCorner {
                        Button {
                            triggerCornerAction(for: .bottomRight)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.bottomright.rectangle")
                                Text(bottomRightTitle ?? "Add Action")
                            }
                        }
                    }
                }

                Menu("Zones") {
                    if enableTopZone {
                        Button {
                            triggerCornerAction(for: .top)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.topthird.inset.filled")
                                Text(topTitle ?? "Add Action")
                            }
                        }
                    }

                    if enableLeftZone {
                        Button {
                            triggerCornerAction(for: .left)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.leadingthird.inset.filled")
                                Text(leftTitle ?? "Add Action")
                            }
                        }
                    }

                    if enableRightZone {
                        Button {
                            triggerCornerAction(for: .right)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.trailingthird.inset.filled")
                                Text(rightTitle ?? "Add Action")
                            }
                        }
                    }

                    if enableBottomZone {
                        Button {
                            triggerCornerAction(for: .bottom)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.bottomthird.inset.filled")
                                Text(bottomTitle ?? "Add Action")
                            }
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
            if #available(macOS 15.0, *) {
                SettingsView()
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                    .containerBackground(.ultraThickMaterial, for: .window)
            } else {
                SettingsView()
            }
        }
        
        .commands {
            CommandGroup(replacing: .help) {
                Button("SuperCorners Help") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/SuperCorners") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Divider()
                
                Button("Feedback") {
                    if let url = URL(string: "https://forms.gle/VdMdmpVyr1Cj4f6T8") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Button("Changelog") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/SuperCorners/blob/main/CHANGELOG.md") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Button("License") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/SuperCorners/blob/main/License") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
    }
}
