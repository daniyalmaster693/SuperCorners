//
//  CornerMousePosition.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

private var lastCorner: CornerPosition.Corner?

func getCornerMousePosition() {
    @AppStorage("triggerSensitivity") var triggerSensitivity = 5.0
    @AppStorage("disableInFullScreen") var disableInFullScreen = false

    @AppStorage("playSoundEffect") var playSoundEffect = false
    @AppStorage("selectedSoundEffect") var selectedSound: SoundEffect = .purr

    enum SoundEffect: String, CaseIterable, Identifiable {
        case basso = "Basso"
        case blow = "Blow"
        case bottle = "Bottle"
        case frog = "Frog"
        case funk = "Funk"
        case glass = "Glass"
        case hero = "Hero"
        case morse = "Morse"
        case ping = "Ping"
        case pop = "Pop"
        case purr = "Purr"
        case sosumi = "Sosumi"
        case submarine = "Submarine"
        case tink = "Tink"

        var id: String { self.rawValue }

        func play() {
            NSSound(named: NSSound.Name(self.rawValue))?.play()
        }
    }

    let mousePosition: NSPoint = NSEvent.mouseLocation

    if disableInFullScreen {
        for window in NSApplication.shared.windows {
            if window.styleMask.contains(.fullScreen) {
                let windowFrame = window.frame
                if windowFrame.contains(mousePosition) {
                    lastCorner = nil
                    return
                }
            }
        }
    }

    for screen in NSScreen.screens {
        let corners: [CornerPosition.Corner] = [.topLeft, .topRight, .bottomLeft, .bottomRight, .top, .left, .right, .bottom]

        for corner in corners {
            let position = CornerPosition(screen: screen, corner: corner)
            let cornerPoint = position.coordinate

            let tolerance: CGFloat = triggerSensitivity * 10
            let hitZone = CGRect(x: cornerPoint.x - tolerance/2, y: cornerPoint.y - tolerance/2, width: tolerance, height: tolerance)

            if hitZone.contains(mousePosition) {
                triggerCornerAction(for: corner)
                if playSoundEffect {
                    NSSound(named: NSSound.Name(selectedSound.rawValue))?.play()
                }

                lastCorner = corner
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    lastCorner = nil
                }

                return
            }
        }
    }

    lastCorner = nil
}
