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
    @Published var isImageOverlayed: Bool
    @Published var selectedButton = 0
    
    init(state: TopBarState, statusText: String, uploadProgress: Double, isImageOverlayed: Bool, selectedButton: Int) {
        self.state = state
        self.statusText = statusText
        self.uploadProgress = uploadProgress
        self.isImageOverlayed = isImageOverlayed
        self.selectedButton = 0
    }
}

extension TopBarStateController {
    static func previewObject(position: Int) -> TopBarStateController {
        return TopBarStateController(state: .inactive, statusText: "UbuntuNAS – Online", uploadProgress: 0.0, isImageOverlayed: false, selectedButton: position)
    }
}
