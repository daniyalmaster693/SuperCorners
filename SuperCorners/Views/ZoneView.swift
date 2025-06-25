//
//  ZoneView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct ZoneView: View {
    @State private var showModal = false
    @State private var refreshID = UUID()

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
                    let gridItem = GridItem(.flexible(), spacing: 16)
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

                            Image("SequoiaWallpaper")
                                .resizable()
                                .aspectRatio(16 / 9, contentMode: .fit)
                                .cornerRadius(12)
                                .overlay(alignment: .top) {
                                    Button(topTitle ?? "Add Action") {
                                        currentlySelectedCorner = .top
                                        showModal = true
                                    }
                                    .buttonStyle(.bordered)
                                    .padding(8)
                                }
                                .overlay(alignment: .bottom) {
                                    Button(bottomTitle ?? "Add Action") {
                                        currentlySelectedCorner = .bottom
                                        showModal = true
                                    }
                                    .buttonStyle(.bordered)
                                    .padding(8)
                                }
                                .overlay(alignment: .leading) {
                                    VStack {
                                        Spacer()
                                        Button(leftTitle ?? "Add Action") {
                                            currentlySelectedCorner = .left
                                            showModal = true
                                        }
                                        .buttonStyle(.bordered)
                                        .padding(8)
                                        Spacer()
                                    }
                                }
                                .overlay(alignment: .trailing) {
                                    VStack {
                                        Spacer()
                                        Button(rightTitle ?? "Add Action") {
                                            currentlySelectedCorner = .right
                                            showModal = true
                                        }
                                        .buttonStyle(.bordered)
                                        .padding(8)
                                        Spacer()
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
                .padding(.leading, 35)
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
    }
}
