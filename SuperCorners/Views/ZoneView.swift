//
//  ZoneView.swift
//  SuperCorners
//
//  Created by Daniyal Master on 2025-05-24.
//

import SwiftUI

struct ZoneView: View {
    @State private var showModal = false
    let topCenterTitle = cornerActionBindings[.topLeft]?.title
    let bottomCenterTitle = cornerActionBindings[.topRight]?.title
    let leftCenterTitle = cornerActionBindings[.bottomLeft]?.title
    let rightCenterTitle = cornerActionBindings[.bottomRight]?.title
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Configure Your Super Zones")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: 450, alignment: .leading)
                
                Text("Assign custom actions to your Mac’s screen edges. Click the button found at every edge to assign an action.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 450, alignment: .leading)
            }
            .padding(.top, 25)
            .frame(maxWidth: 450)
            
            Spacer()
            
            ZStack {
                Image("SequoiaWallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 450, height: 275)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(alignment: .top) {
                        Button(topCenterTitle ?? "Add Action") {
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .bottom) {
                        Button(bottomCenterTitle ?? "Add Action") {
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .leading) {
                        Button(leftCenterTitle ?? "Add Action") {
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .trailing) {
                        Button(rightCenterTitle ?? "Add Action") {
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 275)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
//            .sheet(isPresented: $showModal) {
//                ActionLibraryView()
//            }
        }.navigationTitle("Zones")
    }
}
