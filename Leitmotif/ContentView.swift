//
//  ContentView.swift
//  Leitmotif
//
//  Created by William Martin on 9/9/23.
//

import SwiftUI

struct ContentView: View {
    @State var isImageOverlayed = false
    var body: some View {
        ZStack {
            PhotoUploadView(isImageOverlayed: $isImageOverlayed)
            TopBar(isImageOverlayed: $isImageOverlayed)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
