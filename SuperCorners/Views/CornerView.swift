import SwiftUI

struct CornerView: View {
    @State private var showModal = false
    let topLeftTitle = cornerActionBindings[.topLeft]?.title
    let topRightTitle = cornerActionBindings[.topRight]?.title
    let bottomLeftTitle = cornerActionBindings[.bottomLeft]?.title
    let bottomRightTitle = cornerActionBindings[.bottomRight]?.title
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Configure Your Super Corners")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: 450, alignment: .leading)
                
                Text("Assign custom actions to your Mac’s screen corners. Click a corner’s “Add Action” button to choose an action to assign.")
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
                    .overlay(alignment: .topLeading) {
                        Button(topLeftTitle ?? "Add Action") {
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .topTrailing) {
                        Button(topRightTitle ?? "Add Action") {
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .bottomLeading) {
                        Button(bottomLeftTitle ?? "Add Action") {
                            showModal = true
                        }
                        .buttonStyle(.bordered)
                        .padding(8)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button(bottomRightTitle ?? "Add Action") {
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
            .sheet(isPresented: $showModal) {
                ActionLibraryView()
            }
        }
    }
}
