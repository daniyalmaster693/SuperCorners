//
//  ContentView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct ContentView: View {
    @Binding var selectedTab: SelectedTab
    @State private var isHovered = false
    @State private var showingAboutModal = false

    var body: some View {
        NavigationSplitView {
            VStack {
                List(selection: $selectedTab) {
                    HStack {
                        Image(systemName: "square.grid.2x2")
                            .frame(width: 18, height: 18)
                        Text("Corners")
                    }
                    .tag(SelectedTab.corners)
                    
                    HStack {
                        Image(systemName: "rectangle.leftthird.inset.filled")
                            .frame(width: 18, height: 18)
                        Text("Zones")
                    }
                    .tag(SelectedTab.zones)
                    
                    HStack {
                        Image(systemName: "bolt.circle")
                            .frame(width: 18, height: 18)
                        Text("Actions")
                    }
                    .tag(SelectedTab.actions)
                    
                    HStack {
                        Image(systemName: "gear")
                            .frame(width: 18, height: 18)
                        Text("Settings")
                    }
                    .tag(SelectedTab.settings)
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
                            .fill(isHovered ? Color.gray.opacity(0.05) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
                .padding(.bottom, 10)
                .onHover { hovering in
                    isHovered = hovering
                }
            }
            .frame(minWidth: 175)
        } detail: {
            Group {
                switch selectedTab {
                case .corners:
                    CornerView()
                        .navigationTitle("Corners")
                case .zones:
                    ZoneView()
                        .navigationTitle("Zones")
                case .actions:
                    ActionBrowserView()
                        .navigationTitle("Actions")
                case .settings:
                    SettingsView()
                        .navigationTitle("Settings")
                }
            }
        }
        .frame(minWidth: 915, minHeight: 460)
        .sheet(isPresented: $showingAboutModal) {
            AppLinksView()
        }
    }
}
