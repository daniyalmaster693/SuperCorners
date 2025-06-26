import AppKit
import SwiftUI

class ToastWindowController {
    @AppStorage("showToastNotifications") var showToastNotifications = true

    private var panel: NSPanel?
    private var timer: Timer?

    func showToast(message: String, icon: Image? = nil, duration: TimeInterval = 3.0) {
        guard showToastNotifications else { return }
        if panel == nil {
            let toastView = ToastView(message: message, icon: icon)
            let hostingView = NSHostingView(rootView: toastView)
            hostingView.frame = NSRect(x: 0, y: 0, width: 300, height: 50)

            panel = NSPanel(contentRect: hostingView.frame,
                            styleMask: [.borderless],
                            backing: .buffered,
                            defer: false)
            panel?.contentView = hostingView
            panel?.isFloatingPanel = true
            panel?.level = .floating
            panel?.backgroundColor = .clear
            panel?.isOpaque = false
            panel?.hasShadow = true
            panel?.ignoresMouseEvents = true
        } else {
            if let hostingView = panel?.contentView as? NSHostingView<ToastView> {
                hostingView.rootView = ToastView(message: message, icon: icon)
            }
        }

        if let screenFrame = NSScreen.main?.visibleFrame, let panel = panel {
            let x = screenFrame.midX - panel.frame.width / 2
            let y = screenFrame.minY + 100
            panel.setFrameOrigin(NSPoint(x: x, y: y))
            panel.alphaValue = 0
            panel.orderFrontRegardless()

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                panel.animator().alphaValue = 1
            }, completionHandler: {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
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

        timer?.invalidate()
    }
}

struct ToastView: View {
    let message: String
    let icon: Image?

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
