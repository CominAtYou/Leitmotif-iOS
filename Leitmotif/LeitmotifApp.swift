//
//  LeitmotifApp.swift
//  Leitmotif
//
//  Created by William Martin on 9/9/23.
//

import SwiftUI

@main
struct LeitmotifApp: App {
    @StateObject var topBarStateController = TopBarStateController(state: .indeterminate, statusText: "Connecting...", uploadProgress: 0.0)
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(topBarStateController)
        }
    }
}
