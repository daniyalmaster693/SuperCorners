//
//  ActionSetEditor.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-20.
//

import AppKit
import KeyboardShortcuts
import SwiftUI

struct ActionSetEditor: View {
    @ObservedObject private var actionSetManager = ActionSetManager.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 6) {
            Form {
                Section("Action Sets") {
                    ForEach(actionSetManager.actionSets) { set in
                        Section {
                            VStack {
                                HStack {
                                    if set.targetBundleID == nil {
                                        Image(systemName: "globe")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(.secondary)
                                            .padding(.leading, 5)
                                            .frame(width: 22, height: 22)
                                    }
                                    else if let icon = applicationIcon(for: set.targetBundleID) {
                                        Image(nsImage: icon)
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(12)
                                            .frame(width: 25, height: 25)
                                    }
                                    
                                    Text(set.name)
                                        .padding(.leading, 5)
                                    
                                    Spacer()
                                    
                                    if set.targetBundleID != nil {
                                        if #available(macOS 26.0, *) {
                                            Button(action: {
                                                actionSetManager.deleteSet(id: set.id)
                                            }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.secondary)
                                            }
                                            .buttonStyle(.glass)
                                            .padding(.trailing, 4)
                                        }
                                        else {
                                            Button(action: {
                                                actionSetManager.deleteSet(id: set.id)
                                            }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.trailing, 4)
                                        }
                                    }
                                }
                                
                                HStack {
                                    Picker(
                                        "Method",
                                        selection: Binding(
                                            get: {
                                                set.activation.method
                                            },
                                            set: { newMethod in
                                                let modifierKey: ModifierKey?
                                                
                                                switch newMethod {
                                                case .none:
                                                    modifierKey = nil
                                                    
                                                case .modifier:
                                                    modifierKey = set.activation.modifierKey ?? .command
                                                    
                                                case .keyboardShortcut:
                                                    modifierKey = nil
                                                }
                                                
                                                actionSetManager.updateActivation(
                                                    setID: set.id,
                                                    method: newMethod,
                                                    trigger: set.activation.trigger,
                                                    modifierKey: modifierKey,
                                                    keyboardShortcut: set.activation.keyboardShortcut
                                                )
                                            }
                                        )
                                    ) {
                                        Text("None")
                                            .tag(ActivationMethod.none)
                                        
                                        Text("Modifier")
                                            .tag(ActivationMethod.modifier)
                                        
                                        Text("Keyboard Shortcut")
                                            .tag(ActivationMethod.keyboardShortcut)
                                    }
                                    .labelsHidden()
                                    
                                    if set.activation.method == .modifier {
                                        Picker(
                                            "Modifier",
                                            selection: Binding(
                                                get: {
                                                    set.activation.modifierKey ?? .command
                                                },
                                                set: { newModifier in
                                                    actionSetManager.updateActivation(
                                                        setID: set.id,
                                                        method: set.activation.method,
                                                        trigger: set.activation.trigger,
                                                        modifierKey: newModifier,
                                                        keyboardShortcut: set.activation.keyboardShortcut
                                                    )
                                                }
                                            )
                                        ) {
                                            ForEach(ModifierKey.allCases) { modifier in
                                                Text(modifier.rawValue)
                                                    .tag(modifier)
                                            }
                                        }
                                        .labelsHidden()
                                    }
                                    
                                    if set.activation.method == .keyboardShortcut,
                                       let shortcutName = set.activation.keyboardShortcut
                                    {
                                        KeyboardShortcuts.Recorder(
                                            "",
                                            name: KeyboardShortcuts.Name(shortcutName)
                                        )
                                    }
                                    
                                    Picker(
                                        "Trigger",
                                        selection: Binding(
                                            get: {
                                                set.activation.trigger
                                            },
                                            set: { newTrigger in
                                                actionSetManager.updateActivation(
                                                    setID: set.id,
                                                    method: set.activation.method,
                                                    trigger: newTrigger,
                                                    modifierKey: set.activation.modifierKey,
                                                    keyboardShortcut: set.activation.keyboardShortcut
                                                )
                                            }
                                        )
                                    ) {
                                        Text("Hover")
                                            .tag(ActivationTrigger.hover)
                                        
                                        Text("Click")
                                            .tag(ActivationTrigger.click)
                                    }
                                    .labelsHidden()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .padding(.horizontal, -12)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 7)

            Divider()

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .frame(minWidth: 250, minHeight: 490)
    }

    private func applicationIcon(for bundleID: String?) -> NSImage? {
        guard let bundleID else {
            return nil
        }

        guard let appURL = NSWorkspace.shared.urlForApplication(
            withBundleIdentifier: bundleID
        ) else {
            return nil
        }

        return NSWorkspace.shared.icon(forFile: appURL.path)
    }
}
