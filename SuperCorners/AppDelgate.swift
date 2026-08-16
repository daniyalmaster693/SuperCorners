//
//  AppDelgate.swift
//  MenuScores
//
//  Created by Daniyal Master on 2026-07-06.
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
                    TourPage(imageName: "tour-welcome", title: "Welcome to MenuScores", description: "Live Scores, Designed for Mac"),
                    TourPage(imageName: "tour-detailed", title: "Sleek and Minimal Display", description: "Stay effortlessly updated from the Menubar or Notch."),
                    TourPage(imageName: "tour-views", title: "Know the Matchup", description: "View relevant details before games to stay up to date."),
                    TourPage(imageName: "tour-favorites", title: "Track your Favorite Teams", description: "Choose your favorite teams and we'll handle the pinning for you."),
                    TourPage(imageName: "tour-leagues", title: "48+ Leagues to Choose From", description: "Track over 48 different leagues across 12 different sports."),

                ],
                width: 660,
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
