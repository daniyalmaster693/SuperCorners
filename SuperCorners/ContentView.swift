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
            VStack {
                List(selection: $selectedItem) {
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
                    
                    HStack {
                        Image(systemName: "bolt.circle")
                            .frame(width: 18, height: 18)
                        Text("Actions")
                    }
                    .tag("actions")
                }
                .listStyle(.sidebar)
                
                Spacer()
                
                HStack(spacing: 8) {
                    if let iconPath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
                       let nsImage = NSImage(contentsOfFile: iconPath) {
                        Image(nsImage: nsImage)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .cornerRadius(6)
                    } else {
                        Image(systemName: "app.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .cornerRadius(6)
                    }

                    VStack(alignment: .leading) {
                        Text("SuperCorners")
                            .font(.footnote)
                            .bold()

                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("Version (\(version))")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
            }
        } detail: {
            switch selectedItem {
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
