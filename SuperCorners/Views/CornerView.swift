import SwiftUI

struct CornerView: View {
    @State private var showModal = false
    
    var body: some View {
        VStack {
            // Top text section pinned at the top with padding
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
            .padding(.top, 20)
            .frame(maxWidth: 450)
            
            Spacer()
            
            // Center wallpaper and buttons
            ZStack {
                Image("SequoiaWallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 450, height: 275)
                    .clipped()
                    .cornerRadius(12)

                Button("Add Action") {
                    showModal = true
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
                .offset(x: -275, y: -130)

                Button("Add Action") {
                    showModal = true
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
                .offset(x: 275, y: -130)

                Button("Add Action") {
                    showModal = true
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
                .offset(x: -275, y: 125)

                Button("Add Action") {
                    showModal = true
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
                .offset(x: 275, y: 125)
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
