import SwiftUI
import Alamofire

struct ContentView: View {
    @EnvironmentObject var topBarStateController: TopBarStateController
    var body: some View {
        ZStack {
            if (topBarStateController.selectedButton == 1) {
                PhotoUploadView()
            }
            TopBar(isImageOverlayed: $topBarStateController.isImageOverlayed)
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
        .environmentObject(TopBarStateController(state: .inactive, statusText: "UbuntuNAS | Online", uploadProgress: 0.0, isImageOverlayed: false, selectedButton: 0))
        .environmentObject(PhotoUploadFormData(fileName: "", selectedLocation: .splatoon))
}
