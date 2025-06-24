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
