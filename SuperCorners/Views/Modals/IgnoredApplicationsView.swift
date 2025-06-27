//
//  IgnoredApplicationsView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-26.
//

import AppKit
import SwiftUI

struct IgnoredApplicationsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var installedApps: [URL] = []
    @State private var checkedStates: [URL: Bool] = [:]

    var body: some View {
        VStack(spacing: 8) {
            Text("Applications")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 15)
                .padding(.bottom, 7)

            Form {
                ForEach(installedApps, id: \.self) { appURL in
                    Toggle(isOn: Binding(
                        get: { checkedStates[appURL] ?? false },
                        set: { checkedStates[appURL] = $0 }
                    )) {
                        HStack {
                            Image(nsImage: NSWorkspace.shared.icon(forFile: appURL.path))
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(appURL.deletingPathExtension().lastPathComponent)
                        }
                    }
                }
            }

            Divider().frame(maxWidth: 375)

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: 375, alignment: .trailing)
            .padding(.top, 10)
        }
        .padding()
        .frame(width: 350)
        .formStyle(.grouped)
        .onAppear(perform: loadInstalledApps)
    }

    func loadInstalledApps() {
        let fileManager = FileManager.default
        let appDirs = ["/Applications", "/System/Applications"]
        var foundApps: [URL] = []

        for path in appDirs {
            let url = URL(fileURLWithPath: path)
            if let apps = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                foundApps.append(contentsOf: apps.filter { $0.pathExtension == "app" })
            }
        }

        installedApps = foundApps.sorted {
            $0.deletingPathExtension().lastPathComponent.localizedCaseInsensitiveCompare(
                $1.deletingPathExtension().lastPathComponent
            ) == .orderedAscending
        }
    }
}
