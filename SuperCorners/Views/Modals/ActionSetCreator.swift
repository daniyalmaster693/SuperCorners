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

    var body: some View {
        VStack(spacing: 6) {
            Form {
                Section("Create an Action Set") {
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
                                    let appName = url.deletingPathExtension().lastPathComponent
                                    let bundleID = Bundle(url: url)?.bundleIdentifier

                                    if let bundleID {
                                        actionSetManager.createSet(
                                            name: "\(appName) Actions",
                                            targetBundleID: bundleID
                                        )
                                    }
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
                        }
                        else {
                            Button(action: {
                                let panel = NSOpenPanel()
                                panel.canChooseFiles = true
                                panel.canChooseDirectories = false
                                panel.allowsMultipleSelection = false
                                panel.allowedContentTypes = [.application]
                                panel.title = "Select Application"
                                panel.prompt = "Choose"

                                if panel.runModal() == .OK, let url = panel.url {
                                    let appName = url.deletingPathExtension().lastPathComponent
                                    let bundleID = Bundle(url: url)?.bundleIdentifier

                                    if let bundleID {
                                        actionSetManager.createSet(
                                            name: "\(appName) Actions",
                                            targetBundleID: bundleID
                                        )
                                    }
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
        .padding(.top, 7)
    }
}
