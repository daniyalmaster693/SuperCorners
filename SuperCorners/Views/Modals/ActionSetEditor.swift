//
//  ActionSetEditor.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-12-20.
//

import AppKit
import SwiftUI

struct ActionSetEditor: View {
    @Environment(\.dismiss) var dismiss

    let safariIcon: NSImage? = {
        let workspace = NSWorkspace.shared
        if let appURL = workspace.urlForApplication(withBundleIdentifier: "com.apple.safari") {
            return workspace.icon(forFile: appURL.path)
        }
        return nil
    }()

    let notesIcon: NSImage? = {
        let workspace = NSWorkspace.shared
        if let appURL = workspace.urlForApplication(withBundleIdentifier: "com.apple.notes") {
            return workspace.icon(forFile: appURL.path)
        }
        return nil
    }()

    let musicIcon: NSImage? = {
        let workspace = NSWorkspace.shared
        if let appURL = workspace.urlForApplication(withBundleIdentifier: "com.apple.music") {
            return workspace.icon(forFile: appURL.path)
        }
        return nil
    }()

    let finderIcon: NSImage? = {
        let workspace = NSWorkspace.shared
        if let appURL = workspace.urlForApplication(withBundleIdentifier: "com.apple.finder") {
            return workspace.icon(forFile: appURL.path)
        }
        return nil
    }()

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
                                panel.allowedFileTypes = ["app"]
                                panel.title = "Select Application"
                                panel.prompt = "Choose"
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
                    HStack {
                        if let safariIcon {
                            Image(nsImage: safariIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Safari Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let notesIcon {
                            Image(nsImage: notesIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Notes Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let musicIcon {
                            Image(nsImage: musicIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Music Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let finderIcon {
                            Image(nsImage: finderIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Finder Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let safariIcon {
                            Image(nsImage: safariIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Safari Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let notesIcon {
                            Image(nsImage: notesIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Notes Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let musicIcon {
                            Image(nsImage: musicIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Music Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let finderIcon {
                            Image(nsImage: finderIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Finder Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let safariIcon {
                            Image(nsImage: safariIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Safari Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let notesIcon {
                            Image(nsImage: notesIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Notes Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let musicIcon {
                            Image(nsImage: musicIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Music Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                        }
                    }
                    
                    HStack {
                        if let finderIcon {
                            Image(nsImage: finderIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .cornerRadius(12)
                        }
                            
                        Text("Finder Actions")
                            .padding(.leading, 5)
                            
                        Spacer()
                            
                        if #available(macOS 26.0, *) {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.glass)
                            .padding(.trailing, 4)
                        }
                            
                        else {
                            Button(action: {
                                // Placeholder edit action
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
                                
                            Button(action: {
                                // Placeholder delete action
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 4)
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
