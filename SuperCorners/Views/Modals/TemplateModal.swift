//
//  TemplateModal.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-07.
//

import KeyboardShortcuts
import SwiftUI

struct TemplateModal: View {
    @ObservedObject private var actionSetManager = ActionSetManager.shared
    
    @State private var templateInput = ""

    let action: CornerAction
    let corner: CornerPosition.Corner
    let actionSetID: String
    var onUpdate: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(action.inputPrompt ?? "Enter Input")
                .font(.title2)
                .padding(.top, 10)
                .padding(.bottom, 2)
                .bold()
            
            Text("Enter a valid action input to assign it")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
                .frame(maxWidth: 290)
            
            if action.inputType == .application {
                HStack(spacing: 8) {
                    TextField("Enter Action Input...", text: $templateInput)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(maxWidth: 260)
                    
                    Button(action: {
                        let panel = NSOpenPanel()
                        panel.canChooseFiles = true
                        panel.canChooseDirectories = false
                        panel.allowsMultipleSelection = false
                        panel.allowedContentTypes = [.application]
                        panel.directoryURL = URL(fileURLWithPath: "/Applications")
                        panel.title = "Select Application"
                        panel.prompt = "Select"
                        
                        if panel.runModal() == .OK, let url = panel.url {
                            templateInput = url.path
                        }
                    }) {
                        Image(systemName: "folder")
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.bottom, 20)
            } else if action.inputType == .folder {
                HStack(spacing: 8) {
                    TextField("Enter Action Input...", text: $templateInput)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(maxWidth: 260)
                    
                    Button(action: {
                        let panel = NSOpenPanel()
                        panel.canChooseFiles = false
                        panel.canChooseDirectories = true
                        panel.allowsMultipleSelection = false
                        let lastPath = UserDefaults.standard.string(forKey: "lastChosenPath") ?? NSHomeDirectory()
                        panel.directoryURL = URL(fileURLWithPath: lastPath)
                        panel.title = "Select Folder"
                        panel.prompt = "Select"
                        
                        if panel.runModal() == .OK, let url = panel.url {
                            templateInput = url.path
                            UserDefaults.standard.set(url.path, forKey: "lastChosenPath")
                        }
                    }) {
                        Image(systemName: "folder")
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.bottom, 20)
            } else if action.inputType == .file {
                HStack(spacing: 8) {
                    TextField("Enter Action Input...", text: $templateInput)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(maxWidth: 260)
                    
                    Button(action: {
                        let panel = NSOpenPanel()
                        panel.canChooseFiles = true
                        panel.canChooseDirectories = false
                        panel.allowsMultipleSelection = false
                        let lastPath = UserDefaults.standard.string(forKey: "lastChosenPath") ?? NSHomeDirectory()
                        panel.directoryURL = URL(fileURLWithPath: lastPath)
                        panel.title = "Select File"
                        panel.prompt = "Select"
                        
                        if panel.runModal() == .OK, let url = panel.url {
                            templateInput = url.path
                            UserDefaults.standard.set(url.path, forKey: "lastChosenPath")
                        }
                    }) {
                        Image(systemName: "doc")
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.bottom, 20)
            } else if action.inputType == .appleScript {
                HStack(spacing: 8) {
                    TextField("Enter Action Input...", text: $templateInput)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(maxWidth: 260)
                    
                    Button(action: {
                        let panel = NSOpenPanel()
                        panel.canChooseFiles = true
                        panel.canChooseDirectories = false
                        panel.allowsMultipleSelection = false
                        panel.allowedContentTypes = [.appleScript]
                        let lastPath = UserDefaults.standard.string(forKey: "lastChosenPath") ?? NSHomeDirectory()
                        panel.directoryURL = URL(fileURLWithPath: lastPath)
                        panel.title = "Select AppleScript"
                        panel.prompt = "Select"
                        
                        if panel.runModal() == .OK, let url = panel.url {
                            templateInput = url.path
                            UserDefaults.standard.set(url.path, forKey: "lastChosenPath")
                        }
                    }) {
                        Image(systemName: "doc")
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.bottom, 20)
            } else if action.inputType == .hotkey {
                HStack(spacing: 8) {
                    TextField("Hotkey Name...", text: $templateInput)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(maxWidth: 300)
                    
                    let dynamicHotkeyName = KeyboardShortcuts.Name(templateInput.isEmpty ? "tempHotkey" : templateInput)
                    KeyboardShortcuts.Recorder(for: dynamicHotkeyName)
                }
                .padding(.bottom, 20)
            } else {
                HStack(spacing: 8) {
                    TextField("Enter Action Input...", text: $templateInput)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(NSColor.controlBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(maxWidth: 260)
                    
                    Button(action: {
                        if let clipboardString = NSPasteboard.general.string(forType: .string) {
                            templateInput = clipboardString
                        }
                    }) {
                        Image(systemName: "clipboard")
                            .frame(width: 30, height: 30)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                }.padding(.bottom, 20)
            }
            
            Divider().frame(maxWidth: 290)
            
            HStack {
                Button("Cancel") {
                    onUpdate()
                }
                .keyboardShortcut(.cancelAction)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Assign") {
                    actionSetManager.assignAction(
                        actionID: action.id,
                        input: templateInput,
                        position: corner,
                        setID: actionSetID
                    )
                        
                    actionSetManager.saveConfig()
                    onUpdate()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(templateInput.trimmingCharacters(in: .whitespaces).isEmpty)
                .frame(maxWidth: 375, alignment: .trailing)
            }
        }
        .frame(maxWidth: 290, minHeight: 175)
        .padding(.top, 15)
        .padding()
        .onAppear {
            guard templateInput.isEmpty else {
                return
            }

            switch action.inputType {
            case .url:
                templateInput = "https://"
            case .application:
                templateInput = "Applications/"
            case .folder, .file, .appleScript:
                let homePath = FileManager.default.homeDirectoryForCurrentUser.path
                templateInput = "\(homePath)/"
            default:
                break
            }
        }
    }
}
