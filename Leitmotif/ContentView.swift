import SwiftUI
import Alamofire

struct ContentView: View {
    @EnvironmentObject var topBarStateController: TopBarStateController
    @State private var pillState = TopBarPillState.standard
    
    var body: some View {
        ZStack {
            VStack {
                if (topBarStateController.selectedButton == 0) {
                    FileUploadView()
                }
                else if (topBarStateController.selectedButton == 1) {
                    PhotoUploadView()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.bouncy(duration: 0.5)) {
                    pillState = .standard
                }
            }
            
            TopBarView(pillState: $pillState, isImageOverlayed: $topBarStateController.isImageOverlayed)
        }
        .onAppear {
            let reachabilityManager = NetworkReachabilityManager(host: WAN_IP)
            
            reachabilityManager?.startListening() { state in
                Task {
                    await queryNetwork(newState: state)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TopBarStateController.previewObject(position: 0))
        .environmentObject(PhotoUploadFormData(filename: "", location: .splatoon))
}
