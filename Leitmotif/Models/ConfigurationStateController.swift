import Foundation

class ConfigurationStateController: ObservableObject {
    @Published var networkMode: NetworkMode
    
    init(networkMode: NetworkMode) {
        self.networkMode = networkMode
    }
}
