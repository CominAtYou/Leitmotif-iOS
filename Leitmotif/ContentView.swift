//
//  ContentView.swift
//  Leitmotif
//
//  Created by William Martin on 9/9/23.
//

import SwiftUI

struct ContentView: View {
    @State var fileName = ""
    var body: some View {
        NavigationStack {
            TabView {
                PhotoUploadView()
                    .tabItem {
                        Label("Photo", systemImage: "photo")
                    }
                FileUploadView()
                    .tabItem {
                        Label("File", systemImage: "doc")
                    }
                TwitterUploadView()
                    .tabItem {
                        Label("Twitter", systemImage: "bird")
                    }
                Text("URL")
                    .tabItem {
                        Label("URL", systemImage: "link")
                    }
            }
            .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 0.4 : 0)
            .navigationTitle("Leitmotif")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
