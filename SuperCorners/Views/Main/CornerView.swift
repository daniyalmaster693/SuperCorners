//
//  CornerView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import AppKit
import SwiftUI

struct CornerView: View {
    @State private var wallpaperImage: NSImage?
    @Environment(\.colorScheme) var colorScheme

    // Action Picker Variables

    @State private var showModal = false
    @State private var refreshID = UUID()
    @State private var selectedActionSet = "Global Actions"

    // Corner Variables

    @AppStorage("enableTopLeftCorner") var enableTopLeftCorner = true
    @AppStorage("enableTopRightCorner") var enableTopRightCorner = true
    @AppStorage("enableBottomLeftCorner") var enableBottomLeftCorner = true
    @AppStorage("enableBottomRightCorner") var enableBottomRightCorner = true

    // Hardcoded App Icon for UI

    let safariIcon: NSImage? = {
        let workspace = NSWorkspace.shared
        if let appURL = workspace.urlForApplication(withBundleIdentifier: "com.apple.safari") {
            return workspace.icon(forFile: appURL.path)
        }
        return nil
    }()

    var body: some View {
        let topLeftTitle = cornerActionBindings[.topLeft]?.title
        let topRightTitle = cornerActionBindings[.topRight]?.title
        let bottomLeftTitle = cornerActionBindings[.bottomLeft]?.title
        let bottomRightTitle = cornerActionBindings[.bottomRight]?.title

        func mapSelectedToCorner(_ selected: SelectedCornerPosition) -> CornerPosition.Corner {
            switch selected {
            case .topLeft: return .topLeft
            case .topRight: return .topRight
            case .bottomLeft: return .bottomLeft
            case .bottomRight: return .bottomRight
            case .top: return .top
            case .left: return .left
            case .right: return .right
            case .bottom: return .bottom
            }
        }

        return VStack {
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { _ in
                    GeometryReader { geo in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Configure Your Super Corners")
                                .font(.title2)
                                .bold()
                                .frame(width: geo.size.width, alignment: .leading)

                            Text("Click the button found at every corner to assign an action through the action picker.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(width: geo.size.width, alignment: .leading)
                                .padding(.bottom, 10)

                            Spacer()

                            if let wallpaper = wallpaperImage {
                                Image(nsImage: wallpaper)
                                    .resizable()
                                    .aspectRatio(16 / 9, contentMode: .fit)
                                    .cornerRadius(12)
                                    .overlay(
                                        GeometryReader { geo in
                                            ZStack {
                                                if enableTopLeftCorner {
                                                    if #available(macOS 26.0, *) {
                                                        Button(topLeftTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .topLeft
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.glass)
                                                        .padding(.leading, 10)
                                                        .position(x: 0 + 75, y: 0 + 20)
                                                    } else {
                                                        Button(topLeftTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .topLeft
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.bordered)
                                                        .padding(.leading, 10)
                                                        .position(x: 0 + 75, y: 0 + 20)
                                                    }
                                                }

                                                if enableTopRightCorner {
                                                    if #available(macOS 26.0, *) {
                                                        Button(topRightTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .topRight
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.glass)
                                                        .padding(.trailing, 10)
                                                        .position(x: geo.size.width - 75, y: 0 + 20)
                                                    } else {
                                                        Button(topRightTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .topRight
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.bordered)
                                                        .padding(.trailing, 10)
                                                        .position(x: geo.size.width - 75, y: 0 + 20)
                                                    }
                                                }

                                                if let safariIcon {
                                                    if #available(macOS 26.0, *) {
                                                        Image(nsImage: safariIcon)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 50, height: 50)
                                                            .cornerRadius(12)
                                                            .padding(2)
                                                            .glassEffect(in: .rect(cornerRadius: 12.0))
                                                    } else {
                                                        Image(nsImage: safariIcon)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 50, height: 50)
                                                            .cornerRadius(12)
                                                    }
                                                }

                                                if enableBottomLeftCorner {
                                                    if #available(macOS 26.0, *) {
                                                        Button(bottomLeftTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .bottomLeft
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.glass)
                                                        .padding(.leading, 10)
                                                        .position(x: 0 + 75, y: geo.size.height - 20)
                                                    }

                                                    else {
                                                        Button(bottomLeftTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .bottomLeft
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.bordered)
                                                        .padding(.leading, 10)
                                                        .position(x: 0 + 75, y: geo.size.height - 20)
                                                    }
                                                }

                                                if enableBottomRightCorner {
                                                    if #available(macOS 26.0, *) {
                                                        Button(bottomRightTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .bottomRight
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.glass)
                                                        .padding(.trailing, 10)
                                                        .position(x: geo.size.width - 75, y: geo.size.height - 20)
                                                    } else {
                                                        Button(bottomRightTitle ?? "Add Action") {
                                                            currentlySelectedCorner = .bottomRight
                                                            showModal = true
                                                        }
                                                        .buttonStyle(.bordered)
                                                        .padding(.trailing, 10)
                                                        .position(x: geo.size.width - 75, y: geo.size.height - 20)
                                                    }
                                                }
                                            }
                                        }
                                    )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding()
                .padding(.leading, 25)
                .padding(.bottom, 10)
                .sheet(isPresented: $showModal) {
                    if let selected = currentlySelectedCorner {
                        ActionLibraryView(corner: mapSelectedToCorner(selected)) {
                            refreshID = UUID()
                        }
                    }
                }
            }
        }
        .id(refreshID)
        .onAppear {
            loadWallpaper()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Picker("", selection: $selectedActionSet) {
                    Text("Global Actions").tag("Global Actions")
                    Text("Safari Actions").tag("Safari Actions")
                    Text("Music Actions").tag("Music Actions")
                    Text("Finder Actions").tag("Finder Actions")
                }
                .help("Choose Trigger Set")
            }

            ToolbarItem(placement: .automatic) {
                Button(action: {
                    // Action for creating an trigger set
                }) {
                    Image(systemName: "plus")
                }
                .help("Create Trigger Set")
            }
        }
    }

    private func loadWallpaper() {
        DispatchQueue.global(qos: .userInitiated).async {
            let image: NSImage?
            if let screen = NSScreen.main,
               let url = NSWorkspace.shared.desktopImageURL(for: screen)
            {
                image = NSImage(contentsOf: url)
            } else {
                image = nil
            }

            DispatchQueue.main.async {
                wallpaperImage = image
            }
        }
    }
}
