//
//  Settings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-19.
//

import KeyboardShortcuts
import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
    // Settings Variables

    @StateObject private var updateManager = UpdateManager()
    @AppStorage("showInDock") private var showInDock = true
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true

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

    // Enabled Triggers

    @AppStorage("enableTopLeftCorner") private var enableTopLeftCorner = true
    @AppStorage("enableTopRightCorner") private var enableTopRightCorner = true
    @AppStorage("enableBottomLeftCorner") private var enableBottomLeftCorner = true
    @AppStorage("enableBottomRightCorner") private var enableBottomRightCorner = true

    @AppStorage("enableTopZone") private var enableTopZone = true
    @AppStorage("enableLeftZone") private var enableLeftZone = true
    @AppStorage("enableRightZone") private var enableRightZone = true
    @AppStorage("enableBottomZone") private var enableBottomZone = true

    // Behavior Settings

    @AppStorage("cornerTriggerSensitivity") private var cornerTriggerSensitivity: Double = 7.0
    @AppStorage("zoneTriggerSensitivity") private var zoneTriggerSensitivity: Double = 7.0

    // Ignored applications list

    @State private var ignoredApps: [String] = []
    @State private var showIgnoredAppsModal = false

    @AppStorage("showToastNotifications") private var showToastNotification = true
    @AppStorage("dismissOnClick") private var dismissOnClick = true
    @AppStorage("autoDismissTimer") private var autoDismissTimer: DismissTimer = .seconds3

    enum DismissTimer: String, CaseIterable, Identifiable {
        case seconds2 = "2 Seconds"
        case seconds3 = "3 Seconds"
        case seconds4 = "4 Seconds"
        case seconds5 = "5 Seconds"
        case seconds10 = "10 Seconds"

        var id: String { self.rawValue }

        var duration: TimeInterval {
            switch self {
            case .seconds2: return 2
            case .seconds3: return 3
            case .seconds4: return 4
            case .seconds5: return 5
            case .seconds10: return 10
            }
        }
    }

    @AppStorage("playSoundEffect") private var playSoundEffect = false
    @AppStorage("selectedSoundEffect") private var selectedSound: SoundEffect = .purr

    enum SoundEffect: String, CaseIterable, Identifiable {
        case basso = "Basso"
        case blow = "Blow"
        case bottle = "Bottle"
        case frog = "Frog"
        case funk = "Funk"
        case glass = "Glass"
        case hero = "Hero"
        case morse = "Morse"
        case ping = "Ping"
        case pop = "Pop"
        case purr = "Purr"
        case sosumi = "Sosumi"
        case submarine = "Submarine"
        case tink = "Tink"

        var id: String { self.rawValue }

        func play() {
            NSSound(named: NSSound.Name(self.rawValue))?.play()
        }
    }

    // Action Settings

    @AppStorage("showRecentText") private var showRecentText = true

    @AppStorage("showRecentColors") private var showRecentColors = true
    @AppStorage("colorFormat") private var colorFormat: ColorFormat = .hex

    enum ColorFormat: String, CaseIterable, Identifiable {
        case hex = "Hex"
        case rgb = "RGB"
        case rgba = "RGBA"
        case hsl = "HSL"
        case hsla = "HSLA"

        var id: String { self.rawValue }
    }

    // Settings View

    var body: some View {
        ScrollView {
            Form {
                Section("General") {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.primary)
                        LaunchAtLogin.Toggle()
                    }

                    HStack {
                        Toggle(isOn: self.$showInDock) {
                            HStack {
                                Image(systemName: "dock.rectangle")
                                    .foregroundColor(.primary)
                                Text("Show in Dock")
                            }
                        }
                        .onChange(of: self.showInDock) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "showInDock")

                            if newValue {
                                NSApp.setActivationPolicy(.regular)
                            } else {
                                NSApp.setActivationPolicy(.accessory)
                            }
                        }
                    }

                    Toggle(isOn: self.$showMenuBarExtra) {
                        HStack {
                            Image(systemName: "menubar.rectangle")
                                .foregroundColor(.primary)
                            Text("Show in Menu Bar")
                        }
                    }

                    HStack {
                        Label("Updates", systemImage: "arrow.2.circlepath")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Check for Updates") {
                            self.updateManager.getUpdateData(manualCheck: true)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .formStyle(.grouped)

            Form {
                Section("Triggers") {
                    Toggle(isOn: self.$enableTopLeftCorner) {
                        HStack {
                            Image(systemName: "inset.filled.topleft.rectangle")
                                .foregroundColor(.primary)
                            Text("Top Left Corner")
                        }
                    }
                    Toggle(isOn: self.$enableTopRightCorner) {
                        HStack {
                            Image(systemName: "inset.filled.topright.rectangle")
                                .foregroundColor(.primary)
                            Text("Top Right Corner")
                        }
                    }
                    Toggle(isOn: self.$enableBottomLeftCorner) {
                        HStack {
                            Image(systemName: "inset.filled.bottomleft.rectangle")
                                .foregroundColor(.primary)
                            Text("Bottom Left Corner")
                        }
                    }
                    Toggle(isOn: self.$enableBottomRightCorner) {
                        HStack {
                            Image(systemName: "inset.filled.bottomright.rectangle")
                                .foregroundColor(.primary)
                            Text("Bottom Right Corner")
                        }
                    }
                }

                Section {
                    Toggle(isOn: self.$enableTopZone) {
                        HStack {
                            Image(systemName: "rectangle.topthird.inset.filled")
                                .foregroundColor(.primary)
                            Text("Top Zone")
                        }
                    }
                    Toggle(isOn: self.$enableLeftZone) {
                        HStack {
                            Image(systemName: "rectangle.leadingthird.inset.filled")
                                .foregroundColor(.primary)
                            Text("Left Zone")
                        }
                    }
                    Toggle(isOn: self.$enableRightZone) {
                        HStack {
                            Image(systemName: "rectangle.trailingthird.inset.filled")
                                .foregroundColor(.primary)
                            Text("Right Zone")
                        }
                    }
                    Toggle(isOn: self.$enableBottomZone) {
                        HStack {
                            Image(systemName: "rectangle.bottomthird.inset.filled")
                                .foregroundColor(.primary)
                            Text("Bottom Zone")
                        }
                    }
                }
            }
            .formStyle(.grouped)

            Form {
                Section("Activation") {
                    Toggle(isOn: self.$enableModifierKey) {
                        HStack {
                            Image(systemName: "command")
                                .foregroundColor(.primary)
                            Text("Modifier Key")
                        }
                    }

                    HStack {
                        Label("Activation Modifier", systemImage: "square.grid.2x2")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: self.$selectedModifier) {
                            ForEach(ModifierKey.allCases) { key in
                                Text(key.rawValue).tag(key)
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(!self.enableModifierKey)
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
                        get: { self.enableCornerHover },
                        set: { newValue in
                            self.enableCornerHover = newValue
                            if newValue { self.enableCornerClick = false }
                        }
                    )) {
                        HStack {
                            Image(systemName: "hand.point.up.left")
                                .foregroundColor(.primary)
                            Text("Trigger Actions on Corner Hover")
                        }
                    }

                    Toggle(isOn: Binding(
                        get: { self.enableCornerClick },
                        set: { newValue in
                            self.enableCornerClick = newValue
                            if newValue { self.enableCornerHover = false }
                        }
                    )) {
                        HStack {
                            Image(systemName: "hand.tap")
                                .foregroundColor(.primary)
                            Text("Trigger Actions on Corner Click")
                        }
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.primary)
                            Text("Action Delay Timer: \(String(format: "%.1f", self.delayTimer))s")

                            Slider(value: self.$delayTimer, in: 0 ... 5.0, step: 0.5)
                        }
                    }
                }
            }
            .formStyle(.grouped)

            Form {
                Section("Behavior") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "dot.circle.and.cursorarrow")
                                .foregroundColor(.primary)
                            Text("Corner Trigger Sensitivity: \(String(format: "%.1f", self.cornerTriggerSensitivity))")
                        }

                        Text("Controls the width and height of a corner")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 25)
                            .padding(.bottom, 10)

                        Slider(value: self.$cornerTriggerSensitivity, in: 3 ... 10.0, step: 0.5)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "dot.circle.and.cursorarrow")
                                .foregroundColor(.primary)
                            Text("Zone Trigger Sensitivity: \(String(format: "%.1f", self.zoneTriggerSensitivity))")
                        }

                        Text("Controls the width or height of a zone")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 25)
                            .padding(.bottom, 10)

                        Slider(value: self.$zoneTriggerSensitivity, in: 3 ... 10.0, step: 0.5)
                    }
                }

                Section {
                    HStack {
                        Label("Ignored Applications", systemImage: "rectangle.slash")
                            .foregroundColor(.primary)
                        Spacer()
                        Button("Configure") {
                            self.showIgnoredAppsModal = true
                        }
                        .buttonStyle(.bordered)
                    }
                }

                Section {
                    Toggle(isOn: self.$playSoundEffect) {
                        HStack {
                            Image(systemName: "speaker.wave.2")
                                .foregroundColor(.primary)
                            Text("Play Sound Effect on Trigger")
                        }
                    }

                    HStack {
                        Label("Choose Sound Effect", systemImage: "waveform")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: self.$selectedSound) {
                            ForEach(SoundEffect.allCases) { sound in
                                Text(sound.rawValue).tag(sound)
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(!self.playSoundEffect)
                        .frame(width: 150)
                    }.onChange(of: self.selectedSound) { newSound in
                        if self.playSoundEffect {
                            newSound.play()
                        }
                    }
                }

                Section {
                    Toggle(isOn: self.$showToastNotification) {
                        HStack {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.primary)
                            Text("Show Toast Notifications")
                        }
                    }

                    Group {
                        Toggle(isOn: self.$dismissOnClick) {
                            HStack {
                                Image(systemName: "hand.tap")
                                    .foregroundColor(.primary)
                                Text("Dismiss on Click")
                            }
                        }

                        HStack {
                            Label("Auto Dismiss Timer", systemImage: "timer")
                                .foregroundColor(.primary)
                            Spacer()
                            Picker("", selection: self.$autoDismissTimer) {
                                ForEach(DismissTimer.allCases) { interval in
                                    Text(interval.rawValue).tag(interval)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 150)
                        }
                    }
                    .disabled(!self.showToastNotification)
                }
            }
            .formStyle(.grouped)
            .sheet(isPresented: self.$showIgnoredAppsModal) {
                IgnoredApplicationsView()
            }

            Form {
                Section("Text Extractor") {
                    Toggle(isOn: self.$showRecentText) {
                        HStack {
                            Image(systemName: "rectangle.stack")
                                .foregroundColor(.primary)
                            Text("Show Recent Extractions")
                        }
                    }
                }

                Section("Color Picker") {
                    HStack {
                        Label("Color Format", systemImage: "paintpalette")
                            .foregroundColor(.primary)
                        Spacer()
                        Picker("", selection: self.$colorFormat) {
                            ForEach(ColorFormat.allCases) { format in
                                Text(format.rawValue).tag(format)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 150)
                    }

                    Toggle(isOn: self.$showRecentColors) {
                        HStack {
                            Image(systemName: "rectangle.stack")
                                .foregroundColor(.primary)
                            Text("Show Recent Colors")
                        }
                    }
                }
            }
            .formStyle(.grouped)
        }
    }
}
