//
//  WhatsNewView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-06-26.
//

import SwiftUI

struct NewFeaturesView: View {
    let featuresAndImprovements = [
        "Customizable modifier keys and activation key in settings.",
        "Improved corner sensitivity and responsiveness.",
        "New action types available for corners and zones.",
    ]

    let bugFixes = [
        "Resolved issue where corners would sometimes not trigger.",
        "Fixed visual glitch in settings toggle.",
        "Addressed memory leak in background monitor service.",
    ]

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 40) {
                HStack(alignment: .center, spacing: 40) {
                    Image(nsImage: NSApplication.shared.applicationIconImage)
                        .resizable()
                        .frame(width: 60, height: 60)

                    VStack(alignment: .leading, spacing: 16) {
                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("Version \(version) Release Notes")
                                .font(.title)
                                .bold()
                        }
                    }
                }
            }
            .padding(.trailing, 15)
            .padding(.bottom, 15)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("New Features & Improvements")
                        .font(.title2)
                        .bold()
                    ForEach(featuresAndImprovements, id: \.self) { item in
                        HStack(alignment: .top) {
                            Text("•").bold()
                            Text(item)
                                .multilineTextAlignment(.leading)
                        }
                    }

                    Text("Bug Fixes")
                        .font(.title2)
                        .bold()
                        .padding(.top)

                    ForEach(bugFixes, id: \.self) { item in
                        HStack(alignment: .top) {
                            Text("•").bold()
                            Text(item)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }.padding(.trailing, 15)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .frame(maxWidth: 650, minHeight: 200, idealHeight: 400, maxHeight: .infinity)
        .onAppear {
            if let window = NSApplication.shared.windows.first {
                window.title = ""
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.isMovableByWindowBackground = true
            }
        }
    }
}
