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
        loadDefaultConfig()
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
    }

    func loadDefaultConfig() {
        guard let url = Bundle.main.url(forResource: "default-config", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(ActionsConfig.self, from: data)
        else {
            fatalError("Failed to load default-config.json")
        }

        actionSets = config.actionSets
    }
}
