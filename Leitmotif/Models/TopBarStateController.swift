import Foundation

enum TopBarState {
    case inactive
    case unavailable
    case indeterminate
    case uploading
}

class TopBarStateController: ObservableObject {
    @Published var state = TopBarState.inactive
    @Published var statusText: String
    @Published var uploadProgress = 0.0
    @Published var isImageOverlayed = false
    @Published var selectedButton = 0
    @Published var pillState = TopBarPillState.standard
    
    @Published var dialogTitle = ""
    @Published var dialogMessage = ""
    
    init(state: TopBarState, statusText: String, selectedButton: Int) {
        self.state = state
        self.statusText = statusText
        self.selectedButton = selectedButton
    }
}

extension TopBarStateController {
    static func previewObject(position: Int) -> TopBarStateController {
        return TopBarStateController(state: .inactive, statusText: "UbuntuNAS – Online", selectedButton: position)
    }
}
