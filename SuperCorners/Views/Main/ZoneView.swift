//
//  ZoneView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import SwiftUI

struct ZoneView: View {
    @State private var wallpaperImage: NSImage?
    @Environment(\.colorScheme) var colorScheme

    // Action Picker Variables

    @State private var showModal = false
    @State private var refreshID = UUID()
    @State private var selectedActionSet = "Global Actions"

    // Zone Variables

    @AppStorage("enableTopZone") var enableTopZone = true
    @AppStorage("enableLeftZone") var enableLeftZone = true
    @AppStorage("enableRightZone") var enableRightZone = true
    @AppStorage("enableBottomZone") var enableBottomZone = true

    var body: some View {
        let topTitle = cornerActionBindings[.top]?.title
        let leftTitle = cornerActionBindings[.left]?.title
        let rightTitle = cornerActionBindings[.right]?.title
        let bottomTitle = cornerActionBindings[.bottom]?.title

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
                            Text("Configure Your Super Zones")
                                .font(.title2)
                                .bold()
                                .frame(width: geo.size.width, alignment: .leading)

                            Text("Click the button found at every zone to assign an action through the action picker.")
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
                                    .overlay(alignment: .top) {
                                        if enableTopZone {
                                            if #available(macOS 26.0, *) {
                                                Button(topTitle ?? "Add Action") {
                                                    currentlySelectedCorner = .top
                                                    showModal = true
                                                }
                                                .buttonStyle(.glass)
                                                .padding(8)
                                            }
                                            else {
                                                Button(topTitle ?? "Add Action") {
                                                    currentlySelectedCorner = .top
                                                    showModal = true
                                                }
                                                .buttonStyle(.bordered)
                                                .padding(8)
                                            }
                                        }
                                    }
                                    .overlay(alignment: .bottom) {
                                        if enableBottomZone {
                                            if #available(macOS 26.0, *) {
                                                Button(bottomTitle ?? "Add Action") {
                                                    currentlySelectedCorner = .bottom
                                                    showModal = true
                                                }
                                                .buttonStyle(.glass)
                                                .padding(8)
                                            }
                                            else {
                                                Button(bottomTitle ?? "Add Action") {
                                                    currentlySelectedCorner = .bottom
                                                    showModal = true
                                                }
                                                .buttonStyle(.bordered)
                                                .padding(8)
                                            }
                                        }
                                    }
                                    .overlay(alignment: .leading) {
                                        if enableLeftZone {
                                            if #available(macOS 26.0, *) {
                                                VStack {
                                                    Spacer()
                                                    Button(leftTitle ?? "Add Action") {
                                                        currentlySelectedCorner = .left
                                                        showModal = true
                                                    }
                                                    .buttonStyle(.glass)
                                                    .padding(.trailing, 10)
                                                    .padding(8)
                                                    Spacer()
                                                }
                                            }
                                            else {
                                                VStack {
                                                    Spacer()
                                                    Button(leftTitle ?? "Add Action") {
                                                        currentlySelectedCorner = .left
                                                        showModal = true
                                                    }
                                                    .buttonStyle(.bordered)
                                                    .padding(.trailing, 10)
                                                    .padding(8)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .overlay(alignment: .trailing) {
                                        if enableRightZone {
                                            if #available(macOS 26.0, *) {
                                                VStack {
                                                    Spacer()
                                                    Button(rightTitle ?? "Add Action") {
                                                        currentlySelectedCorner = .right
                                                        showModal = true
                                                    }
                                                    .buttonStyle(.glass)
                                                    .padding(.leading, 10)
                                                    .padding(8)
                                                    Spacer()
                                                }
                                            }

                                            else {
                                                VStack {
                                                    Spacer()
                                                    Button(rightTitle ?? "Add Action") {
                                                        currentlySelectedCorner = .right
                                                        showModal = true
                                                    }
                                                    .buttonStyle(.bordered)
                                                    .padding(.leading, 10)
                                                    .padding(8)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .overlay(alignment: .center) {
                                        if #available(macOS 26.0, *) {
                                            Picker("", selection: $selectedActionSet) {
                                                Text("Global Actions").tag("Global Actions")
                                                Text("Safari Actions").tag("Safari Actions")
                                                Text("Music Actions").tag("Music Actions")
                                                Text("Xcode Actions").tag("Developer Actions")
                                            }
                                            .glassEffect(.regular)
                                        }
                                        else {
                                            Picker("", selection: $selectedActionSet) {
                                                Text("Global Actions").tag("Global Actions")
                                                Text("Safari Actions").tag("Safari Actions")
                                                Text("Music Actions").tag("Music Actions")
                                                Text("Xcode Actions").tag("Developer Actions")
                                            }
                                        }
                                    }
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
            }
            else {
                image = nil
            }

            DispatchQueue.main.async {
                wallpaperImage = image
            }
        }
    }
}
