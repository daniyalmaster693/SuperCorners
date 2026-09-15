//
//  ActionSetCreator.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-12.
//

import AppKit
import SwiftUI

struct ActionSetCreator: View {
    @ObservedObject private var actionSetManager = ActionSetManager.shared
    @Environment(\.dismiss) var dismiss

    @State private var actionSetType: ActionSetType = .global

    @State private var actionSetName = ""
    @State private var selectedBundleID: String?

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

                    HStack {
                        Text("Action Set Name")
                            .padding(.leading, 5)

                        Spacer()

                        TextField("", text: $actionSetName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 200)
                    }
                }
            }
            .formStyle(.grouped)
            .padding(.horizontal, -12)
            .frame(maxWidth: 470, maxHeight: 240, alignment: .center)
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
                            name: actionSetName,
                            targetBundleID: nil
                        )
                        dismiss()
                    } else if let selectedBundleID {
                        actionSetManager.createSet(
                            name: actionSetName,
                            targetBundleID: selectedBundleID
                        )
                        dismiss()
                    }
                }
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
}
