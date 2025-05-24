//
//  ContentView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct ContentView: View {
    @State var showingPanel = false
    @State private var selectedItem: String? = nil

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
                    Image(systemName: "square.grid.2x2")
                        .frame(width: 18, height: 18)
                    Text("Corners")
                }
                .tag("corners")
                
//                HStack {
//                    Image(systemName: "rectangle.leftthird.inset.filled")
//                        .frame(width: 18, height: 18)
//                    Text("Zones")
//                }
//                .tag("zones")
            }
            .listStyle(.sidebar)
            .safeAreaInset(edge: .bottom) {
                VStack(alignment: .leading, spacing: 1) {
                    Button(action: {
                    }, label: {
                        Label("Action Editor", systemImage: "bolt.circle")
                    })
                    .buttonStyle(.borderless)
                    .frame(alignment: .leading)
                
            
//                    Button(action: {
//                    }, label: {
//                        Label("Zone Editor", systemImage: "rectangle.3.offgrid")
//                    })
//                    .buttonStyle(.borderless)
                    .padding([.top, .bottom], 10)
//                    .frame(alignment: .leading)
                }
            }
        } detail: {
            switch selectedItem {
            case "gallery":
                GalleryView()

            case "corners":
                CornerView()
                    .navigationTitle("Corners")

//            case "zones":
//                CornerView()
//                    .navigationTitle("Zones")

            default:
                Text("No item selected")
            }
        }
    }
}
