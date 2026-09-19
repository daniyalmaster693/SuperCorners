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
                    TourPage(imageName: "tour-zones", title: "More Ways to Trigger", description: "Go beyond the corners with 4 additional zones at each display edge."),
                    TourPage(imageName: "tour-actions", title: "Powerful Actions", description: "Trigger over 70 different actions to enable powerful workflows."),
                    TourPage(imageName: "tour-sets", title: "Custom Action Sets", description: "Set actions per app with different activation methods."),
                    TourPage(imageName: "tour-accessibility", title: "Enable Accessibility Permissions", description: "Enable accessiblty permission to allow SuperCorners to perform system actions."),
                    TourPage(imageName: "tour-default", title: "Disable Default Hot Corners", description: "Disable macOS Hot Corners to prevent conflicts with SuperCorners."),
                ],
                width: 800,
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
