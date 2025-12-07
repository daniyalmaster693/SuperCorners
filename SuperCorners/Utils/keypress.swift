import CoreGraphics
import Foundation

let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
let loc = CGEventTapLocation.cghidEventTap

public enum keypress {
    enum KeyError: Error {
        case KeyNotFound
    }

    private static func check(_ key: String) throws {
        let key = key.lowercased()

        guard keyCode[key] != nil || ShiftKeyCode[key] != nil else {
            throw KeyError.KeyNotFound
        }
    }

    private static func isStringAnInt(_ string: String) -> Bool {
        return Int(string) != nil
    }

    private static func docheck(_ key: String) {
        do {
            try check(key)
        } catch KeyError.KeyNotFound {
            print("Key not found.")
        } catch {
            print("Unknown error.")
        }
    }

    public static func write(_ str: String) {
        for char in str {
            if String(char).containsWhitespace() {
                continue
            }
            docheck(String(char))
        }

        for char in str {
            if String(char).containsWhitespace() {
                let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode["space"]!), keyDown: true)
                let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode["space"]!), keyDown: false)
                key_down?.post(tap: loc)
                key_up?.post(tap: loc)

            } else if String(char).isUppercase, !isStringAnInt(String(char)), keyCode[String(char).lowercased()] != nil {
                let key_down_shift = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: true)
                let key_up_shift = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: false)
                let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[String(char).lowercased()]!), keyDown: true)
                let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[String(char).lowercased()]!), keyDown: false)
                key_down?.flags = CGEventFlags.maskShift
                key_down_shift?.post(tap: loc)
                key_down?.post(tap: loc)
                key_up?.post(tap: loc)
                key_up_shift?.post(tap: loc)

            } else if keyCode[String(char)] == nil {
                let key_down_shift = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: true)
                let key_up_shift = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: false)
                let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(ShiftKeyCode[String(char)]!), keyDown: true)
                let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(ShiftKeyCode[String(char)]!), keyDown: false)
                key_down?.flags = CGEventFlags.maskShift
                key_down_shift?.post(tap: loc)
                key_down?.post(tap: loc)
                key_up?.post(tap: loc)
                key_up_shift?.post(tap: loc)

            } else {
                let char_low = String(char).lowercased()
                let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[char_low]!), keyDown: true)
                let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[char_low]!), keyDown: false)
                key_down?.post(tap: loc)
                key_up?.post(tap: loc)
            }
        }
    }

    public static func press(_ key: String) {
        docheck(key)
        let key = key.lowercased()

        if keyCode[key] == nil {
            let key_down_shift = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: true)
            let key_up_shift = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: false)
            let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(ShiftKeyCode[key]!), keyDown: true)
            let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(ShiftKeyCode[key]!), keyDown: false)
            key_down?.flags = CGEventFlags.maskShift
            key_down_shift?.post(tap: loc)
            key_down?.post(tap: loc)
            key_up?.post(tap: loc)
            key_up_shift?.post(tap: loc)

        } else {
            let key_down = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[key]!), keyDown: true)
            let key_up = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCode[key]!), keyDown: false)

            key_down?.post(tap: loc)
            key_up?.post(tap: loc)
        }
    }

    public static func hotkey(modifiers: [String], key: String) {
        for mod in modifiers {
            docheck(mod)
        }
        docheck(key)

        let key_lower = key.lowercased()

        var flags = CGEventFlags()
        var modifierEventsDown: [CGEvent] = []
        var modifierEventsUp: [CGEvent] = []

        for mod in modifiers {
            let modLower = mod.lowercased()
            switch modLower {
            case "command", "⌘", "cmd":
                flags.insert(.maskCommand)
                if let keyCodeMod = keyCode["command"] {
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                } else {
                    // Use the standard Command keycode 0x37 if keyCode["command"] not found
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x37), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x37), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                }
            case "option", "⌥", "opt":
                flags.insert(.maskAlternate)
                if let keyCodeMod = keyCode["option"] {
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                } else {
                    // Use the standard Option keycode 0x3A if keyCode["option"] not found
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x3A), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x3A), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                }
            case "shift", "⇧":
                flags.insert(.maskShift)
                if let keyCodeMod = keyCode["shift"] {
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                } else {
                    // Use the standard Shift keycode 0x38 if keyCode["shift"] not found
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x38), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                }
            case "control", "⌃", "ctrl":
                flags.insert(.maskControl)
                if let keyCodeMod = keyCode["control"] {
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                } else {
                    // Use the standard Control keycode 0x3B if keyCode["control"] not found
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x3B), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x3B), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                }
            case "function", "fn":
                flags.insert(.maskSecondaryFn)
                if let keyCodeMod = keyCode["function"] {
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                } else {
                    // Use the standard Function keycode 0x3F if keyCode["function"] not found
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x3F), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x3F), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                }
            case "capslock", "caps":
                flags.insert(.maskAlphaShift)
                if let keyCodeMod = keyCode["capslock"] {
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(keyCodeMod), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                } else {
                    // Use the standard CapsLock keycode 0x39 if keyCode["capslock"] not found
                    let eventDown = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x39), keyDown: true)
                    let eventUp = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(0x39), keyDown: false)
                    modifierEventsDown.append(eventDown!)
                    modifierEventsUp.insert(eventUp!, at: 0)
                }
            default:
                print("\(mod) key is not supported.")
            }
        }

        // Post modifier key down events
        for event in modifierEventsDown {
            event.post(tap: loc)
        }

        // Post main key down and up events with combined flags
        var mainKeyCode: CGKeyCode?
        if let code = keyCode[key_lower] {
            mainKeyCode = CGKeyCode(code)
        } else if let code = ShiftKeyCode[key_lower] {
            mainKeyCode = CGKeyCode(code)
        }

        if let mainKeyCode = mainKeyCode {
            let keyDown = CGEvent(keyboardEventSource: src, virtualKey: mainKeyCode, keyDown: true)
            keyDown?.flags = flags
            let keyUp = CGEvent(keyboardEventSource: src, virtualKey: mainKeyCode, keyDown: false)
            keyUp?.flags = flags

            keyDown?.post(tap: loc)
            keyUp?.post(tap: loc)
        } else {
            print("Key \(key) not found.")
        }

        // Post modifier key up events in reverse order
        for event in modifierEventsUp {
            event.post(tap: loc)
        }
    }

    // Determine if a key is pressed.
    // If it is pressed, return true, else return false.
    public static func isPressed(_ key: String) -> Bool {
        docheck(key)

        let key_lower = key.lowercased()
        let key_code = CGKeyCode(keyCode[key_lower]!)
        let isPressed: Bool = CGEventSource.keyState(.combinedSessionState, key: key_code)
        return isPressed
    }
}

private extension String {
    func containsWhitespace() -> Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }

    var isUppercase: Bool {
        return self == uppercased()
    }
}
