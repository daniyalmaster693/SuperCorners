//
//  SettingsView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct SettingsView: View {
    enum Tab: String, CaseIterable, Identifiable {
        case general = "General"
        case activation = "Activation"
        case behavior = "Behavior"
        case actions = "Actions"

        var id: String { rawValue }
    }

    @State private var selectedTab: Tab? = .general

    var body: some View {
        NavigationSplitView {
            VStack(alignment: .leading, spacing: 8) {
                List(Tab.allCases, selection: $selectedTab) { tab in
                    Label(tab.rawValue, systemImage: tab.iconName)
                        .tag(tab)
                }
                .listStyle(.sidebar)
            }
            .padding(.top, 7)
            .frame(minWidth: 100)
        } detail: {
            Group {
                switch selectedTab {
                case .general:
                    GeneralSettingsView()
                        .navigationTitle("General")
                case .activation:
                    ActivationSettingsView()
                        .navigationTitle("Activation")
                case .behavior:
                    BehaviorSettingsView()
                        .navigationTitle("Behavior")
                case .actions:
                    ActionSettingsView()
                        .navigationTitle("Actions")
                default:
                    Text("Select a tab")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .toolbar(.hidden)
        }
        .frame(minWidth: 700, idealWidth: 700, maxWidth: 700)
    }
}

private extension SettingsView.Tab {
    var iconName: String {
        switch self {
        case .general: return "gearshape"
        case .activation: return "bolt.circle"
        case .behavior: return "hand.tap"
        case .actions: return "hammer"
        }
    }
}
