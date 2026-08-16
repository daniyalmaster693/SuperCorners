//
//  AppDelgate.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2026-08-16.
//

import AppKit
import SwiftUI
import TourKit

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private let tour = TourKitWindowController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let hasShownTour = UserDefaults.standard.bool(forKey: "hasShownTour")

        if !hasShownTour {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)

            tour.present(
                pages: [
                    TourPage(imageName: "tour-welcome", title: "Welcome to SuperCorners", description: "Supercharge your Mac's Corners"),
                ],
                width: 850,
                continueButtonTitle: "Continue",
                finishButtonTitle: "Get Started",
                onFinish: {
                    UserDefaults.standard.set(true, forKey: "hasShownTour")
                    NSApp.setActivationPolicy(.accessory)
                },
                onClose: {
                    UserDefaults.standard.set(true, forKey: "hasShownTour")
                    NSApp.setActivationPolicy(.accessory)
                }
            )
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
