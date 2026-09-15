//
//  ActionSetCreator.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-12.
//

import AppKit
import KeyboardShortcuts
import SwiftUI

struct ActionSetCreator: View {
    @ObservedObject private var actionSetManager = ActionSetManager.shared
    @Environment(\.dismiss) var dismiss

    @State private var actionSetType: ActionSetType = .global

    @State private var selectedAppName = "Choose Application"
    @State private var selectedBundleID: String?

    @State private var actionSetName = ""
    @State private var actionSetID = UUID().uuidString

    @State private var activationMethod: ActivationMethod = .none
    @State private var activationTrigger: ActivationTrigger = .hover
    @State private var modifierKey: ModifierKey = .command

    enum ActionSetType: String, CaseIterable {
        case global = "Global"
        case application = "Application"
    }

    var body: some View {
        VStack(spacing: 6) {
            Form {
                Section("Create an Action Set") {
                    HStack {
                        Image(systemName: "rectangle.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.secondary)

                        Text("Action Set Type")
                            .padding(.leading, 5)

                        Spacer()

                        Picker("", selection: $actionSetType) {
                            ForEach(ActionSetType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                    }

                    if actionSetType == .application {
                        HStack {
                            Image(systemName: "plus.app")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.secondary)

                            Text("Select App")
                                .padding(.leading, 5)

                            Spacer()

                            if #available(macOS 26.0, *) {
                                Button(action: {
                                    let panel = NSOpenPanel()
                                    panel.canChooseFiles = true
                                    panel.canChooseDirectories = false
                                    panel.allowsMultipleSelection = false
                                    panel.allowedContentTypes = [.application]
                                    panel.title = "Select Application"
                                    panel.prompt = "Choose"

                                    if panel.runModal() == .OK, let url = panel.url {
                                        selectedAppName = url.deletingPathExtension().lastPathComponent
                                        selectedBundleID = Bundle(url: url)?.bundleIdentifier
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "folder")
                                        Text("Choose Application")
                                    }
                                    .foregroundColor(.secondary)
                                }
                                .buttonStyle(.glass)
                                .padding(.trailing, 4)
                            } else {
                                Button(action: {
                                    let panel = NSOpenPanel()
                                    panel.canChooseFiles = true
                                    panel.canChooseDirectories = false
                                    panel.allowsMultipleSelection = false
                                    panel.allowedContentTypes = [.application]
                                    panel.title = "Select Application"
                                    panel.prompt = "Choose"

                                    if panel.runModal() == .OK, let url = panel.url {
                                        selectedAppName = url.deletingPathExtension().lastPathComponent
                                        selectedBundleID = Bundle(url: url)?.bundleIdentifier
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "folder")
                                        Text("Choose Application")
                                    }
                                    .foregroundColor(.secondary)
                                }
                                .padding(.trailing, 4)
                            }
                        }
                    }
                }

                Section("Customize your Action Set") {
                    if actionSetType == .application {
                        HStack {
                            if selectedBundleID == nil {
                                Image(systemName: "globe")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 5)
                                    .frame(width: 22, height: 22)
                            } else if let icon = applicationIcon(for: selectedBundleID) {
                                Image(nsImage: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                                    .frame(width: 25, height: 25)
                            }

                            Text(selectedAppName)
                                .padding(.leading, 5)
                        }
                    }

                    HStack {
                        Text("Action Set Name")
                            .padding(.leading, 5)

                        Spacer()

                        TextField("", text: $actionSetName)
                            .textFieldStyle(.roundedBorder)
                    }

                    HStack {
                        Picker("", selection: $activationMethod) {
                            Text("None")
                                .tag(ActivationMethod.none)

                            Text("Modifier")
                                .tag(ActivationMethod.modifier)

                            Text("Keyboard Shortcut")
                                .tag(ActivationMethod.keyboardShortcut)
                        }
                        .labelsHidden()

                        if activationMethod == .modifier {
                            Picker("", selection: $modifierKey) {
                                ForEach(ModifierKey.allCases) { modifier in
                                    Text(modifier.rawValue)
                                        .tag(modifier)
                                }
                            }
                            .labelsHidden()
                        }

                        if activationMethod == .keyboardShortcut {
                            KeyboardShortcuts.Recorder(
                                "",
                                name: KeyboardShortcuts.Name("actionSet_\(actionSetID)")
                            )
                        }

                        Picker("", selection: $activationTrigger) {
                            Text("Hover")
                                .tag(ActivationTrigger.hover)

                            Text("Click")
                                .tag(ActivationTrigger.click)
                        }

                        .labelsHidden()
                    }
                }
            }
            .formStyle(.grouped)
            .padding(.horizontal, -12)
            .frame(maxWidth: 470, minHeight: 240, alignment: .center)
            .padding(.top, 7)

            Divider().frame(maxWidth: 470)

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("Create Set") {
                    if actionSetType == .global {
                        actionSetManager.createSet(
                            id: actionSetID,
                            name: actionSetName,
                            targetBundleID: nil,
                            activationMethod: activationMethod,
                            activationTrigger: activationTrigger,
                            modifierKey: modifierKey
                        )

                        dismiss()
                    } else if let selectedBundleID {
                        actionSetManager.createSet(
                            id: actionSetID,
                            name: actionSetName,
                            targetBundleID: selectedBundleID,
                            activationMethod: activationMethod,
                            activationTrigger: activationTrigger,
                            modifierKey: modifierKey
                        )

                        dismiss()
                    }
                }
                .disabled(actionSetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .keyboardShortcut(.defaultAction)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 3)
            .frame(maxWidth: 470)
        }
        .padding()
        .padding(.top, 7)
        .frame(minWidth: 470, minHeight: 240)
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
