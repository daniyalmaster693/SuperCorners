//
//  GeneralSettingsView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import LaunchAtLogin
import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("showInDock") private var showInDock = true

    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("showCorners") private var showCorners = true
    @AppStorage("showZones") private var showZones = true
    @AppStorage("showFavorites") private var showFavorites = true

    var body: some View {
        VStack(spacing: 4) {
            Form {
                Section {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.secondary)
                        LaunchAtLogin.Toggle()
                    }

                    HStack {
                        Toggle(isOn: $showInDock) {
                            HStack {
                                Image(systemName: "dock.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Show in Dock")
                            }
                        }
                        .onChange(of: showInDock) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "showInDock")

                            if newValue {
                                NSApp.setActivationPolicy(.regular)
                            } else {
                                NSApp.setActivationPolicy(.accessory)
                            }
                        }
                    }
                }

                Section {
                    Toggle(isOn: $showMenuBarExtra) {
                        HStack {
                            Image(systemName: "menubar.rectangle")
                                .foregroundColor(.secondary)
                            Text("Show in Menu Bar")
                        }
                    }

                    Group {
                        Toggle(isOn: $showCorners) {
                            HStack {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.secondary)
                                Text("Show Corners in Menu Bar")
                            }
                        }

                        Toggle(isOn: $showZones) {
                            HStack {
                                Image(systemName: "rectangle.leftthird.inset.filled")
                                    .foregroundColor(.secondary)
                                Text("Show Zones in Menu Bar")
                            }
                        }

                        Toggle(isOn: $showFavorites) {
                            HStack {
                                Image(systemName: "star")
                                    .foregroundColor(.secondary)
                                Text("Show Favorites in Menu Bar")
                            }
                        }
                    }.disabled(!self.showMenuBarExtra)
                }
            }
        }
        .formStyle(.grouped)
    }
}
