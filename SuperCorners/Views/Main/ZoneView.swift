//
//  ZoneView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import AppKit
import SwiftUI

struct ZoneView: View {
    @Environment(\.colorScheme) var colorScheme

    // Action Picker Variables

    @State private var showModal = false

    // Action Set Info

    @ObservedObject private var actionSetManager = ActionSetManager.shared
    @AppStorage("selectedActionSet") private var selectedActionSet = "global"

    @State private var showActionSetCreator = false
    @State private var showActionSetEditor = false

    // Zone Variables

    @AppStorage("enableTopZone") var enableTopZone = true
    @AppStorage("enableLeftZone") var enableLeftZone = true
    @AppStorage("enableRightZone") var enableRightZone = true
    @AppStorage("enableBottomZone") var enableBottomZone = true

    var body: some View {
        var currentSet: ActionSet {
            actionSetManager.actionSets.first {
                $0.id == selectedActionSet
            } ?? actionSetManager.actionSets[0]
        }

        let topTitle = titleForCorner(.top, currentSet: currentSet)
        let leftTitle = titleForCorner(.left, currentSet: currentSet)
        let rightTitle = titleForCorner(.right, currentSet: currentSet)
        let bottomTitle = titleForCorner(.bottom, currentSet: currentSet)

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

                            Image(colorScheme == .dark ? "ClassicWallpaperDark" : "ClassicWallpaperLight")
                                .resizable()
                                .aspectRatio(16 / 9, contentMode: .fit)
                                .cornerRadius(12)
                                .overlay(alignment: .top) {
                                    if enableTopZone {
                                        if #available(macOS 26.0, *) {
                                            Button(topTitle) {
                                                currentlySelectedCorner = .top
                                                showModal = true
                                            }
                                            .buttonStyle(.glass)
                                            .padding(8)
                                        }
                                        else {
                                            Button(topTitle) {
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
                                            Button(bottomTitle) {
                                                currentlySelectedCorner = .bottom
                                                showModal = true
                                            }
                                            .buttonStyle(.glass)
                                            .padding(8)
                                        }
                                        else {
                                            Button(bottomTitle) {
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
                                                Button(leftTitle) {
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
                                                Button(leftTitle) {
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
                                                Button(rightTitle) {
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
                                                Button(rightTitle) {
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
                        }
                    }
                }
                .padding()
                .padding(.leading, 25)
                .padding(.bottom, 10)
                .sheet(isPresented: $showModal) {
                    if let selected = currentlySelectedCorner {
                        ActionPicker(
                            corner: mapSelectedToCorner(selected),
                            actionSetID: selectedActionSet
                        ) {}
                    }
                }
            }
        }
        .onChange(of: actionSetManager.actionSets.map(\.id)) { _ in
            guard actionSetManager.actionSets.contains(where: {
                $0.id == selectedActionSet
            }) else {
                selectedActionSet = "global"
                return
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Picker("Active Set:", selection: $selectedActionSet) {
                    ForEach(actionSetManager.actionSets) { set in
                        Text(set.name)
                            .tag(set.id)
                    }
                }
                .help("Choose an Action Set")
            }

            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showActionSetCreator = true
                }) {
                    Image(systemName: "plus")
                }
                .help("Create an Action Set")
                .sheet(isPresented: $showActionSetCreator) {
                    ActionSetCreator()
                }
            }

            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showActionSetEditor = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                }
                .help("Edit an Action Set")
                .sheet(isPresented: $showActionSetEditor) {
                    ActionSetEditor()
                }
            }
        }
    }
}
