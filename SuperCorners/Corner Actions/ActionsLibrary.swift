//
//  ActionsLibrary.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct CornerAction: Identifiable {
    let id: String 
    let title: String
    let description: String
    let iconName: String
    let tag: String
    let perform: () -> Void
}

let cornerActions: [CornerAction] = [
    CornerAction(
        id: "0",
        title: "Start Screen Saver",
        description: "Activate the screen saver",
        iconName: "display",
        tag: "system",
        perform: {
            let path = "/System/Library/CoreServices/ScreenSaverEngine.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "1",
        title: "Trigger Hotkey",
        description: "Simulate a custom hotkey press.",
        iconName: "keyboard",
        tag: "system",
        perform: {
            let src = CGEventSource(stateID: .hidSystemState)
            let keyCodeO: CGKeyCode = 31

            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: keyCodeO, keyDown: true)
            keyDown?.flags = [.maskCommand, .maskShift]

            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: keyCodeO, keyDown: false)
            keyUp?.flags = [.maskCommand, .maskShift]

            let loc = CGEventTapLocation.cghidEventTap
            keyDown?.post(tap: loc)
            keyUp?.post(tap: loc)
        }
    ),
    
    CornerAction(
        id: "2",
        title: "Put Display to Sleep",
        description: "Sleep your Mac",
        iconName: "moon.fill",
        tag: "System",
        perform: {
            let task = Process()
            task.launchPath = "/usr/bin/pmset"
            task.arguments = ["displaysleepnow"]
            try? task.run()
        }
    ),
    
    CornerAction(
        id: "3",
        title: "Open YouTube",
        description: "Launch YouTube in your default browser.",
        iconName: "play.rectangle",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://youtube.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "4",
        title: "Open Gmail",
        description: "Launch Gmail in your default browser.",
        iconName: "envelope",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://mail.google.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "5",
        title: "Open Reddit",
        description: "Launch Reddit in your default browser.",
        iconName: "bubble.left.and.bubble.right",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://reddit.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "6",
        title: "Open Twitter",
        description: "Launch Twitter in your default browser.",
        iconName: "bird",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://twitter.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "7",
        title: "Open Discord",
        description: "Launch Discord in your default browser.",
        iconName: "bubble.left.and.exclamationmark.bubble.right",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://discord.com/app") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "8",
        title: "Open Slack",
        description: "Launch Slack in your default browser.",
        iconName: "number",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://slack.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "9",
        title: "Open ChatGPT",
        description: "Launch ChatGPT in your default browser.",
        iconName: "brain.head.profile",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://chat.openai.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "10",
        title: "Open Gemini",
        description: "Launch Google Gemini in your default browser.",
        iconName: "sparkles",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://gemini.google.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "11",
        title: "Open Figma",
        description: "Launch Figma in your default browser.",
        iconName: "paintpalette",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://www.figma.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "12",
        title: "Open Notion",
        description: "Launch Notion in your default browser.",
        iconName: "square.and.pencil",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://www.notion.so") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "13",
        title: "Open Todoist",
        description: "Launch Todoist in your default browser.",
        iconName: "checkmark.circle",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://todoist.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "14",
        title: "Open Google Calendar",
        description: "Launch Google Calendar in your default browser.",
        iconName: "calendar",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://calendar.google.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "15",
        title: "Open Hacker News",
        description: "Launch Hacker News in your default browser.",
        iconName: "newspaper",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://news.ycombinator.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "16",
        title: "Open GitHub",
        description: "Launch GitHub in your default browser.",
        iconName: "chevron.left.slash.chevron.right",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://github.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "17",
        title: "Open Stack Overflow",
        description: "Launch Stack Overflow in your default browser.",
        iconName: "questionmark.circle",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://stackoverflow.com") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "18",
        title: "Open Wikipedia",
        description: "Launch Wikipedia in your default browser.",
        iconName: "book",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://en.wikipedia.org") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "19",
        title: "Open Claude AI",
        description: "Launch Claude AI in your default browser.",
        iconName: "bubble.left.and.text.bubble.right",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://claude.ai") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "20",
        title: "Open Perplexity",
        description: "Launch Perplexity in your default browser.",
        iconName: "questionmark.circle",
        tag: "Web",
        perform: {
            if let url = URL(string: "https://www.perplexity.ai") {
                NSWorkspace.shared.open(url)
            }
        }
    ),
    
    CornerAction(
        id: "21",
        title: "Open Apple Music",
        description: "Open the Apple Music application.",
        iconName: "music.note",
        tag: "App",
        perform: {
            let path = "/System/Applications/Music.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "22",
        title: "Open Spotify",
        description: "Open the Spotify application.",
        iconName: "music.note.list",
        tag: "App",
        perform: {
            let path = "/Applications/Spotify.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "23",
        title: "Open Clock",
        description: "Open the Clock application.",
        iconName: "clock",
        tag: "App",
        perform: {
            let path = "/System/Applications/Clock.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "24",
        title: "Open Calculator",
        description: "Open the Calculator application.",
        iconName: "plus.slash.minus",
        tag: "App",
        perform: {
            let path = "/System/Applications/Calculator.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "25",
        title: "Open Reminders",
        description: "Open the Reminders application.",
        iconName: "list.bullet",
        tag: "App",
        perform: {
            let path = "/System/Applications/Reminders.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "26",
        title: "Open Safari",
        description: "Open the Safari web browser.",
        iconName: "safari",
        tag: "App",
        perform: {
            let path = "/System/Applications/Safari.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "27",
        title: "Open Finder",
        description: "Open a new Finder window.",
        iconName: "folder",
        tag: "App",
        perform: {
            let path = "/System/Library/CoreServices/Finder.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "28",
        title: "Open Terminal",
        description: "Open the Terminal application.",
        iconName: "terminal",
        tag: "App",
        perform: {
            let path = "/System/Applications/Utilities/Terminal.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "29",
        title: "Open Xcode",
        description: "Open the Xcode application.",
        iconName: "hammer",
        tag: "App",
        perform: {
            let path = "/Applications/Xcode.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "30",
        title: "Open Visual Studio Code",
        description: "Open the Visual Studio Code application.",
        iconName: "curlybraces",
        tag: "App",
        perform: {
            let path = "/Applications/Visual Studio Code.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "31",
        title: "Open Obsidian",
        description: "Open the Obsidian application.",
        iconName: "circle.lefthalf.fill",
        tag: "App",
        perform: {
            let path = "/Applications/Obsidian.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "32",
        title: "Open Calendar",
        description: "Open the Calendar application.",
        iconName: "calendar",
        tag: "App",
        perform: {
            let path = "/System/Applications/Calendar.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "33",
        title: "Open Messages",
        description: "Open the Messages application.",
        iconName: "message",
        tag: "App",
        perform: {
            let path = "/System/Applications/Messages.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
    
    CornerAction(
        id: "34",
        title: "Open Mail",
        description: "Open the Mail application.",
        iconName: "envelope",
        tag: "App",
        perform: {
            let path = "/System/Applications/Mail.app"
            NSWorkspace.shared.open(URL(fileURLWithPath: path))
        }
    ),
]
