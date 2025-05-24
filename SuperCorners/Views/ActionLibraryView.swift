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
    @State private var selectedActionID: UUID?

    var filteredActions: [CornerAction] {
        if searchText.isEmpty {
            return cornerActions
        } else {
            return cornerActions.filter { action in
                action.title.localizedCaseInsensitiveContains(searchText) ||
                action.description.localizedCaseInsensitiveContains(searchText)
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
                            print("Selected action: \(action.title)")
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
                dismiss()
            }         .padding(.top, 15)
        }
        .frame(minWidth: 200, minHeight: 425)
        .padding()
    }
}

struct ActionLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ActionLibraryView()
    }
}
