//
//  BehaviorSettings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import SwiftUI

struct BehaviorSettingsView: View {
    @AppStorage("triggerSensitivity") private var triggerSensitivity: Double = 5.0
    @AppStorage("showToastNotifications") private var showToastNotification = true

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

                        Text("Controls how close you must your mouse must be to a corner or zone to trigger it")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)

                        Slider(value: self.$triggerSensitivity, in: 1 ... 5.0, step: 0.5)
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
        }
    }
}
