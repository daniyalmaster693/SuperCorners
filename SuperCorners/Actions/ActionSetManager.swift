//
//  ActionSetManager.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-09-07.
//

import Foundation

class ActionSetManager: ObservableObject {
    static let shared = ActionSetManager()

    @Published var actionSets: [ActionSet] = []

    private init() {
        loadConfig()
    }

    private var applicationSupportDirectory: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("SuperCorners", isDirectory: true)
    }

    private var configURL: URL {
        applicationSupportDirectory.appendingPathComponent("config.json")
    }

    func loadConfig() {
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: configURL.path) {
            do {
                let data = try Data(contentsOf: configURL)
                let config = try JSONDecoder().decode(ActionsConfig.self, from: data)

                actionSets = config.actionSets
                return
            } catch {
                print(error)
            }
        }

        createConfig()
    }

    private func createConfig() {
        guard let defaultURL = Bundle.main.url(forResource: "default-config", withExtension: "json") else {
            fatalError("Could not find default-config.json")
        }

        do {
            let data = try Data(contentsOf: defaultURL)
            let config = try JSONDecoder().decode(ActionsConfig.self, from: data)

            actionSets = config.actionSets

            try createApplicationSupportDirectory()

            try data.write(to: configURL, options: .atomic)
        } catch {
            fatalError()
        }
    }

    private func createApplicationSupportDirectory() throws {
        try FileManager.default.createDirectory(at: applicationSupportDirectory, withIntermediateDirectories: true)
    }
}
