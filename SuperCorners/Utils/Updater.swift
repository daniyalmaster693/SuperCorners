//
//  Updater.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-07-07.
//

import AppKit
import Foundation

class UpdateManager: NSObject, ObservableObject, XMLParserDelegate {
    @Published var updateAvailable: Bool = false
    @Published var latestVersion: String = ""
    @Published var latestRelease: String = ""

    private var currentElement = ""
    private var isManualCheck = false

    var timer: Timer?

    // Update Check System

    func getUpdateData(manualCheck: Bool = false) {
        isManualCheck = manualCheck
        guard let url = URL(string: "https://daniyalmaster693.github.io/MenuScores/appcast.xml") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            guard let data = data else { return }

            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }.resume()
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:])
    {
        currentElement = elementName

        if elementName == "enclosure" {
            DispatchQueue.main.async {
                self.latestVersion = attributeDict["sparkle:shortVersionString"] ?? ""
            }
        }

        if elementName == "sparkle:releaseNotesLink" {
            DispatchQueue.main.async {
                self.latestRelease = ""
            }
        }
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?)
    {
        if elementName == "sparkle:releaseNotesLink" {
            DispatchQueue.main.async {
                self.latestRelease = self.latestRelease.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        currentElement = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "sparkle:releaseNotesLink" {
            DispatchQueue.main.async {
                self.latestRelease += string
            }
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }

        DispatchQueue.main.async {
            self.updateAvailable = currentVersion.compare(self.latestVersion, options: .numeric) == .orderedAscending
            self.showUpdateAlert()
        }
    }

    func showUpdateAlert() {
        NSApp.activate(ignoringOtherApps: true)

        let alert = NSAlert()

        if updateAvailable {
            alert.messageText = "Update Available"
            alert.informativeText = "A new version of MenuScores is available. Click the download button to open the newest release."
            alert.addButton(withTitle: "Download")
            alert.addButton(withTitle: "Cancel")
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                if let url = URL(string: latestRelease) {
                    NSWorkspace.shared.open(url)
                }
            }
        }

        if isManualCheck && !updateAvailable {
            alert.messageText = "Up to Date!"
            alert.informativeText = "Your on the latest version of MenuScores."
            alert.addButton(withTitle: "Done")
            alert.runModal()
        }
    }

    // Auto Update System

    func startTimer(action: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 28800, repeats: true) { _ in
            action()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    override init() {
        super.init()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.getUpdateData(manualCheck: false)
        }

        startTimer { [weak self] in
            self?.getUpdateData(manualCheck: false)
        }
    }

    deinit {
        stopTimer()
    }
}
