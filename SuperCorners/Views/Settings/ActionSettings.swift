//
//  ActionSettings.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-07-19.
//

import SwiftUI

struct ActionSettingsView: View {
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

    var body: some View {
        VStack(spacing: 4) {
            Text("Action Settings")
                .font(.title2)
                .bold()

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
    }
}
