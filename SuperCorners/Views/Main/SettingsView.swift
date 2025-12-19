//
//  ZoneView 2.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-19.
//

import KeyboardShortcuts
import LaunchAtLogin
import Sparkle
import SwiftUI

struct SettingsView: View {
    // Sparkle Updater

    let updater: SPUUpdater
    @StateObject private var updateViewModel: CheckForUpdatesViewModel

    final class CheckForUpdatesViewModel: ObservableObject {
        @Published var canCheckForUpdates = false

        init(updater: SPUUpdater) {
            updater.publisher(for: \.canCheckForUpdates)
                .assign(to: &self.$canCheckForUpdates)
        }
    }

    init(updater: SPUUpdater) {
        self.updater = updater
        _updateViewModel = StateObject(
            wrappedValue: CheckForUpdatesViewModel(updater: updater))
    }

    // Settings Variables

    @AppStorage("showInDock") private var showInDock = true
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    @AppStorage("showCorners") private var showCorners = true
    @AppStorage("showZones") private var showZones = true
    @AppStorage("showFavorites") private var showFavorites = true

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

    // Behavior Settings

    @AppStorage("cornerTriggerSensitivity") private var cornerTriggerSensitivity: Double = 5.0
    @AppStorage("zoneTriggerSensitivity") private var zoneTriggerSensitivity: Double = 5.0

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

    @AppStorage("rememberNotesText") private var rememberNotesText = true
    @AppStorage("rememberCalcText") private var rememberCalcText = true

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
            VStack(spacing: 4) {
                Form {
                    Section {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.secondary)
                            LaunchAtLogin.Toggle()
                        }

                        HStack {
                            Toggle(isOn: self.$showInDock) {
                                HStack {
                                    Image(systemName: "dock.rectangle")
                                        .foregroundColor(.secondary)
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
                    }

                    Section {
                        HStack {
                            Label("Updates", systemImage: "arrow.2.circlepath")
                                .foregroundColor(.primary)
                            Spacer()
                            Button("Check for Updates") {
                                self.updater.checkForUpdates()
                            }
                            .buttonStyle(.bordered)
                            .disabled(!self.updateViewModel.canCheckForUpdates)
                        }
                    }

                    Section {
                        Toggle(isOn: self.$showMenuBarExtra) {
                            HStack {
                                Image(systemName: "menubar.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Show in Menu Bar")
                            }
                        }

                        Group {
                            Toggle(isOn: self.$showCorners) {
                                HStack {
                                    Image(systemName: "square.grid.2x2")
                                        .foregroundColor(.secondary)
                                    Text("Show Corners in Menu Bar")
                                }
                            }

                            Toggle(isOn: self.$showZones) {
                                HStack {
                                    Image(systemName: "rectangle.leftthird.inset.filled")
                                        .foregroundColor(.secondary)
                                    Text("Show Zones in Menu Bar")
                                }
                            }

                            Toggle(isOn: self.$showFavorites) {
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
            .frame(maxWidth: 700)
            .formStyle(.grouped)

            VStack(spacing: 8) {
                Form {
                    Section {
                        Toggle(isOn: self.$enableModifierKey) {
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
                                    .foregroundColor(.secondary)
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
                        Toggle(isOn: self.$enableTopLeftCorner) {
                            HStack {
                                Image(systemName: "inset.filled.topleft.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Top Left Corner")
                            }
                        }
                        Toggle(isOn: self.$enableTopRightCorner) {
                            HStack {
                                Image(systemName: "inset.filled.topright.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Top Right Corner")
                            }
                        }
                        Toggle(isOn: self.$enableBottomLeftCorner) {
                            HStack {
                                Image(systemName: "inset.filled.bottomleft.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Bottom Left Corner")
                            }
                        }
                        Toggle(isOn: self.$enableBottomRightCorner) {
                            HStack {
                                Image(systemName: "inset.filled.bottomright.rectangle")
                                    .foregroundColor(.secondary)
                                Text("Bottom Right Corner")
                            }
                        }
                    }

                    Section(header: Text("Enabled Zones")) {
                        Toggle(isOn: self.$enableTopZone) {
                            HStack {
                                Image(systemName: "rectangle.topthird.inset.filled")
                                    .foregroundColor(.secondary)
                                Text("Top Zone")
                            }
                        }
                        Toggle(isOn: self.$enableLeftZone) {
                            HStack {
                                Image(systemName: "rectangle.leadingthird.inset.filled")
                                    .foregroundColor(.secondary)
                                Text("Left Zone")
                            }
                        }
                        Toggle(isOn: self.$enableRightZone) {
                            HStack {
                                Image(systemName: "rectangle.trailingthird.inset.filled")
                                    .foregroundColor(.secondary)
                                Text("Right Zone")
                            }
                        }
                        Toggle(isOn: self.$enableBottomZone) {
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

            VStack(spacing: 8) {
                Form {
                    Section {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: "dot.circle.and.cursorarrow")
                                    .foregroundColor(.secondary)
                                Text("Corner Trigger Sensitivity: \(String(format: "%.1f", self.cornerTriggerSensitivity))")
                            }

                            Text("Controls how close your mouse must be to a corner to trigger it")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.leading, 25)
                                .padding(.bottom, 10)

                            Slider(value: self.$cornerTriggerSensitivity, in: 1 ... 8.0, step: 0.5)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: "dot.circle.and.cursorarrow")
                                    .foregroundColor(.secondary)
                                Text("Zone Trigger Sensitivity: \(String(format: "%.1f", self.zoneTriggerSensitivity))")
                            }

                            Text("Controls how close your mouse must be to a zone to trigger it")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.leading, 25)
                                .padding(.bottom, 10)

                            Slider(value: self.$zoneTriggerSensitivity, in: 1 ... 8.0, step: 0.5)
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
                        Toggle(isOn: self.$showToastNotification) {
                            HStack {
                                Image(systemName: "bell.badge")
                                    .foregroundColor(.secondary)
                                Text("Show Toast Notifications")
                            }
                        }

                        Group {
                            Toggle(isOn: self.$dismissOnClick) {
                                HStack {
                                    Image(systemName: "hand.tap")
                                        .foregroundColor(.secondary)
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

                    Section {
                        Toggle(isOn: self.$playSoundEffect) {
                            HStack {
                                Image(systemName: "speaker.wave.2")
                                    .foregroundColor(.secondary)
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
                }

                .formStyle(.grouped)
                .frame(maxWidth: 700)
            }.sheet(isPresented: self.$showIgnoredAppsModal) {
                IgnoredApplicationsView()
            }

            VStack(spacing: 4) {
                Form {
                    Section("Floating Notes Window") {
                        Toggle(isOn: self.$rememberNotesText) {
                            HStack {
                                Image(systemName: "macwindow")
                                    .foregroundColor(.secondary)
                                Text("Remember Text on Close")
                            }
                        }
                    }

                    Section("Natural Language Calculator") {
                        Toggle(isOn: self.$rememberCalcText) {
                            HStack {
                                Image(systemName: "captions.bubble")
                                    .foregroundColor(.secondary)
                                Text("Remember Text on Close")
                            }
                        }
                    }

                    Section("Text Extractor") {
                        Toggle(isOn: self.$showRecentText) {
                            HStack {
                                Image(systemName: "rectangle.stack")
                                    .foregroundColor(.secondary)
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
                                    .foregroundColor(.secondary)
                                Text("Show Recent Colors")
                            }
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .frame(maxWidth: 700)
        }
    }
}
