import SwiftUI

let tabNames = ["File", "Photo", "Twitter", "URL"]

struct TopBar: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @Binding var isImageOverlayed: Bool
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    if (topBarStateController.state == .inactive) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 20, weight: .medium))
                    }
                    else if (topBarStateController.state == .indeterminate) {
                        ProgressView()
                    }
                    else if (topBarStateController.state == .unavailable) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 20, weight: .medium))
                    }
                    else {
                        CircularProgressView(progress: $topBarStateController.uploadProgress)
                    }
                    VStack(alignment: .leading) {
                        Text("Leitmotif")
                            .font(Font.custom("UrbanistRoman-SemiBold", size: 19, relativeTo: .title))
                        Text(topBarStateController.statusText)
                            .font(Font.custom("UrbanistRoman-Medium", size: 13, relativeTo: .caption))
                            .opacity(0.3)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
                .clipShape(Capsule())
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .inset(by: 0.3)
                        .stroke(colorScheme == .dark ? .clear : Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 0.6)
                )
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 5)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 32) {
                        ForEach(0..<tabNames.count, id: \.self) { i in
                            Button(action: {
                                topBarStateController.selectedButton = i
                            }) {
                                Text(tabNames[i])
                                    .foregroundStyle(Color(UIColor.label))
                            }
                                .font(Font.custom("UrbanistRoman-SemiBold", size: 16, relativeTo: .body))
                        }
                    }
                    
                    Rectangle()
                        .frame(width: lineSize[topBarStateController.selectedButton], height: 2)
                        .offset(x: linePos[topBarStateController.selectedButton]) // Twitter: 130,
                        .padding(.top, 2)
                        .animation(.easeInOut(duration: 0.3), value: topBarStateController.selectedButton)

                }
                .padding(.horizontal, 36)
                .padding(.top, 14)
                .background(isImageOverlayed ? Color(colorScheme == .dark ? UIColor.secondarySystemBackground : .white) : .clear)
                .clipShape(Capsule())
                .shadow(color: isImageOverlayed ? .black.opacity(0.1) : .clear, radius: 6, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            Divider()
                .opacity(isImageOverlayed ? 0 : 1)
            Spacer()
        }
    }
}

#Preview {
    TopBar(isImageOverlayed: .constant(false))
        .environmentObject(TopBarStateController(state: .unavailable, statusText: "UbuntuNAS | Online", uploadProgress: 0.0, isImageOverlayed: false, selectedButton: 0))
}

let lineSize: [CGFloat] = [36, 54, 59, 40]
let linePos: [CGFloat] = [-7, 47, 123, 205]
