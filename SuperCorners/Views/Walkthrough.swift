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
    @State private var accesibilityStatusMessage: String?

    let totalPages = 7
    let titles = [
        "Welcome to SuperCorners!",
        "Activation",
        "Assigning Actions",
        "Creating and Editing Actions",
        "Privacy & Security",
        "Permissions",
        "Ready to Start"
    ]
    
    let welcomeDescription = "This walkthrough will guide you through the main features and details of the app."
    
    let activation = [
        ("Activating Corners", "Hold the Control + Option + C hotkey (customizable in settings), then move your mouse to any screen corner to trigger assigned actions."),
        ("Using Zones", "You can also trigger Zones, which let you assign actions to the top, bottom, left, and right edges of the screen."),
        ("Hotkey Customization", "In the settings menu, you can change which modifier keys and activation key are used to detect movement to corners or zones.")
    ]
    
    let assigningActions = [
        ("Assigning Corners", "Open the configuriatino menu and click any corner or zone in the interface to assign a custom action."),
        ("Using the Action Library", "Choose from built-in actions or create your own using the Action Editor."),
    ]
    
    let creatingAndEditingActions = [
        ("Creating Actions", "Click the plus icon in the corners or zones menu to open the action editor. From there you can choose a premade template or create a custom action."),
        ("Editing Actions", "Clcik the actions tab to view the action library. Click the edit icon on an action to open it in the action editor."),
    ]
    
    let privacySections = [
        ("Data Collection", "We respect your privacy and do not collect any data."),
        ("Network Access", "Internet access is not required, but is only used for actions that require it."),
    ]
    
    let permissionsSection = [
        ("Accessibility", "Accessibility permission is required in order for the app to record mouse and keyboard input, and to trigger actions."),
        ("Mouse and Keyboard Input", "Inputs are only recorded for the sole function of the app, and are not stored. Mouse input is only recorded when the hotkey is activated."),
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
                            Image(systemName: "bolt.circle")
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
                            ForEach(activation, id: \.0) { section in
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
                            Image(systemName: "cursorarrow.click.2")
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
                            ForEach(assigningActions, id: \.0) { section in
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
                            Image(systemName: "hammer")
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
                            ForEach(creatingAndEditingActions, id: \.0) { section in
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
                    
                } else if currentPage == 4 {
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
                } else if currentPage == 5 {
                        HStack(alignment: .top, spacing: 20) {
                            VStack(alignment: .leading, spacing: 16) {
                                Image(systemName: "shield.lefthalf.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.accentColor)

                                Text(titles[currentPage])
                                    .font(.title)
                                    .bold()
                                
                                Button("Grant Accessibility") {
                                    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
                                    let accessEnabled = AXIsProcessTrustedWithOptions(options)
                                    accesibilityStatusMessage = accessEnabled ? "Accessibility permissions granted!" : "Accessibility permissions were not granted."
                                }
                                .buttonStyle(.bordered)
                                .padding(.top, 4)
                                
                                if let message = accesibilityStatusMessage {
                                    Text(message)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 2)
                                }
                            }
                            .frame(width: 180, alignment: .leading)

                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(permissionsSection, id: \.0) { section in
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
                } else if currentPage == 6 {
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
