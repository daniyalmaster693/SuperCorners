//
//  ActivationSettings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import KeyboardShortcuts
import SwiftUI

struct ActivationSettingsView: View {
    // Modifier Key Picker

    @AppStorage("enableModifierKey") private var enableModifierKey = false
    @AppStorage("enableCornerHover") private var enableCornerHover = true
    @AppStorage("enableCornerClick") private var enableCornerClick = false
    @AppStorage("selectedModifierKey") private var selectedModifier: ModifierKey = .command
    @AppStorage("delayTimer") private var delayTimer: Double = 0.0

    enum ModifierKey: String, CaseIterable, Identifiable {
        case command = "Command"
        case option = "Option"
        case control = "Control"
        case shift = "Shift"
        case capsLock = "Caps Lock"

        var id: String { rawValue }
    }

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

    var body: some View {
        VStack(spacing: 8) {
            Text("Activation")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            Form {
                Section {
                    Toggle(isOn: $enableModifierKey) {
                        HStack {
                            Image(systemName: "command")
                                .foregroundColor(.secondary)
                            Text("Modifier Key")
                        }
                    }

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
                        .disabled(!enableModifierKey)
                        .frame(width: 150)
                    }
                }

                Section {
                    HStack {
                        Label("Activation Shortcut", systemImage: "rectangle.leftthird.inset.filled")
                            .foregroundColor(.primary)
                        Spacer()
                        KeyboardShortcuts.Recorder(for: .cornerActivation)
                            .frame(width: 130)
                    }
                }

                Section {
                    Toggle(isOn: Binding(
                        get: { enableCornerHover },
                        set: { newValue in
                            enableCornerHover = newValue
                            if newValue { enableCornerClick = false }
                        }
                    )) {
                        HStack {
                            Image(systemName: "hand.point.up.left")
                                .foregroundColor(.secondary)
                            Text("Trigger Actions on Corner Hover")
                        }
                    }

                    Toggle(isOn: Binding(
                        get: { enableCornerClick },
                        set: { newValue in
                            enableCornerClick = newValue
                            if newValue { enableCornerHover = false }
                        }
                    )) {
                        HStack {
                            Image(systemName: "hand.tap")
                                .foregroundColor(.secondary)
                            Text("Trigger Actions on Corner Click")
                        }
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.secondary)
                            Text("Action Delay Timer: \(String(format: "%.1f", self.delayTimer))")

                            Slider(value: self.$delayTimer, in: 0 ... 5.0, step: 0.5)
                        }
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
    }
}
