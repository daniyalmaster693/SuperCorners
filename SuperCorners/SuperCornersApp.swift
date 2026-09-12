//
//  SuperCornersApp.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

enum SelectedTab: String {
    case corners
    case zones
    case actions
    case settings
}

@main
struct SuperCornersApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let updateManager = UpdateManager()

    @ObservedObject private var actionSetManager = ActionSetManager.shared

    @Environment(\.openWindow) private var openWindow
    @State private var selectedTab: SelectedTab = .corners

    // Settings Variables

    @AppStorage("showInDock") private var showInDock = true
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true

    // Request Accessibility Permission

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
            ActivationManager.shared.start()
        }
    }

    func updateActivationPolicy() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    var body: some Scene {
        WindowGroup(id: "main") {
            if #available(macOS 15.0, *) {
                ContentView(selectedTab: $selectedTab)
                    .containerBackground(.thickMaterial, for: .window)
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                    .onAppear {
                        updateActivationPolicy()
                    }
            } else {
                ContentView(selectedTab: $selectedTab)
                    .onAppear {
                        updateActivationPolicy()
                    }
            }
        }

        MenuBarExtra("Menu", systemImage: "rectangle.3.group", isInserted: $showMenuBarExtra) {
            let currentSet = actionSetManager.findActionSets(
                bundleID: NSWorkspace.shared.frontmostApplication?.bundleIdentifier
            ).first

            VStack {
                if let currentSet {
                    let topLeftTitle = titleForCorner(.topLeft, currentSet: currentSet)
                    let topRightTitle = titleForCorner(.topRight, currentSet: currentSet)
                    let bottomLeftTitle = titleForCorner(.bottomLeft, currentSet: currentSet)
                    let bottomRightTitle = titleForCorner(.bottomRight, currentSet: currentSet)

                    let topTitle = titleForCorner(.top, currentSet: currentSet)
                    let leftTitle = titleForCorner(.left, currentSet: currentSet)
                    let rightTitle = titleForCorner(.right, currentSet: currentSet)
                    let bottomTitle = titleForCorner(.bottom, currentSet: currentSet)

                    Menu("Corners") {
                        Button {
                            triggerCornerAction(for: .topLeft, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.topleft.rectangle")
                                Text(topLeftTitle)
                            }
                        }

                        Button {
                            triggerCornerAction(for: .topRight, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.topright.rectangle")
                                Text(topRightTitle)
                            }
                        }

                        Button {
                            triggerCornerAction(for: .bottomLeft, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.bottomleft.rectangle")
                                Text(bottomLeftTitle)
                            }
                        }

                        Button {
                            triggerCornerAction(for: .bottomRight, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "inset.filled.bottomright.rectangle")
                                Text(bottomRightTitle)
                            }
                        }
                    }

                    Menu("Zones") {
                        Button {
                            triggerCornerAction(for: .top, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.topthird.inset.filled")
                                Text(topTitle)
                            }
                        }

                        Button {
                            triggerCornerAction(for: .left, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.leadingthird.inset.filled")
                                Text(leftTitle)
                            }
                        }

                        Button {
                            triggerCornerAction(for: .right, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.trailingthird.inset.filled")
                                Text(rightTitle)
                            }
                        }

                        Button {
                            triggerCornerAction(for: .bottom, actionSet: currentSet)
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.bottomthird.inset.filled")
                                Text(bottomTitle)
                            }
                        }
                    }

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

                    Divider()

                    Button("Preferences") {
                        NSApp.setActivationPolicy(.regular)
                        NSApp.activate(ignoringOtherApps: true)

                        selectedTab = .settings
                    }
                    .keyboardShortcut(",")

                    Button("Check for Updates") {
                        updateManager.getUpdateData(manualCheck: true)
                    }
                    .keyboardShortcut("u")

                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                    .keyboardShortcut("q")
                }
            }
        }

        .commands {
            CommandGroup(after: .appInfo) {
                Button {
                    selectedTab = .settings
                } label: {
                    Label("Preferences", systemImage: "gear")
                }
                .keyboardShortcut(",")

                Button {
                    updateManager.getUpdateData(manualCheck: true)
                } label: {
                    Label("Check for Updates", systemImage: "gear.badge")
                }
            }

            CommandGroup(after: .sidebar) {
                Button {
                    selectedTab = .corners
                } label: {
                    Label("Corners", systemImage: "square.grid.2x2")
                }
                .keyboardShortcut("1")

                Button {
                    selectedTab = .zones
                } label: {
                    Label("Zones", systemImage: "rectangle.leftthird.inset.filled")
                }
                .keyboardShortcut("2")

                Button {
                    selectedTab = .actions
                } label: {
                    Label("Actions", systemImage: "bolt.circle")
                }
                .keyboardShortcut("3")
            }

            CommandGroup(replacing: .help) {
                Button("SuperCorners Help") {
                    if let url = URL(string: "https://github.com/daniyalmaster693/SuperCorners/blob/main/GettingStarted.md") {
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
            }
        }
    }
}
