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
    
    let item: ActionItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: item.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
                    .padding(.top, 16)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.purple)
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            Text(item.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 8)

            Text(item.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(2)

            Spacer()
        }
        .padding()
        .frame(width: 220, height: 130)
        .background(Color.blue.opacity(0.75))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

let actionLibrary: [ActionItem] = [
    ActionItem(title: "Lock Screen", description: "Lock your Mac screen immediately.", iconName: "lock.fill"),
    ActionItem(title: "Put Display to Sleep", description: "Turn off your display without sleeping.", iconName: "display"),
    ActionItem(title: "Start Screen Saver", description: "Activate your screen saver.", iconName: "playpause"),
    ActionItem(title: "Disable Screen Saver", description: "Prevent the screen saver from starting.", iconName: "pause.circle"),
    ActionItem(title: "Show Desktop", description: "Hide all windows to show desktop.", iconName: "desktopcomputer"),
    ActionItem(title: "Restart Mac", description: "Prompt a system restart immediately.", iconName: "arrow.clockwise.circle.fill"),
    ActionItem(title: "Shutdown Mac", description: "Quickly initiate a system shutdown.", iconName: "power"),
    ActionItem(title: "Toggle Dark Mode", description: "Switch between light and dark appearance.", iconName: "moon.fill"),
    ActionItem(title: "Open Notification Center", description: "Show the macOS Notification Center.", iconName: "bell"),
    ActionItem(title: "Open Mission Control", description: "Show all open windows and spaces.", iconName: "rectangle.stack.fill"),
    ActionItem(title: "Show Application Windows", description: "View all windows of the active application.", iconName: "app.badge"),
    ActionItem(title: "Open Launchpad", description: "Open the Launchpad to see your apps.", iconName: "square.grid.2x2")
]

struct ActionBrowserView: View {
    @State private var searchText = ""
    
    func filteredItems(_ items: [ActionItem]) -> [ActionItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("Action Browser")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("Browse a list of actions you can assign to corners or zones.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 240))], spacing: 16) {
                    ForEach(filteredItems(actionLibrary)) { item in
                        ActionCard(item: item)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Actions")
            .searchable(text: $searchText)
        }
    }
}
