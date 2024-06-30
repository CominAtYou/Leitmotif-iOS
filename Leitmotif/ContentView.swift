import SwiftUI
import Alamofire

struct ContentView: View {
    @EnvironmentObject var topBarStateController: TopBarStateController
    @State private var pillState = TopBarPillState.standard
    
    var body: some View {
        ZStack {
            TabView(selection: $topBarStateController.selectedButton) {
                FileUploadView()
                    .tag(0)
                PhotoUploadView()
                    .tag(1)
                TwitterUploadView()
                    .tag(2)
                EmptyView()
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all)
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
        .environmentObject(ConfigurationStateController(networkMode: .automatic))
}
