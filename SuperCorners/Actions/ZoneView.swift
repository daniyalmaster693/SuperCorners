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
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Configure Your Super Zones")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: 450, alignment: .leading)
                    
                    Text("Assign custom actions to your Mac’s screen edges. Click the button found at every edge to assign an action through the action picker.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 450, alignment: .leading)
                }
                .padding(.top, 25)
                .frame(maxWidth: 450)
                
                Spacer()
                
                ZStack {
                    Image("SequoiaWallpaper")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 450, height: 275)
                        .clipped()
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
                            Button(leftTitle ?? "Add Action") {
                                currentlySelectedCorner = .left
                                showModal = true
                            }
                            .buttonStyle(.bordered)
                            .padding(8)
                        }
                        .overlay(alignment: .trailing) {
                            Button(rightTitle ?? "Add Action") {
                                currentlySelectedCorner = .right
                                showModal = true
                            }
                            .buttonStyle(.bordered)
                            .padding(8)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 275)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .sheet(isPresented: $showModal) {
                    if let selected = currentlySelectedCorner {
                        ActionLibraryView(corner: mapSelectedToCorner(selected)) {
                            refreshID = UUID()
                        }
                    }
                }
            }
            .id(refreshID)
        }
    }
}
