import SwiftUI

let tabNames = ["File", "Photo", "Twitter", "URL"]
let lineSize: [CGFloat] = [36, 54, 59, 40]
let linePos: [CGFloat] = [-6.5, 48, 123, 205]

struct TopBarView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var topBarStateController: TopBarStateController
    @Binding var pillState: TopBarPillState
    @State private var longPressCompleted = false
    @Binding var isImageOverlayed: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        TopBarFakePill()
                        TopBarNavigationTabs(isImageOverlayed: $isImageOverlayed)
                    }
                    .padding(.horizontal, pillState == .expanded ? 12 : 24)
                    
                    Divider()
                        .opacity(isImageOverlayed ? 0 : 1)
                }
                
                VStack {
                    TopBarPill(pillState: $pillState)
                        .onLongPressGesture(minimumDuration: 0.25) {
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            longPressCompleted = true
                            
                            withAnimation(.bouncy(duration: 0.5)) {
                                pillState = .expanded
                                longPressCompleted = false
                            }
                    } onPressingChanged: { state in
                        withAnimation(.bouncy(duration: 0.5)) {
                            if !longPressCompleted && pillState != .expanded {
                                pillState = state ? .expanding : .standard
                            }
                        }
                    }
                    .scaleEffect(pillState == .expanding ? 1.075 : 1)
                }
                .padding(.horizontal, pillState == .expanded ? 12 : 24)
            }
            .padding(.top, 10)
            Rectangle()
                .foregroundColor(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.bouncy(duration: 0.5)) {
                        pillState = .standard
                    }
                }
        }
    }
}

enum TopBarPillState {
    case standard
    case expanding
    case expanded
}

struct TopBarView_Previews: PreviewProvider {
    struct TopBarViewPreviewContainer: View {
        @State private var pillState = TopBarPillState.standard
        
        var body: some View {
            TopBarView(pillState: $pillState, isImageOverlayed: .constant(false))
                .environmentObject(TopBarStateController.previewObject(position: 0))
        }
    }
    
    static var previews: some View {
        TopBarViewPreviewContainer()
    }
}
