//
//  ActionSets.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-08-17.
//

import AppKit
import Foundation

struct ActionSet: Codable, Identifiable {
    var id: UUID = .init()
    var name: String
    var targetBundleID: String?

    var bindings: [String: String] = [:]
    var inputs: [String: String] = [:]
}

final class ActionSetManager: ObservableObject {
    static let shared = ActionSetManager()

    @Published private(set) var availableSets: [ActionSet] = []
    private let storageKey = "actionSets"

    private init() {
        loadSets()
    }

    // Set Management

    func createSet(name: String, targetBundleID: String? = nil) {
        let set = ActionSet(
            name: name,
            targetBundleID: targetBundleID
        )

        availableSets.append(set)
        saveSets()
    }

    func updateSet(_ set: ActionSet) {
        guard let index = availableSets.firstIndex(where: { $0.id == set.id }) else {
            return
        }

        availableSets[index] = set
        saveSets()
    }

    func deleteSet(id: UUID) {
        guard availableSets.count > 1 else {
            return
        }

        availableSets.removeAll { $0.id == id }
        saveSets()
    }

    private func saveSets() {
        guard let data = try? JSONEncoder().encode(availableSets) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func loadSets() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let sets = try? JSONDecoder().decode([ActionSet].self, from: data)
        {
            availableSets = sets
            return
        }

        availableSets = [
            ActionSet(
                name: "Global Actions",
                targetBundleID: nil
            ),
            ActionSet(
                name: "Safari Actions",
                targetBundleID: "com.apple.Safari"
            ),
            ActionSet(
                name: "Xcode Actions",
                targetBundleID: "com.apple.dt.Xcode"
            )
        ]

        saveSets()
    }
}
