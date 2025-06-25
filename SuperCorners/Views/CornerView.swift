//
//  CornerView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct CornerView: View {
    @State private var showModal = false
    @State private var refreshID = UUID()

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
                    let gridItem = GridItem(.flexible(), spacing: 16)
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

                            Image("SequoiaWallpaper")
                                .resizable()
                                .aspectRatio(16 / 9, contentMode: .fit)
                                .cornerRadius(12)
                                .overlay(
                                    GeometryReader { geo in
                                        ZStack {
                                            Button(topLeftTitle ?? "Add Action") {
                                                currentlySelectedCorner = .topLeft
                                                showModal = true
                                            }
                                            .buttonStyle(.bordered)
                                            .position(x: 0 + 75, y: 0 + 20)

                                            Button(topRightTitle ?? "Add Action") {
                                                currentlySelectedCorner = .topRight
                                                showModal = true
                                            }
                                            .buttonStyle(.bordered)
                                            .position(x: geo.size.width - 75, y: 0 + 20)

                                            Button(bottomLeftTitle ?? "Add Action") {
                                                currentlySelectedCorner = .bottomLeft
                                                showModal = true
                                            }
                                            .buttonStyle(.bordered)
                                            .position(x: 0 + 75, y: geo.size.height - 20)

                                            Button(bottomRightTitle ?? "Add Action") {
                                                currentlySelectedCorner = .bottomRight
                                                showModal = true
                                            }
                                            .buttonStyle(.bordered)
                                            .position(x: geo.size.width - 75, y: geo.size.height - 20)
                                        }
                                    }
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
    }
}
