//
//  ActionSetEditor.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-20.
//

import AppKit
import SwiftUI

struct ActionSetEditor: View {
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
                                        ActionSetManager.shared.createSet(
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
                                    let bundleID = Bundle(url: url)?.bundleIdentifier
                                           
                                    print("Bundle ID: \(bundleID ?? "Unknown")")
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

                Section("Action Sets") {
                    ForEach(actionSetManager.availableSets) { set in
                        HStack {
                            if let icon = applicationIcon(for: set.targetBundleID) {
                                Image(nsImage: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                                    .frame(width: 25, height: 25)
                            }
                            else {
                                Image(systemName: "globe")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.secondary)
                                    .padding(.leading, 5)
                                    .frame(width: 22, height: 22)
                            }
                        
                            Text(set.name)
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            if set.targetBundleID != nil {
                                if #available(macOS 26.0, *) {
                                    Button(action: {
                                        ActionSetManager.shared.deleteSet(set)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.secondary)
                                    }
                                    .buttonStyle(.glass)
                                    .padding(.trailing, 4)
                                }
                                else {
                                    Button(action: {
                                        ActionSetManager.shared.deleteSet(set)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.trailing, 4)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            .formStyle(.grouped)
            .padding(.horizontal, -12)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 7)

            Divider()

            Button("Save") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .padding(.top, 7)
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
