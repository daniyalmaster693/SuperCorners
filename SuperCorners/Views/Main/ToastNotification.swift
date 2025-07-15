import AppKit
import SwiftUI

class ToastWindowController {
    @AppStorage("showToastNotifications") var showToastNotifications = true
    @AppStorage("autoDismissTimer") var autoDismissTimer: DismissTimer = .seconds3

    enum DismissTimer: String, CaseIterable, Identifiable {
        case seconds2 = "2 Seconds"
        case seconds3 = "3 Seconds"
        case seconds4 = "4 Seconds"
        case seconds5 = "5 Seconds"
        case seconds10 = "10 Seconds"

        var id: String { rawValue }

        var duration: TimeInterval {
            switch self {
            case .seconds2: return 2
            case .seconds3: return 3
            case .seconds4: return 4
            case .seconds5: return 5
            case .seconds10: return 10
            }
        }
    }

    private var panel: NSPanel?
    private var timer: Timer?

    func showToast(message: String, icon: Image? = nil, duration: TimeInterval? = nil) {
        guard showToastNotifications else { return }

        if panel == nil {
            let toastView = ToastView(message: message, icon: icon, panel: nil)

            let hostingView = NSHostingView(rootView: toastView)
            hostingView.frame = NSRect(x: 0, y: 0, width: 300, height: 50)

            panel = NSPanel(contentRect: hostingView.frame,
                            styleMask: [.nonactivatingPanel],
                            backing: .buffered,
                            defer: false)

            if let panel = panel {
                panel.contentView = hostingView
                panel.isFloatingPanel = true
                panel.level = .floating
                panel.backgroundColor = .clear
                panel.isOpaque = false
                panel.hasShadow = true
                panel.ignoresMouseEvents = false
                panel.hidesOnDeactivate = false
                panel.collectionBehavior = [.canJoinAllSpaces, .transient, .ignoresCycle]

                hostingView.rootView = ToastView(message: message, icon: icon, panel: panel)
            }
        }

        if let screenFrame = NSScreen.main?.visibleFrame, let panel = panel {
            let x = screenFrame.midX - panel.frame.width / 2
            let y = screenFrame.minY + 100
            panel.setFrameOrigin(NSPoint(x: x, y: y))
            panel.alphaValue = 0
            panel.orderFrontRegardless()

            let displayDuration = duration ?? autoDismissTimer.duration

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                panel.animator().alphaValue = 1
            }, completionHandler: {
                DispatchQueue.main.asyncAfter(deadline: .now() + displayDuration) {
                    NSAnimationContext.runAnimationGroup({ context in
                        context.duration = 0.3
                        context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                        panel.animator().alphaValue = 0
                    }, completionHandler: {
                        panel.orderOut(nil)
                    })
                }
            })
        }
    }
}

struct ToastView: View {
    let message: String
    let icon: Image?
    weak var panel: NSPanel?
    @AppStorage("dismissOnClick") var dismissOnClick = true

    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.primary)
            }
            Text(message)
                .multilineTextAlignment(.leading)
        }
        .onTapGesture {
            if dismissOnClick {
                guard let panel = panel else { return }
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.3
                    context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    panel.animator().alphaValue = 0
                }, completionHandler: {
                    panel.orderOut(nil)
                })
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary.opacity(0.25), lineWidth: 1.5)
        )
        .frame(maxWidth: 300)
    }
}
