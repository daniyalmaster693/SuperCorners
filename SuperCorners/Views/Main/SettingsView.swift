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

    // Behavior Settings

    @AppStorage("delayTimer") private var delayTimer: Double = 0.0

    @AppStorage("cornerTriggerSensitivity") private var cornerTriggerSensitivity: Double = 7.0
    @AppStorage("zoneTriggerSensitivity") private var zoneTriggerSensitivity: Double = 7.0

    // Ignored applications list

    @State private var ignoredApps: [String] = []
    @State private var showIgnoredAppsModal = false

    @AppStorage("showVisualFeedback") private var showVisualFeedback = true
    @AppStorage("persistentVisualFeedback") var persistentVisualFeedback = false
    @AppStorage("visualDismissTimer") private var visualDismissTimer: Double = 3.0

    @AppStorage("showToastNotifications") private var showToastNotification = false
    @AppStorage("dismissOnClick") private var dismissOnClick = true
    @AppStorage("autoDismissTimer") private var autoDismissTimer: Double = 3.0

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

                        Slider(value: self.$zoneTriggerSensitivity, in: 3 ... 8.0, step: 0.5)
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
                    Toggle(isOn: self.$showVisualFeedback) {
                        HStack {
                            Image(systemName: "circle.dashed")
                                .foregroundColor(.primary)
                            Text("Show Visual Overlay")
                        }
                    }

                    Toggle(isOn: self.$persistentVisualFeedback) {
                        HStack {
                            Image(systemName: "pin")
                                .foregroundColor(.primary)
                            Text("Keep Overlay Visible")
                        }
                    }
                    .disabled(!self.showVisualFeedback)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.primary)
                            Text("Overlay Duration: \(String(format: "%.1f", self.visualDismissTimer))")

                            Slider(value: self.$visualDismissTimer, in: 3 ... 10.0, step: 0.5)
                                .disabled(!self.showVisualFeedback)
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

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(.primary)
                                Text("Toast Duration: \(String(format: "%.1f", self.autoDismissTimer))")

                                Slider(value: self.$autoDismissTimer, in: 3 ... 10.0, step: 0.5)
                                    .disabled(!self.showToastNotification)
                            }
                        }
                    }
                    .disabled(!self.showToastNotification)
                }
            }
            .formStyle(.grouped)
            .sheet(isPresented: self.$showIgnoredAppsModal) {
                IgnoredApplications()
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
