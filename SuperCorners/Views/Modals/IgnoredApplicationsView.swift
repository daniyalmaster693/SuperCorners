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
    @State private var searchText = ""
    @State private var installedApps: [URL] = []
    @State private var runningApps: [URL] = []
    @State private var checkedStates: [String: Bool] = [:]
    @AppStorage("ignoredAppPaths") private var ignoredAppPathsData: Data = .init()

    func appRow(_ appURL: URL) -> some View {
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
        .help(appURL.path)
    }
    
    var ignoredAppsFiltered: [String] {
        checkedStates.keys.filter { appURL in
            searchText.isEmpty ||
            ((URL(string: appURL)?
                .deletingPathExtension()
                .lastPathComponent
                .localizedCaseInsensitiveContains(searchText)) ?? false)
        }
    }
    
    var runningAppsFiltered: [URL] {
        runningApps.filter { appURL in
            searchText.isEmpty ||
            appURL.deletingPathExtension()
                .lastPathComponent
                .localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var installedAppsFiltered: [URL] {
        installedApps.filter { appURL in
            searchText.isEmpty ||
            appURL.deletingPathExtension()
                .lastPathComponent
                .localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            Text("Applications")
                .font(.title)
                .padding(.top, 25)
                .padding(.bottom, 12)
                .bold()

            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search Applications", text: $searchText)
                    .textFieldStyle(.plain)
            }
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

            Form {
                Section("Ignored Applications") {
                    if ignoredAppsFiltered.isEmpty {
                        Text("None")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(ignoredAppsFiltered, id: \.self) { appURL in
                            if let url = URL(string: appURL) {
                                appRow(url)
                            }
                        }
                    }
                }
                
                Section("Running Applications") {
                    if runningAppsFiltered.isEmpty {
                        Text("None")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(runningAppsFiltered, id: \.self) { appURL in
                            appRow(appURL)
                        }
                    }
                }
                                
                Section("Installed Applications") {
                    if installedAppsFiltered.isEmpty {
                        Text("None")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(installedAppsFiltered, id: \.self) { appURL in
                            appRow(appURL)
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .padding(.horizontal, -12)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 7)
            .onAppear(perform: loadAllApps)

            Divider()

            Button("Done") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .padding(.top, 7)
        .frame(width: 385, height: 500)
    }

    func saveIgnoredAppPaths() {
        let ignoredPaths = checkedStates.filter { $0.value }.map { $0.key }
        if let data = try? JSONEncoder().encode(ignoredPaths) {
            ignoredAppPathsData = data
        }
    }

    func loadIgnoredAppStates() {
        guard let savedPaths = try? JSONDecoder().decode([String].self, from: ignoredAppPathsData) else { return }
        for url in installedApps + runningApps {
            if (savedPaths.contains(url.path)) {
                checkedStates[url.path] = savedPaths.contains(url.path)
            }
        }
    }

    func loadInstalledApps() {
        let applicationDirectories = [
            "/Applications",
            "/System/Applications",
            FileManager.default.homeDirectoryForCurrentUser
                .appendingPathComponent("Applications").path
        ]

        var collectedApps: [URL] = []
        var visitedDirectories = Set<String>()

        for path in applicationDirectories {
            let url = URL(fileURLWithPath: path)
            scanDirectory(url, collected: &collectedApps, visited: &visitedDirectories)
        }

        installedApps = Array(Set(collectedApps)).sorted {
            $0.deletingPathExtension().lastPathComponent
                .localizedCaseInsensitiveCompare(
                    $1.deletingPathExtension().lastPathComponent
                ) == .orderedAscending
        }
    }
    
    func scanDirectory(
        _ url: URL,
        collected: inout [URL],
        visited: inout Set<String>
    ) {
        let resolvedURL = url.resolvingSymlinksInPath()
        let path = resolvedURL.path

        // in case of infinite loops from symlinks
        guard !visited.contains(path) else { return }
        visited.insert(path)

        guard let enumerator = FileManager.default.enumerator(
            at: resolvedURL,
            includingPropertiesForKeys: [.isSymbolicLinkKey, .isDirectoryKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else { return }

        for case let fileURL as URL in enumerator {
            if fileURL.pathExtension == "app" {
                collected.append(fileURL)
                continue
            }

            if let values = try? fileURL.resourceValues(forKeys: [.isSymbolicLinkKey]),
               values.isSymbolicLink == true {
                let resolved = fileURL.resolvingSymlinksInPath()
                var isDir: ObjCBool = false
                if FileManager.default.fileExists(atPath: resolved.path, isDirectory: &isDir),
                   isDir.boolValue {
                    scanDirectory(resolved, collected: &collected, visited: &visited)
                }
            }
        }
    }
    
    func loadRunningApps() {
        runningApps = NSWorkspace.shared.runningApplications
            .filter { $0.activationPolicy == .regular }
            .compactMap { $0.bundleURL }
    }
    
    func loadAllApps() {
        loadInstalledApps()
        loadRunningApps()
        loadIgnoredAppStates()
    }
}
