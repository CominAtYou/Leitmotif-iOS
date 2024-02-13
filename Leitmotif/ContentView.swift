//
//  ContentView.swift
//  Leitmotif
//
//  Created by William Martin on 9/9/23.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @EnvironmentObject var topBarStateController: TopBarStateController
    @State var isImageOverlayed = false
    var body: some View {
        ZStack {
            PhotoUploadView(isImageOverlayed: $isImageOverlayed)
            TopBar(isImageOverlayed: $isImageOverlayed)
        }
        .onAppear {
            let reachabilityManager = NetworkReachabilityManager(host: "https://cominatyou.com")
            
            reachabilityManager?.startListening() { state in
                Task {
                    await queryNetwork(topBarStateController: topBarStateController, newState: state)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TopBarStateController(state: .inactive, statusText: "UbuntuNAS | Online", uploadProgress: 0.0))
}
