//
//  ContentView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import Sparkle
import SwiftUI

struct ContentView: View {
    let updater: SPUUpdater
    @State private var selectedItem: String? = "corners"
    @State private var isHovered = false
    @State private var showingAboutModal = false

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
                .padding(.top, 7)
                
                Spacer()
                
                Button {
                    showingAboutModal = true
                } label: {
                    HStack(spacing: 8) {
                        Image("TahoeIcon")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .cornerRadius(4)
                            .padding(.trailing, 3)
                       
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
                    .frame(maxWidth: 150, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isHovered ? Color.gray.opacity(0.15) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    isHovered = hovering
                }
            }
            .frame(minWidth: 175)
        } detail: {
            Group {
                switch selectedItem {
                case "corners":
                    CornerView()
                        .navigationTitle("Corners")
                case "zones":
                    ZoneView()
                        .navigationTitle("Zones")
                case "actions":
                    ActionBrowserView()
                        .navigationTitle("Actions")
                default:
                    Text("No item selected")
                }
            }
        }
        .frame(minWidth: 915, minHeight: 460)
        .sheet(isPresented: $showingAboutModal) {
            AppLinksView()
        }
    }
}
