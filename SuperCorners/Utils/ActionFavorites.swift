//
//  ActionFavorites.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-07-07.
//

import AppKit
import SwiftUI

var favoriteActionIDs: [String: String] {
    get {
        UserDefaults.standard.dictionary(forKey: "favoriteActionIDs") as? [String: String] ?? [:]
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "favoriteActionIDs")
    }
}

var favoriteActions: [String: CornerAction] {
    var dict: [String: CornerAction] = [:]
    let ids = favoriteActionIDs
    for (key, actionID) in ids {
        if let action = cornerActions.first(where: { $0.id == actionID }) {
            dict[key] = action
        }
    }
    return dict
}
