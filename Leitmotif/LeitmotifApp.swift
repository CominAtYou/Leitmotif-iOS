import SwiftUI

@main
struct LeitmotifApp: App {
    @StateObject var topBarStateController = TopBarStateController(state: .indeterminate, statusText: "Connecting...", uploadProgress: 0.0, isImageOverlayed: false, selectedButton: 0)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(topBarStateController)
        }
    }
}
