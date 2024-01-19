import SwiftUI
import Foundation
import PhotosUI

struct PhotoUploadView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isImageOverlayed: Bool
    @State private var fileName = ""
    @State private var isPhotoPickerVisible = false
    @State private var selectedItem: URL?
    @State private var backgroundImage: Image?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                PhotoPickerBottomForm(backgroundImage: $backgroundImage, isImageOverlayed: $isImageOverlayed)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(createBackground(geometry), alignment: .center)
        }
    }

    @ViewBuilder func createBackground(_ geometry: GeometryProxy) -> some View {
        if let backgroundImage {
            backgroundImage
                .resizable()
                .scaledToFill()
                .scaleEffect(colorScheme == .dark ? 1.05 : 1, anchor: .center) // remove white glow from top and bottom of image
                .frame(minWidth: geometry.size.width, maxWidth: geometry.size.width)
                .ignoresSafeArea(.all)
        }
    }
}
                
#Preview {
    PhotoUploadView(isImageOverlayed: .constant(false))
}


