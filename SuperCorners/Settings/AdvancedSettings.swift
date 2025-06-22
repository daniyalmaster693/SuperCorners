//
//  AdvancedSettings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @AppStorage("iCloudSyncEnabled") private var iCloudSyncEnabled = false
    @State private var showResetConfirmation = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Advanced")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            Form {
                Section {
                    Toggle(isOn: $iCloudSyncEnabled) {
                        HStack {
                            Image(systemName: "icloud.fill")
                                .foregroundColor(.secondary)
                            Text("Enable iCloud Sync")
                        }
                    }
                }

                Section {
                    HStack {
                        Label("Scripts Location", systemImage: "folder")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Choose Location") {
                            let panel = NSOpenPanel()
                            panel.title = "Select a Folder"
                            panel.showsHiddenFiles = false
                            panel.canChooseFiles = false
                            panel.canChooseDirectories = true
                            panel.allowsMultipleSelection = false

                            if panel.runModal() == .OK {
                                if let url = panel.url {
                                    print("Selected folder: \(url.path)")
                                    // TODO: Store or use the folder URL
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Section {
                    HStack {
                        Label("Import Configuration", systemImage: "square.and.arrow.down")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Import") {
                            let panel = NSOpenPanel()
                            panel.title = "Select a Folder"
                            panel.showsHiddenFiles = false
                            panel.canChooseFiles = false
                            panel.canChooseDirectories = true
                            panel.allowsMultipleSelection = false

                            if panel.runModal() == .OK {
                                if let url = panel.url {
                                    print("Selected folder: \(url.path)")
                                    // TODO: Store or use the folder URL
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                    }

                    HStack {
                        Label("Export Configuration", systemImage: "square.and.arrow.up")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Export") {
                            // Add Action
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Section {
                    HStack {
                        Label("Reset all Settings", systemImage: "exclamationmark.triangle")
                            .foregroundColor(.primary)
                        Spacer()

                        Button("Reset to Defaults") {
                            showResetConfirmation = true
                        }
                    }
                    .confirmationDialog("Are you sure you want to reset all settings to defaults?",
                                        isPresented: $showResetConfirmation,
                                        titleVisibility: .visible)
                    {
                        Button("Reset", role: .destructive) {
                            // TODO: Add reset logic here
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
            .formStyle(.grouped)
            .frame(maxWidth: 700)
        }
    }
}
