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

    func loadDefaultConfig() {
        guard let url = Bundle.main.url(forResource: "default-config", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(ActionsConfig.self, from: data)
        else {
            fatalError("Failed to load or decode default-config.json")
        }

        actionSets = config.actionSets
    }
}
