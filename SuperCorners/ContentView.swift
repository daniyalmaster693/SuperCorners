//
//  ContentView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct ContentView: View {
    @State var showingPanel = false
    @State private var selectedItem: String? = "corners"

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                HStack {
                    Image(systemName: "rectangle.stack")
                        .frame(width: 18, height: 18)
                    Text("Gallery")
                }
                .tag("gallery")
                
                HStack {
                    Image(systemName: "bolt.circle")
                        .frame(width: 18, height: 18)
                    Text("Actions")
                }
                .tag("actions")
                
                HStack {
                    Image(systemName: "square.grid.2x2")
                        .frame(width: 18, height: 18)
                    Text("Corners")
                }
                .tag("corners")
                
                HStack {
                    Image(systemName: "rectangle.leftthird.inset.filled")
                        .frame(width: 18, height: 18)
                    Text("Zones")
                }
                .tag("zones")
            }
            .listStyle(.sidebar)
        } detail: {
            switch selectedItem {
            case "gallery":
                GalleryView()
                
            case "actions":
                ActionBrowserView()
                
            case "corners":
                CornerView()

            case "zones":
                ZoneView()

            default:
                Text("No item selected")
            }
        }
    }
}
