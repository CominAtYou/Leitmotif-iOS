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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
