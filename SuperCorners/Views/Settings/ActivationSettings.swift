//
//  ActivationSettings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import KeyboardShortcuts
import SwiftUI

struct ActivationSettingsView: View {
    // Enabled corners toggles
    @AppStorage("enableTopLeftCorner") private var enableTopLeftCorner = true
    @AppStorage("enableTopRightCorner") private var enableTopRightCorner = true
    @AppStorage("enableBottomLeftCorner") private var enableBottomLeftCorner = true
    @AppStorage("enableBottomRightCorner") private var enableBottomRightCorner = true

    // Enabled zones toggles
    @AppStorage("enableTopZone") private var enableTopZone = true
    @AppStorage("enableLeftZone") private var enableLeftZone = true
    @AppStorage("enableRightZone") private var enableRightZone = true
    @AppStorage("enableBottomZone") private var enableBottomZone = true

    // Modifier Key Picker

    @AppStorage("selectedModifierKey") private var selectedModifier: ModifierKey = .command

    enum ModifierKey: String, CaseIterable, Identifiable {
        case command = "Command"
        case option = "Option"
        case control = "Control"
        case shift = "Shift"
        case none = "None"

        var id: String { rawValue }
    }

    // Ignored applications list
    @State private var ignoredApps: [String] = []
    @State private var showIgnoredAppsModal = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Activation")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            Form {
                Section {
                    HStack {
                        Label("Activation Modifier", systemImage: "square.grid.2x2")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: $selectedModifier) {
                            ForEach(ModifierKey.allCases) { key in
                                Text(key.rawValue).tag(key)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 150)
                    }

                    HStack {
                        Label("Activation Shortcut", systemImage: "rectangle.leftthird.inset.filled")
                            .foregroundColor(.primary)
                        Spacer()
                        KeyboardShortcuts.Recorder(for: .cornerActivation)
                            .frame(width: 130)
                    }
                }

                Section {
                    HStack {
                        Label("Ignored Applications", systemImage: "rectangle.slash")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Configure") {
                            showIgnoredAppsModal = true
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Section(header: Text("Enabled Corners")) {
                    Toggle(isOn: $enableTopLeftCorner) {
                        HStack {
                            Image(systemName: "inset.filled.topleft.rectangle")
                                .foregroundColor(.secondary)
                            Text("Top Left Corner")
                        }
                    }
                    Toggle(isOn: $enableTopRightCorner) {
                        HStack {
                            Image(systemName: "inset.filled.topright.rectangle")
                                .foregroundColor(.secondary)
                            Text("Top Right Corner")
                        }
                    }
                    Toggle(isOn: $enableBottomLeftCorner) {
                        HStack {
                            Image(systemName: "inset.filled.bottomleft.rectangle")
                                .foregroundColor(.secondary)
                            Text("Bottom Left Corner")
                        }
                    }
                    Toggle(isOn: $enableBottomRightCorner) {
                        HStack {
                            Image(systemName: "inset.filled.bottomright.rectangle")
                                .foregroundColor(.secondary)
                            Text("Bottom Right Corner")
                        }
                    }
                }

                Section(header: Text("Enabled Zones")) {
                    Toggle(isOn: $enableTopZone) {
                        HStack {
                            Image(systemName: "rectangle.topthird.inset.filled")
                                .foregroundColor(.secondary)
                            Text("Top Zone")
                        }
                    }
                    Toggle(isOn: $enableLeftZone) {
                        HStack {
                            Image(systemName: "rectangle.leadingthird.inset.filled")
                                .foregroundColor(.secondary)
                            Text("Left Zone")
                        }
                    }
                    Toggle(isOn: $enableRightZone) {
                        HStack {
                            Image(systemName: "rectangle.trailingthird.inset.filled")
                                .foregroundColor(.secondary)
                            Text("Right Zone")
                        }
                    }
                    Toggle(isOn: $enableBottomZone) {
                        HStack {
                            Image(systemName: "rectangle.bottomthird.inset.filled")
                                .foregroundColor(.secondary)
                            Text("Bottom Zone")
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .frame(maxWidth: 700)
        }
        .sheet(isPresented: $showIgnoredAppsModal) {
            IgnoredApplicationsView()
        }
    }
}
