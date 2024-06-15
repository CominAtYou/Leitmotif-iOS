import SwiftUI
import Alamofire

struct ContentView: View {
    @EnvironmentObject var topBarStateController: TopBarStateController
    var body: some View {
        ZStack {
            if (topBarStateController.selectedButton == 0) {
                FileUploadView()
            }
            else if (topBarStateController.selectedButton == 1) {
                PhotoUploadView()
            }
            TopBarView(isImageOverlayed: $topBarStateController.isImageOverlayed)
        }
        .onAppear {
            let reachabilityManager = NetworkReachabilityManager(host: "skipper.cominatyou.com")
            
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
