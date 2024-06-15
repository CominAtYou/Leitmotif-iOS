import Foundation
import Alamofire

extension ContentView {
    func queryNetwork(newState: NetworkReachabilityManager.NetworkReachabilityStatus) async {
        let lastSeenName = UserDefaults.standard.string(forKey: "lastSeenServerName")
        
        if (newState == .notReachable) {
            DispatchQueue.main.async {
                topBarStateController.state = .unavailable
                topBarStateController.statusText = lastSeenName != nil ? "\(lastSeenName!) | Offline" : "Offline"
            }
            
            return
        }
        
        let pingRequest = AF.request("https://\(ENDPOINT_DOMAIN)/leitmotif/ping")
        let response = await pingRequest.serializingString().response
        
        if response.error != nil {
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    topBarStateController.state = .unavailable
                    topBarStateController.statusText = lastSeenName != nil ? "\(lastSeenName!) | Offline" : "Offline"
                }
            }
            
            return
        }
        
        let content = try? response.result.get()
        
        guard let content else {
            DispatchQueue.main.async {
                topBarStateController.state = .unavailable
                topBarStateController.statusText = lastSeenName != nil ? "\(lastSeenName!) | Offline" : "Offline"
            }
            return
        }
        
        let pong = try? JSONDecoder().decode(PingResponse.self, from: content.data(using: .utf8)!)
        
        guard let pong else {
            DispatchQueue.main.async {
                topBarStateController.state = .unavailable
                topBarStateController.statusText = lastSeenName != nil ? "\(lastSeenName!) | Offline" : "Offline"
            }
            return
        }
        
        DispatchQueue.main.async {
            topBarStateController.state = .inactive
            topBarStateController.statusText = "\(pong.name) – Online"
        }
        
        UserDefaults.standard.setValue(pong.name, forKey: "lastSeenServerName")
    }
}
