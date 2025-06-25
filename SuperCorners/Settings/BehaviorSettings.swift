//
//  BehaviorSettings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-21.
//

import SwiftUI

struct BehaviorSettingsView: View {
    @AppStorage("delayTimer") private var delayTimer: Double = 0.0
    @AppStorage("triggerSensitivity") private var triggerSensitivity: Double = 5.0
    @AppStorage("playSoundEffect") private var playSoundEffect = false
    @AppStorage("disableInFullScreen") private var disableInFullScreen = false

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
                            Image(systemName: "timer")
                                .foregroundColor(.secondary)
                            Text("Delay Timer: \(String(format: "%.1f", delayTimer))s")
                        }

                        Text("Time before an action is triggered after reaching a corner or zone.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)

                        Slider(value: $delayTimer, in: 0 ... 2, step: 0.1)
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "dot.circle.and.cursorarrow")
                                .foregroundColor(.secondary)
                            Text("Trigger Sensitivity: \(String(format: "%.1f", triggerSensitivity))")
                        }

                        Text("Controls how close you must your mouse must be to a corner or zone to trigger it")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)

                        Slider(value: $triggerSensitivity, in: 1 ... 5.0, step: 0.5)
                    }
                }

                Section {
                    Toggle(isOn: $playSoundEffect) {
                        HStack {
                            Image(systemName: "speaker.wave.2")
                                .foregroundColor(.secondary)
                            Text("Play Sound Effect on Trigger")
                        }
                    }
                }

                Section {
                    Toggle(isOn: $disableInFullScreen) {
                        HStack {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .foregroundColor(.secondary)
                            Text("Disable in Full Screen")
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .frame(maxWidth: 700)
        }
    }
}
