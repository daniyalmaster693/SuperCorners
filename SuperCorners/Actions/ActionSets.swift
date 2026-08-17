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

class ActionSetManager {
    static let shared = ActionSetManager()
    
    let availableSets: [ActionSet] = [
        ActionSet(name: "Global Actions", targetBundleID: nil),
        ActionSet(name: "Safari Actions", targetBundleID: "com.apple.Safari"),
        ActionSet(name: "Xcode Actions", targetBundleID: "com.apple.dt.Xcode")
    ]
    
    private init() {}
    
    // Set Management
    
    func createSet() {}
    
    func editSet() {}
    
    func deleteSet() {}
    
    func saveSet() {}
    
    // Set Logic
    
    func activeSet() -> ActionSet {
        if let frontApp = NSWorkspace.shared.frontmostApplication,
           let bundleID = frontApp.bundleIdentifier
        {
            if let matchedSet = availableSets.first(where: { $0.targetBundleID == bundleID }) {
                return matchedSet
            }
        }
           
        return availableSets.first!
    }
}
