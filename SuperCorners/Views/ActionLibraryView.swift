//
//  ActionLibraryView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct ActionLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedActionID: String?

    let corner: CornerPosition.Corner
    var onUpdate: () -> Void

    var filteredActions: [CornerAction] {
        if searchText.isEmpty {
            return cornerActions
        } else {
            let lowercasedSearch = searchText.lowercased()
            return cornerActions.filter { action in
                let titleContains = action.title.lowercased().contains(lowercasedSearch)
                let descriptionContains = action.description.lowercased().contains(lowercasedSearch)
                return titleContains || descriptionContains
            }
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Action Library")
                .font(.title)
                .bold()
                .padding(.top, 15)

            Text("Click an action to assign it")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom, 25)

            TextField("Search Actions", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 375)
                .padding(.bottom, 15)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(filteredActions) { action in
                        Button(action: {
                            selectedActionID = action.id
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: action.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.accentColor)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(action.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)

                                    Text(action.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedActionID == action.id ? Color.white.opacity(0.1) : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .frame(maxWidth: 375, maxHeight: 220)

            Button("Done") {
                if let selectedID = selectedActionID,
                   let selectedAction = cornerActions.first(where: { $0.id == selectedID })
                {
                    cornerActionBindings[corner] = selectedAction

                    onUpdate()
                }
                dismiss()
            }
            .padding(.top, 15)
        }
        .frame(minWidth: 200, minHeight: 425)
        .padding()
    }
}
