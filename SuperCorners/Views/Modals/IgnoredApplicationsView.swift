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
    @State private var checkedStates: [String: Bool] = [:]
    @AppStorage("ignoredAppPaths") private var ignoredAppPathsData: Data = .init()

    var body: some View {
        VStack(spacing: 6) {
            Text("Applications")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 25)

            Form {
                ForEach(installedApps, id: \.self) { appURL in
                    Toggle(isOn: Binding(
                        get: { checkedStates[appURL.path] ?? false },
                        set: {
                            checkedStates[appURL.path] = $0
                            saveIgnoredAppPaths()
                        }
                    )) {
                        HStack {
                            Image(nsImage: NSWorkspace.shared.icon(forFile: appURL.path))
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(appURL.deletingPathExtension().lastPathComponent)
                        }
                    }
                }
            }.padding(.top, 5)

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

    func saveIgnoredAppPaths() {
        let ignoredPaths = checkedStates.filter { $0.value }.map { $0.key }
        if let data = try? JSONEncoder().encode(ignoredPaths) {
            ignoredAppPathsData = data
        }
    }

    func loadIgnoredAppStates() {
        guard let savedPaths = try? JSONDecoder().decode([String].self, from: ignoredAppPathsData) else { return }

        for url in installedApps {
            checkedStates[url.path] = savedPaths.contains(url.path)
        }
    }

    func loadInstalledApps() {
        let applicationDirectories = ["/Applications", "/System/Applications"]

        var allAppURLs: [URL] = []

        for path in applicationDirectories {
            let url = URL(fileURLWithPath: path)
            if let appURLs = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) {
                let apps = appURLs.filter { $0.pathExtension == "app" }
                allAppURLs.append(contentsOf: apps)
            }
        }

        installedApps = allAppURLs.sorted {
            $0.deletingPathExtension().lastPathComponent.localizedCaseInsensitiveCompare(
                $1.deletingPathExtension().lastPathComponent
            ) == .orderedAscending
        }

        loadIgnoredAppStates()
    }
}
