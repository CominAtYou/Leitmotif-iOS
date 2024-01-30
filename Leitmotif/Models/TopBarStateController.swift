import Foundation

enum TopBarState {
    case inactive
    case unavailable
    case indeterminate
    case uploading
}

class TopBarStateController: ObservableObject {
    @Published var state: TopBarState
    @Published var statusText: String
    @Published var uploadProgress: Double
    
    init(state: TopBarState, statusText: String, uploadProgress: Double) {
        self.state = state
        self.statusText = statusText
        self.uploadProgress = uploadProgress
    }
}
