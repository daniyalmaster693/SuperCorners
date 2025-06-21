//
//  ActionBrowser.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct ActionItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
}

struct ActionCard: View {
    let action: CornerAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: action.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
                    .padding(.top, 16)

                Spacer()
            }

            Text(action.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 8)
            
            Text(action.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(2)

            Spacer()
        }
        .padding()
        .frame(width: 220, height: 130)
        .background(Color.purple.opacity(0.75))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct ActionBrowserView: View {
    @State private var searchText = ""
    
    func filteredItems(_ items: [CornerAction]) -> [CornerAction] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { action in
                action.title.localizedCaseInsensitiveContains(searchText) ||
                    action.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("System Actions")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Browse a set of essential system utilities and controls you can trigger instantly.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "System" }) { action in
                                ActionCard(action: action)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 6)
                }
                .padding(.bottom, 24)
                
                Divider()
                    .padding(.horizontal)
                
                VStack {
                    Text("Template Actions")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Configure these actions for custom websites, apps, and more.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Template Action" }) { action in
                                ActionCard(action: action)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 6)
                }
                .padding(.bottom, 24)
                
                Divider()
                    .padding(.horizontal)
                
                VStack {
                    Text("Capture")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Capture your screen with screenshot tools.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Capture" }) { action in
                                ActionCard(action: action)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 6)
                    }
                    .padding(.bottom, 24)
                    
                    Divider()
                        .padding(.horizontal)
                }
                
                VStack {
                    Text("Media")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Control your Mac’s sound and playback settings with one click.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Media" }) { action in
                                ActionCard(action: action)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 6)
                    }
                    .padding(.bottom, 24)
                    
                    Divider()
                        .padding(.horizontal)
                }
                
                VStack {
                    Text("Window Management")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Organize, move, or resize windows to improve your multitasking flow.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Window Management" }) { action in
                                ActionCard(action: action)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 6)
                    }
                    .padding(.bottom, 24)
                    
                    Divider()
                        .padding(.horizontal)
                }
            }
            .padding(.leading, 6)
        }
    }
}
