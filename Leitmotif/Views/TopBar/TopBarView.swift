import SwiftUI

let tabNames = ["File", "Photo", "Twitter", "URL"]
let lineSize: [CGFloat] = [36, 54, 59, 40]
let linePos: [CGFloat] = [-6.5, 48, 123, 205]


struct TopBarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @State private var isPillExpanding = false
    @Binding var isImageOverlayed: Bool
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                VStack(spacing: 12) {
                    TopBarFakePill()
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
                
                TopBarPill()
                .onLongPressGesture(minimumDuration: 0.6) {
                    NSLog("Reached")
                } onPressingChanged: { state in
                    withAnimation(.linear(duration: 0.25)) {
                        isPillExpanding = state
                    }
                }
                .scaleEffect(isPillExpanding ? 1.075 : 1)

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
    TopBarView(isImageOverlayed: .constant(false))
        .environmentObject(TopBarStateController.previewObject(position: 0))
}
