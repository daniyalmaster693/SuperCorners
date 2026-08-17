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
}

final class ActionSetManager: ObservableObject {
    static let shared = ActionSetManager()

    @Published var availableSets: [ActionSet] = [
        ActionSet(
            name: "Global Actions",
            targetBundleID: nil
        ),
        ActionSet(
            name: "Safari Actions",
            targetBundleID: "com.apple.safari"
        ),
        ActionSet(
            name: "Xcode Actions",
            targetBundleID: "com.apple.dt.xcode"
        ),
    ]
}
