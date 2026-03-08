//
//  SuperCornersApp.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

@main
struct SuperCornersApp: App {
    // Settings Variables
    
    @AppStorage("showInDock") private var showInDock = true
    
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("showCorners") private var showCorners = true
    @AppStorage("showZones") private var showZones = true
    @AppStorage("showFavorites") private var showFavorites = true

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
        if !AXIsProcessTrusted() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let alert = NSAlert()
                alert.messageText = "Accessibility Permission Required"
                alert.informativeText = "SuperCorners needs accessibility access to function correctly. Please enable it in System Settings > Privacy & Security > Accessibility."
                alert.addButton(withTitle: "Open Settings")
                alert.addButton(withTitle: "Cancel")
                let response = alert.runModal()
                if response == .alertFirstButtonReturn {
                    if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            activateCornerHotkey()
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
                    .containerBackground(.thickMaterial, for: .window)
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
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
                let topLeftTitle = titleForCorner(.topLeft)
                let topRightTitle = titleForCorner(.topRight)
                let bottomLeftTitle = titleForCorner(.bottomLeft)
                let bottomRightTitle = titleForCorner(.bottomRight)
                
                let topTitle = titleForCorner(.top)
                let leftTitle = titleForCorner(.left)
                let rightTitle = titleForCorner(.right)
                let bottomTitle = titleForCorner(.bottom)
                
                if showCorners {
                    Menu("Corners") {
                        if enableTopLeftCorner {
                            Button {
                                triggerCornerAction(for: .topLeft)
                            } label: {
                                HStack {
                                    Image(systemName: "inset.filled.topleft.rectangle")
                                    Text(topLeftTitle)
                                }
                            }
                        }
                        
                        if enableTopRightCorner {
                            Button {
                                triggerCornerAction(for: .topRight)
                            } label: {
                                HStack {
                                    Image(systemName: "inset.filled.topright.rectangle")
                                    Text(topRightTitle)
                                }
                            }
                        }
                        
                        if enableBottomLeftCorner {
                            Button {
                                triggerCornerAction(for: .bottomLeft)
                            } label: {
                                HStack {
                                    Image(systemName: "inset.filled.bottomleft.rectangle")
                                    Text(bottomLeftTitle)
                                }
                            }
                        }
                        
                        if enableBottomRightCorner {
                            Button {
                                triggerCornerAction(for: .bottomRight)
                            } label: {
                                HStack {
                                    Image(systemName: "inset.filled.bottomright.rectangle")
                                    Text(bottomRightTitle)
                                }
                            }
                        }
                    }
                }

                if showZones {
                    Menu("Zones") {
                        if enableTopZone {
                            Button {
                                triggerCornerAction(for: .top)
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.topthird.inset.filled")
                                    Text(topTitle)
                                }
                            }
                        }
                        
                        if enableLeftZone {
                            Button {
                                triggerCornerAction(for: .left)
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.leadingthird.inset.filled")
                                    Text(leftTitle)
                                }
                            }
                        }
                        
                        if enableRightZone {
                            Button {
                                triggerCornerAction(for: .right)
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.trailingthird.inset.filled")
                                    Text(rightTitle)
                                }
                            }
                        }
                        
                        if enableBottomZone {
                            Button {
                                triggerCornerAction(for: .bottom)
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.bottomthird.inset.filled")
                                    Text(bottomTitle)
                                }
                            }
                        }
                    }
                }
                
                if showFavorites {
                    Menu("Favorites") {
                        if favoriteActions.isEmpty {
                            Text("No Actions Favorited")
                                .foregroundColor(.secondary)
                                .padding(.vertical, 8)
                        } else {
                            let sortedActions = favoriteActions.values.sorted { $0.id < $1.id }
                            
                            ForEach(sortedActions, id: \.id) { action in
                                Button {
                                    action.perform(nil)
                                } label: {
                                    HStack {
                                        Image(systemName: action.iconName)
                                        Text(action.title)
                                    }
                                }
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

        .commands {
            CommandGroup(replacing: .help) {
                Button("Website") {
                    if let url = URL(string: "https://supercorners.vercel.app") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Button("Repository") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/SuperCorners") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Divider()
                
                Button("Feedback") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/SuperCorners/issues/new") {
                        NSWorkspace.shared.open(url)
                    }
                }
                
                Button("Changelog") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/SuperCorners/releases") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
    }
}
