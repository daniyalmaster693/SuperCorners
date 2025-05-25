//
//  SettingsView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    @AppStorage("modifier1") private var selectedModifier1 = "Control"
    @AppStorage("modifier2") private var selectedModifier2 = "Shift"
    @AppStorage("hotkeyLetter") private var selectedLetter = "C"
    @AppStorage("enableCorners") private var enableCorners = true
    @AppStorage("enableZones") private var enableZones = true
    @AppStorage("enableSound") private var enableSound = false
    @AppStorage("disableInFullScreen") private var disableInFullScreen = true
    @AppStorage("disableWhenTyping") private var disableWhenTyping = true
    @AppStorage("showIconInDock") private var showInDock = true

    let letters = (65...90).map { String(UnicodeScalar($0)!) }
    let modifier1Options = ["Command", "Option", "Control"]
    let modifier2Options = ["Shift", "Function", "Caps Lock"]

    var modifierKey1: NSEvent.ModifierFlags {
        switch selectedModifier1 {
        case "Command": return .command
        case "Option": return .option
        case "Control": return .control
        default: return []
        }
    }

    var modifierKey2: NSEvent.ModifierFlags {
        switch selectedModifier2 {
        case "Shift": return .shift
        case "Function": return .function
        case "Caps Lock": return .capsLock
        default: return []
        }
    }
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 40) {
                LabeledContent("Activation") {
                    VStack(alignment: .leading, spacing: 4) {
                        Picker("", selection: $selectedModifier1) {
                            ForEach(modifier1Options, id: \.self) { modifier in
                                Text(modifier)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 140, alignment: .leading)

                        Picker("", selection: $selectedModifier2) {
                            ForEach(modifier2Options, id: \.self) { modifier in
                                Text(modifier)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 140, alignment: .leading)
                        
                        Picker("", selection: $selectedLetter) {
                            ForEach(letters, id: \.self) { letter in
                                Text(letter)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 140, alignment: .leading)
                        
                        Text("Set the modifiers and the key used for activation")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                            .padding(.top, 2)
                    }
                }
                
                LabeledContent("Screen Triggers") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Enable Activation Using Corners", isOn: $enableCorners)
                        Toggle("Enable Activation Using Zones", isOn: $enableZones)
                        
                        Text("Enable where you can activate actions")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                
                LabeledContent("Behaviour") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Play sound on trigger", isOn: $enableSound)
                        Toggle("Disable in full screen", isOn: $disableInFullScreen)
                        Toggle("Disable when typing", isOn: $disableWhenTyping)
                        
                        Text("Configure activation behaviours")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                
                
                LabeledContent("Application") {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Show Icon In Dock", isOn: $showInDock)
                        LaunchAtLogin.Toggle()
                        
                        Button("Check for Updates") {
                            checkForUpdates()
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, 8)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .frame(maxWidth: 500, minHeight: 480, idealHeight: 800, maxHeight: .infinity)
    }
}
