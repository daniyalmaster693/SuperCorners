//
//  Walkthrough.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI
import UserNotifications

struct WalkthroughView: View {
    @State private var currentPage = 0
    @State private var notificationStatusMessage: String?

    let totalPages = 5
    let titles = [
        "Welcome to SuperCorners!",
        "Menu Bar Actions",
        "Notifications",
        "Privacy & Security",
        "Ready to Start"
    ]
    
    let welcomeDescription = "This walkthrough will guide you through the main features and details of the app."
    
    let menuBarHelpSections = [
        ("Selecting a Game", "Select a game from any league to pin it."),
        ("Refreshing Scores", "Scores update automatically, but you can adjust how often they refresh from the settings window."),
        ("Clearing Selection", "Use the 'Clear Set Game' option to remove the pinned score from the menubar, or simply select a different game.")
    ]
    
    let notificationsSections = [
        ("Game Start Alerts", "Receive notifications when games start, so you never miss a moment."),
        ("Game Completion", "Receive alerts when games end with final scores.")
    ]
    
    let privacySections = [
        ("Data Collection", "We respect your privacy and do not collect any data."),
        ("Network Access", "Internet access is used solely for fetching games and score data."),
        ("API", "All data is sourced directly from the unofficial ESPN Sports API. The accuracy of the data depends on ESPN's public APIs."),
    ]
    
    let readyDescription = "You're all set! Enjoy using the app."

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            HStack(spacing: 40) {
                if currentPage == 0 {
                    HStack(alignment: .center, spacing: 40) {
                        Image(nsImage: NSApplication.shared.applicationIconImage)
                            .resizable()
                            .frame(width: 128, height: 128)

                        VStack(alignment: .leading, spacing: 16) {
                            Text(titles[currentPage])
                                .font(.title)
                                .bold()
                            Text(welcomeDescription)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: 400, alignment: .leading)
                    }
                } else if currentPage == 1 {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            Image(systemName: "menubar.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.accentColor)

                            Text(titles[currentPage])
                                .font(.title)
                                .bold()
                        }
                        .frame(width: 180, alignment: .leading)

                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(menuBarHelpSections, id: \.0) { section in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(section.0)
                                        .font(.headline)
                                    
                                    Text(section.1)
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 2)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: 600)
                } else if currentPage == 2 {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            Image(systemName: "bell.badge")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.accentColor)

                            Text(titles[currentPage])
                                .font(.title)
                                .bold()
                            
                            
                            Button("Enable Notifications") {
                                let center = UNUserNotificationCenter.current()
                                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                    DispatchQueue.main.async {
                                        if let error = error {
                                            notificationStatusMessage = "Error: \(error.localizedDescription)"
                                        } else if granted {
                                            notificationStatusMessage = "Notifications granted!"
                                        } else {
                                            notificationStatusMessage = "Notifications were not allowed."
                                        }
                                    }
                                }
                            }
                            .buttonStyle(.bordered)
                            .padding(.top, 4)
                            
                            if let message = notificationStatusMessage {
                                Text(message)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 2)
                            }
                        }
                        .frame(width: 180, alignment: .leading)

                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(notificationsSections, id: \.0) { section in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(section.0)
                                        .font(.headline)
                                    
                                    Text(section.1)
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 2)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: 600)
                } else if currentPage == 3 {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 16) {
                            Image(systemName: "lock.shield")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.accentColor)

                            Text(titles[currentPage])
                                .font(.title)
                                .bold()
                        }
                        .frame(width: 180, alignment: .leading)

                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(privacySections, id: \.0) { section in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(section.0)
                                        .font(.headline)
                                    
                                    Text(section.1)
                                        .font(.body)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 2)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: 600)
                    
                } else {
                    VStack(alignment: .center, spacing: 16) {
                        Image(systemName: "hands.clap.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.accentColor)

                        Text(titles[currentPage])
                            .font(.title)
                            .bold()
                        
                        Text(readyDescription)
                            .font(.body)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: 400)
                }
            }
            
            Spacer()
            
            HStack {
                Button("Back") {
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                }
                .disabled(currentPage == 0)
                
                Spacer()
                
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.accentColor : Color.gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .animation(.easeInOut, value: currentPage)
                            .onTapGesture {
                                currentPage = index
                            }
                    }
                }
                
                Spacer()
                
                if currentPage < totalPages - 1 {
                    Button("Next") {
                        currentPage += 1
                    }
                } else {
                    Button("Finish") {
                        if let window = NSApplication.shared.keyWindow {
                            window.close()
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: 750, minHeight: 200, idealHeight: 300, maxHeight: .infinity)
        .onAppear {
            if let window = NSApplication.shared.windows.first {
                window.title = ""
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.isMovableByWindowBackground = true
            }
        }
    }
}
