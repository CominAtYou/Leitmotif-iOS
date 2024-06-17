import SwiftUI

struct TopBarPillOptions: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Options")
                .font(Font.custom("UrbanistRoman-SemiBold", size: 12, relativeTo: .caption))
                .opacity(0.3)
            VStack(spacing: 10) {
                HStack {
                    Text("Network Mode")
                        .font(Font.custom("UrbanistRoman-Semibold", size: 16, relativeTo: .body))
                    Spacer()
                    Text("Automatic")
                        .font(Font.custom("UrbanistRoman-Medium", size: 16, relativeTo: .body))
                        .opacity(0.3)
                }
                HStack {
                    Text("Upload Locations")
                        .font(Font.custom("UrbanistRoman-Semibold", size: 16, relativeTo: .body))
                    Spacer()
                    Text("Tap to refresh")
                        .font(Font.custom("UrbanistRoman-Medium", size: 16, relativeTo: .body))
                        .opacity(0.3)
                }
            }
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    TopBarPillOptions()
}
