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

    @State private var refreshID = UUID()

    private var isFavorite: Bool {
        favoriteActionIDs[action.id] != nil
    }

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

                Button(action: {
                    var updatedIDs = favoriteActionIDs
                    let newIsFavorite: Bool

                    if favoriteActionIDs[action.id] != nil {
                        updatedIDs.removeValue(forKey: action.id)
                        newIsFavorite = false
                    } else {
                        updatedIDs[action.id] = action.id
                        newIsFavorite = true
                    }

                    favoriteActionIDs = updatedIDs
                    refreshID = UUID()

                    let toastMessage = newIsFavorite ? "Action Added to Favorites" : "Action Removed from Favorites"
                    let toastIcon = Image(systemName: newIsFavorite ? "star.fill" : "star.slash")
                    showSuccessToast(toastMessage, icon: toastIcon)
                }) {
                    Image(systemName: favoriteActionIDs[action.id] != nil ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding(8)
                        .foregroundColor(.white)
                }
                .id(refreshID)
                .buttonStyle(.plain)
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
        .background(Color.accentColor)
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
                    Text("App Actions")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Trigger in App Actions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "App Actions" }) { action in
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
                    Text("Finder")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Quick access to essential Finder tools and commands.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Finder" }) { action in
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
                    Text("Tools")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("A collection of built in utilites for quick access to useful system features")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Tool" }) { action in
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
                    Text("Developer")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("A collection of built in utilites for quick access to system info")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Developer" }) { action in
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
                    
                    Text("Control your Mac’s sound and playback settings.")
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
                
                VStack {
                    Text("Accessibility")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("Quickly enable essential accessibility features")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(cornerActions).filter { $0.tag == "Accessibility" }) { action in
                                ActionCard(action: action)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 6)
                    }
                    .padding(.bottom, 24)
                }
            }
            .padding(.leading, 6)
        }
    }
}
