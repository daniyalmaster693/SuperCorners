//
//  BehaviorSettings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import SwiftUI

struct BehaviorSettingsView: View {
    @AppStorage("triggerSensitivity") private var triggerSensitivity: Double = 5.0

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

    var body: some View {
        VStack(spacing: 8) {
            Text("Behavior")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)

            Form {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "dot.circle.and.cursorarrow")
                                .foregroundColor(.secondary)
                            Text("Trigger Sensitivity: \(String(format: "%.1f", self.triggerSensitivity))")
                        }

                        Text("Controls how close your mouse must be to a corner or zone to trigger it")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 25)
                            .padding(.bottom, 10)

                        Slider(value: self.$triggerSensitivity, in: 1 ... 8.0, step: 0.5)
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
    }
}
