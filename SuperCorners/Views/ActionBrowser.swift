//
//  ActionBrowser.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-22.
//

import SwiftUI

struct ActionItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
}

struct ActionCard: View {
    
    let action: CornerAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: action.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
                    .padding(.top, 16)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.purple)
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }

            Text(action.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 8)
            
            Text(action.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(2)

            Spacer()
        }
        .padding()
        .frame(width: 220, height: 130)
        .background(Color.blue.opacity(0.75))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}


struct ActionBrowserView: View {
    @State private var searchText = ""
    
    func filteredItems(_ items: [CornerAction]) -> [CornerAction] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { action in
                action.title.localizedCaseInsensitiveContains(searchText) ||
                action.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("Action Browser")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Text("Browse a list of actions you can assign to corners or zones.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 240))], spacing: 16) {
                    ForEach(filteredItems(cornerActions)) { action in
                        ActionCard(action: action)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Actions")
            .searchable(text: $searchText)
        }
    }
}
