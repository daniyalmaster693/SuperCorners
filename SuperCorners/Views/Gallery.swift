//
//  Gallery.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct GalleryItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
}

struct GalleryCard: View {

    let item: GalleryItem
    
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
        .background(Color.purple.opacity(0.75))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

let systemActions: [GalleryItem] = [
    GalleryItem(title: "Lock Screen", description: "Lock your Mac screen immediately.", iconName: "lock.fill"),
    GalleryItem(title: "Put Display to Sleep", description: "Turn off your display without sleeping.", iconName: "display"),
    GalleryItem(title: "Start Screen Saver", description: "Activate your screen saver.", iconName: "playpause"),
    GalleryItem(title: "Disable Screen Saver", description: "Prevent the screen saver from starting.", iconName: "pause.circle"),
    GalleryItem(title: "Show Desktop", description: "Hide all windows to show desktop.", iconName: "desktopcomputer"),
    GalleryItem(title: "Restart Mac", description: "Prompt a system restart immediately.", iconName: "arrow.clockwise.circle.fill"),
    GalleryItem(title: "Shutdown Mac", description: "Quickly initiate a system shutdown.", iconName: "power"),
    GalleryItem(title: "Toggle Dark Mode", description: "Switch between light and dark appearance.", iconName: "moon.fill"),
    GalleryItem(title: "Open Notification Center", description: "Show the macOS Notification Center.", iconName: "bell"),
    GalleryItem(title: "Open Mission Control", description: "Show all open windows and spaces.", iconName: "rectangle.stack.fill"),
    GalleryItem(title: "Show Application Windows", description: "View all windows of the active application.", iconName: "app.badge"),
    GalleryItem(title: "Open Launchpad", description: "Open the Launchpad to see your apps.", iconName: "square.grid.2x2")
]

let Web: [GalleryItem] = [
    GalleryItem(title: "Open Safari", description: "Launch Safari to your default homepage.", iconName: "safari"),
    GalleryItem(title: "Open Gmail", description: "Open Gmail in your default browser.", iconName: "envelope"),
    GalleryItem(title: "Open YouTube", description: "Launch YouTube in your browser.", iconName: "play.rectangle"),
    GalleryItem(title: "Open Twitter", description: "Open Twitter in your browser.", iconName: "bird"),
    GalleryItem(title: "Open Reddit", description: "Open Reddit in your browser.", iconName: "bubble.left.and.bubble.right")
]

let Apps: [GalleryItem] = [
    GalleryItem(title: "Quick Note", description: "Quickly open the Notes app.", iconName: "note.text"),
    GalleryItem(title: "Open Calendar", description: "Open the Calendar app.", iconName: "calendar"),
    GalleryItem(title: "Open Messages", description: "Start a conversation in Messages.", iconName: "message.fill"),
    GalleryItem(title: "Open Reminders", description: "Launch Reminders to manage tasks.", iconName: "checklist"),
    GalleryItem(title: "Open Music", description: "Launch Apple Music to listen to music", iconName: "music.note")
]

let SoundAndMedia: [GalleryItem] = [
    GalleryItem(title: "Play/Pause Music", description: "Toggle media playback.", iconName: "playpause"),
    GalleryItem(title: "Next Track", description: "Skip to the next media track.", iconName: "forward.fill"),
    GalleryItem(title: "Previous Track", description: "Go back to the previous track.", iconName: "backward.fill"),
    GalleryItem(title: "Mute Volume", description: "Mute system audio output.", iconName: "speaker.slash.fill"),
    GalleryItem(title: "Increase Volume", description: "Raise system volume.", iconName: "speaker.wave.2.fill"),
    GalleryItem(title: "Decrease Volume", description: "Lower system volume.", iconName: "speaker.wave.1.fill")
]

let DeveloperUtils: [GalleryItem] = [
    GalleryItem(title: "Open Terminal", description: "Launch Terminal for command-line tasks.", iconName: "terminal.fill"),
    GalleryItem(title: "Open Activity Monitor", description: "View system processes and usage.", iconName: "waveform.path.ecg"),
    GalleryItem(title: "Toggle Hidden Files", description: "Show or hide hidden files in Finder.", iconName: "eye"),
    GalleryItem(title: "Empty Trash", description: "Clear the Trash instantly.", iconName: "trash.fill"),
    GalleryItem(title: "Take Screenshot", description: "Capture your current screen.", iconName: "camera")
]

struct GalleryView: View {
    @State private var searchText = ""

    func filteredItems(_ items: [GalleryItem]) -> [GalleryItem] {
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
                    Text("System Actions")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    Text("Browse a curated list of system actions you can assign to corners or zones.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(systemActions)) { item in
                                GalleryCard(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 6)
                }

                Divider()
                    .padding(.horizontal)

                VStack {
                    Text("Web")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 24)

                    Text("Launch your favorite websites instantly.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(Web)) { item in
                                GalleryCard(item: item)
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
                    Text("Apps")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 24)

                    Text("Quick access to your most-used apps.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(Apps)) { item in
                                GalleryCard(item: item)
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
                    Text("Sound & Media")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 24)

                    Text("Control your music and sound settings.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(SoundAndMedia)) { item in
                                GalleryCard(item: item)
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
                    Text("Developer Utilities")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 24)

                    Text("Useful tools for power users and developers.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredItems(DeveloperUtils)) { item in
                                GalleryCard(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 6)
                }
                .padding(.bottom, 24)
            }
            .padding(.vertical)
        }
        .navigationTitle("Gallery")
        .searchable(text: $searchText)
    }
}
