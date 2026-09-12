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

    // Config Management

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
                print("Failed to load config \(error)")
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

    func saveConfig() {
        do {
            let config = ActionsConfig(actionSets: actionSets)
            let data = try JSONEncoder().encode(config)

            try data.write(to: configURL, options: .atomic)
        } catch {
            print("Failed to save config: \(error)")
        }
    }

    // Set Management

    func createSet(name: String, targetBundleID: String) {
        let id = UUID().uuidString

        let newSet = ActionSet(
            id: id,
            name: name,
            targetBundleID: targetBundleID,
            corners: CornerAssignments(
                topLeft: ActionAssignment(actionID: "doNothing", input: nil),
                topRight: ActionAssignment(actionID: "doNothing", input: nil),
                bottomLeft: ActionAssignment(actionID: "doNothing", input: nil),
                bottomRight: ActionAssignment(actionID: "doNothing", input: nil)
            ),
            zones: ZoneAssignments(
                top: ActionAssignment(actionID: "doNothing", input: nil),
                left: ActionAssignment(actionID: "doNothing", input: nil),
                right: ActionAssignment(actionID: "doNothing", input: nil),
                bottom: ActionAssignment(actionID: "doNothing", input: nil)
            ),
            activation: SetActivation(method: .none, trigger: .hover, keyboardShortcutName: "actionSet_\(id)")
        )

        actionSets.append(newSet)
        saveConfig()
    }

    func deleteSet(id: String) {
        actionSets.removeAll { set in
            set.targetBundleID != nil && set.id == id
        }

        saveConfig()
    }

    func assignAction(
        actionID: String,
        input: String?,
        position: CornerPosition.Corner,
        setID: String
    ) {
        guard let index = actionSets.firstIndex(where: { $0.id == setID }) else {
            return
        }

        let assignment = ActionAssignment(actionID: actionID, input: input)

        switch position {
        case .topLeft:
            actionSets[index].corners.topLeft = assignment

        case .topRight:
            actionSets[index].corners.topRight = assignment

        case .bottomLeft:
            actionSets[index].corners.bottomLeft = assignment

        case .bottomRight:
            actionSets[index].corners.bottomRight = assignment

        case .top:
            actionSets[index].zones.top = assignment

        case .left:
            actionSets[index].zones.left = assignment

        case .right:
            actionSets[index].zones.right = assignment

        case .bottom:
            actionSets[index].zones.bottom = assignment
        }

        saveConfig()
    }

    func updateActivation(
        setID: String,
        method: ActivationMethod,
        trigger: ActivationTrigger,
        modifierKey: ModifierKey?,
        keyboardShortcutName: String?
    ) {
        guard let index = actionSets.firstIndex(where: { $0.id == setID }) else {
            return
        }

        actionSets[index].activation = SetActivation(
            method: method,
            trigger: trigger,
            modifierKey: modifierKey,
            keyboardShortcutName: keyboardShortcutName
        )

        saveConfig()
    }

    func findActionSets(bundleID: String?) -> [ActionSet] {
        if let bundleID {
            let appSets = actionSets.filter {
                $0.targetBundleID?.caseInsensitiveCompare(bundleID) == .orderedSame
            }

            if !appSets.isEmpty {
                return appSets
            }
        }

        return actionSets.filter {
            $0.targetBundleID == nil
        }
    }
}
