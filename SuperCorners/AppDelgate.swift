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
                    TourPage(imageName: "tour-zones", title: "More Ways to Trigger", description: "Go beyond the corners with 4 additional zones at each edge of your display."),
                    TourPage(imageName: "tour-actions", title: "Powerful Actions", description: "Trigger over 50 different actions to enable powerful workflows."),
                    TourPage(imageName: "tour-activation", title: "Customizable Activation", description: "Optionally choose between modifier keys, keyboard shortcuts, hovering or clicking."),
                    TourPage(imageName: "tour-accessibility", title: "Enable Accessibility Permissions", description: "Give SuperCorners accessibility permission for the best experience."),
                    TourPage(imageName: "tour-default", title: "Disable Default Hot Corners", description: "Disable the built in hot corners feature for the best experience."),
                ],
                width: 900,
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
