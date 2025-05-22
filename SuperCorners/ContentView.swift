//
//  ContentView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct ContentView: View {
    @State var showingPanel = false
    @State private var selectedCorner: String? = nil

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedCorner) {
                HStack {
                    Image(systemName: "square.grid.2x2")
                        .frame(width: 18, height: 18)
                    Text("Gallery")
                }
                .tag("gallery")
                
                Section(header: Text("Corners")) {
                    HStack {
                        Image(systemName: "arrow.up.left.circle")
                            .frame(width: 18, height: 18)
                        Text("Top Left")
                    }
                    .tag("topLeft")

                    HStack {
                        Image(systemName: "arrow.up.right.circle")
                            .frame(width: 18, height: 18)
                        Text("Top Right")
                    }
                    .tag("topRight")

                    HStack {
                        Image(systemName: "arrow.down.left.circle")
                            .frame(width: 18, height: 18)
                        Text("Bottom Left")
                    }
                    .tag("bottomLeft")

                    HStack {
                        Image(systemName: "arrow.down.right.circle")
                            .frame(width: 18, height: 18)
                        Text("Bottom Right")
                    }
                    .tag("bottomRight")
                }
                
                Section(header: Text("Zones")) {
                    HStack {
                        Image(systemName: "rectangle.topthird.inset.filled")
                            .frame(width: 18, height: 18)
                        Text("Top Zone")
                    }
                    .tag("topZone")
                    
                    HStack {
                        Image(systemName: "rectangle.lefthalf.inset.filled")
                            .frame(width: 18, height: 18)
                        Text("Left Zone")
                    }
                    .tag("leftZone")

                    HStack {
                        Image(systemName: "rectangle.righthalf.inset.filled")
                            .frame(width: 18, height: 18)
                        Text("Right Zone")
                    }
                    .tag("rightZone")

                    HStack {
                        Image(systemName: "rectangle.bottomthird.inset.filled")
                            .frame(width: 18, height: 18)
                        Text("Bottom Zone")
                    }
                    .tag("bottomZone")
                }
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
                
            
                    Button(action: {
                    }, label: {
                        Label("Zone Editor", systemImage: "rectangle.3.offgrid")
                    })
                    .buttonStyle(.borderless)
                    .padding([.top, .bottom], 10)
                    .frame(alignment: .leading)
                }
            }
        } detail: {
            switch selectedCorner {
            case "gallery":
                GalleryView()

            case "topLeft", "topRight", "bottomLeft", "bottomRight":
                Text("Selected Corner: \(selectedCorner!)")
                    .navigationTitle("Corners")

            case "topZone", "bottomZone", "leftZone", "rightZone":
                Text("Selected Zone: \(selectedCorner!)")
                    .navigationTitle("Zones")

            default:
                Text("No item selected")
            }
        }
    }
}
