//
//  CornerHotkey.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import KeyboardShortcuts
import SwiftUI

enum ModifierKey: String, CaseIterable, Identifiable {
    case command = "Command"
    case option = "Option"
    case control = "Control"
    case shift = "Shift"
    case capsLock = "CapsLock"

    var id: String { rawValue }
}

extension ModifierKey {
    var flag: NSEvent.ModifierFlags? {
        switch self {
        case .command: return .command
        case .option: return .option
        case .control: return .control
        case .shift: return .shift
        case .capsLock: return .capsLock
        }
    }
}

var localCornerMonitor: Any?
var globalCornerMonitor: Any?

func activateCornerHotkey() {
    // Activation Using Modifier Key

    @AppStorage("selectedModifierKey") var selectedModifier: ModifierKey = .command
    @AppStorage("enableModifierKey") var enableModifierKey = true
    @AppStorage("enableCornerHover") var enableCornerHover = true
    @AppStorage("enableCornerClick") var enableCornerClick = false

    var modifierKeyPressed = false

    NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
        let selectedRaw = UserDefaults.standard.string(forKey: "selectedModifierKey") ?? "Command"
        let selectedModifier = ModifierKey(rawValue: selectedRaw) ?? .command

        if enableCornerHover {
            if enableModifierKey {
                if let modifierFlag = selectedModifier.flag {
                    let modifierPressed = event.modifierFlags.contains(modifierFlag)

                    if modifierPressed, !modifierKeyPressed {
                        modifierKeyPressed = true
                        localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                            getCornerMousePosition()
                            return event
                        }

                        globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
                            getCornerMousePosition()
                        }
                    } else if !modifierPressed, modifierKeyPressed {
                        modifierKeyPressed = false
                        if let local = localCornerMonitor {
                            NSEvent.removeMonitor(local)
                            localCornerMonitor = nil
                        }

                        if let global = globalCornerMonitor {
                            NSEvent.removeMonitor(global)
                            globalCornerMonitor = nil
                        }
                    }
                }
            }
        }

        return event
    }

    globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged]) { event in
        let selectedRaw = UserDefaults.standard.string(forKey: "selectedModifierKey") ?? "Command"
        let selectedModifier = ModifierKey(rawValue: selectedRaw) ?? .command

        if enableCornerHover {
            if enableModifierKey {
                if let modifierFlag = selectedModifier.flag {
                    let modifierPressed = event.modifierFlags.contains(modifierFlag)

                    if modifierPressed, !modifierKeyPressed {
                        modifierKeyPressed = true
                        localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                            getCornerMousePosition()
                            return event
                        }

                        globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
                            getCornerMousePosition()
                        }
                    } else if !modifierPressed, modifierKeyPressed {
                        modifierKeyPressed = false
                        if let local = localCornerMonitor {
                            NSEvent.removeMonitor(local)
                            localCornerMonitor = nil
                        }

                        if let global = globalCornerMonitor {
                            NSEvent.removeMonitor(global)
                            globalCornerMonitor = nil
                        }
                    }
                }
            }
        }
    }

    // Activation Using Corner Clicks

    NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged]) { event in
        let selectedRaw = UserDefaults.standard.string(forKey: "selectedModifierKey") ?? "Command"
        let selectedModifier = ModifierKey(rawValue: selectedRaw) ?? .command

        if enableCornerClick {
            if enableModifierKey {
                if let modifierFlag = selectedModifier.flag {
                    let modifierPressed = event.modifierFlags.contains(modifierFlag)

                    if modifierPressed, !modifierKeyPressed {
                        modifierKeyPressed = true
                        localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown]) { event in
                            getCornerMousePosition()
                            return event
                        }

                        globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown]) { _ in
                            getCornerMousePosition()
                        }
                    } else if !modifierPressed, modifierKeyPressed {
                        modifierKeyPressed = false
                        if let local = localCornerMonitor {
                            NSEvent.removeMonitor(local)
                            localCornerMonitor = nil
                        }

                        if let global = globalCornerMonitor {
                            NSEvent.removeMonitor(global)
                            globalCornerMonitor = nil
                        }
                    }
                }
            }
        }

        return event
    }

    globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.flagsChanged]) { event in
        let selectedRaw = UserDefaults.standard.string(forKey: "selectedModifierKey") ?? "Command"
        let selectedModifier = ModifierKey(rawValue: selectedRaw) ?? .command

        if enableCornerClick {
            if enableModifierKey {
                if let modifierFlag = selectedModifier.flag {
                    let modifierPressed = event.modifierFlags.contains(modifierFlag)

                    if modifierPressed, !modifierKeyPressed {
                        modifierKeyPressed = true
                        localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown]) { event in
                            getCornerMousePosition()
                            return event
                        }

                        globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown]) { _ in
                            getCornerMousePosition()
                        }
                    } else if !modifierPressed, modifierKeyPressed {
                        modifierKeyPressed = false
                        if let local = localCornerMonitor {
                            NSEvent.removeMonitor(local)
                            localCornerMonitor = nil
                        }

                        if let global = globalCornerMonitor {
                            NSEvent.removeMonitor(global)
                            globalCornerMonitor = nil
                        }
                    }
                }
            }
        }
    }

    // Activation Using Keyboard Shortcut + Hover

    if KeyboardShortcuts.Name.cornerActivation.shortcut == nil {
        KeyboardShortcuts.setShortcut(.init(.space, modifiers: [.control, .shift]), for: .cornerActivation)
    }

    if enableCornerHover {
        KeyboardShortcuts.onKeyDown(for: .cornerActivation) {
            localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { event in
                getCornerMousePosition()
                return event
            }

            globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
                getCornerMousePosition()
            }
        }

        KeyboardShortcuts.onKeyUp(for: .cornerActivation) {
            if let local = localCornerMonitor {
                NSEvent.removeMonitor(local)
                localCornerMonitor = nil
            }

            if let global = globalCornerMonitor {
                NSEvent.removeMonitor(global)
                globalCornerMonitor = nil
            }
        }
    }

    // Activation Using Keyboard Shortcut + Click

    if enableCornerClick {
        KeyboardShortcuts.onKeyDown(for: .cornerActivation) {
            localCornerMonitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown]) { event in
                getCornerMousePosition()
                return event
            }

            globalCornerMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown]) { _ in
                getCornerMousePosition()
            }
        }

        KeyboardShortcuts.onKeyUp(for: .cornerActivation) {
            if let local = localCornerMonitor {
                NSEvent.removeMonitor(local)
                localCornerMonitor = nil
            }

            if let global = globalCornerMonitor {
                NSEvent.removeMonitor(global)
                globalCornerMonitor = nil
            }
        }
    }
}
