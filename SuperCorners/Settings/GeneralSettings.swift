//
//  GeneralSettingsView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import LaunchAtLogin
import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("showMenuBarIcon") private var showMenuBarIcon = true
    @AppStorage("showInDock") private var showInDock = true

    var body: some View {
        VStack(spacing: 4) {
            Text("General")
                .font(.title2)
                .bold()

            Form {
                Section {
                    HStack {
                        Toggle(isOn: $showMenuBarIcon) {
                            HStack {
                                Image(systemName: "menubar.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Show in Menu Bar")
                            }
                        }
                    }
                }
                .padding(.bottom, 4)

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
            }
            .formStyle(.grouped)
        }
    }
}
