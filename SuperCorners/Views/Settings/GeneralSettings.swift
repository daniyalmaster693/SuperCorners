//
//  GeneralSettingsView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import LaunchAtLogin
import Sparkle
import SwiftUI

struct GeneralSettingsView: View {
    let updater: SPUUpdater
    @StateObject private var updateViewModel: CheckForUpdatesViewModel

    final class CheckForUpdatesViewModel: ObservableObject {
        @Published var canCheckForUpdates = false

        init(updater: SPUUpdater) {
            updater.publisher(for: \.canCheckForUpdates)
                .assign(to: &$canCheckForUpdates)
        }
    }

    init(updater: SPUUpdater) {
        self.updater = updater
        _updateViewModel = StateObject(
            wrappedValue: CheckForUpdatesViewModel(updater: updater))
    }

    @AppStorage("showInDock") private var showInDock = true
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("showCorners") private var showCorners = true
    @AppStorage("showZones") private var showZones = true
    @AppStorage("showFavorites") private var showFavorites = true

    var body: some View {
        VStack(spacing: 4) {
            Text("General")
                .font(.title2)
                .bold()

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
                    HStack {
                        Label("Updates", systemImage: "arrow.2.circlepath")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Check for Updates") {
                            updater.checkForUpdates()
                        }
                        .buttonStyle(.bordered)
                        .disabled(!updateViewModel.canCheckForUpdates)
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
