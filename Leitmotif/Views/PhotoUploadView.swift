import SwiftUI
import Foundation
import PhotosUI

struct PhotoUploadView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isImageOverlayed: Bool
    @State private var backgroundImageData: PhotosPickerContentTransferrable?
    @State private var isPhotoPickerVisible = false
    @State private var selectedItem: URL?
    @State private var fileExtension: String?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                PhotoPickerBottomForm(backgroundImageData: $backgroundImageData, isImageOverlayed: $isImageOverlayed)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(createBackground(geometry), alignment: .center)
        }
    }

    @ViewBuilder 
    func createBackground(_ geometry: GeometryProxy) -> some View {
        if let backgroundImage = backgroundImageData?.image {
            backgroundImage
                .resizable()
                .scaledToFill()
                .blur(radius: 5)
                .scaleEffect(1.05) // remove white glow from top and bottom of image
                .frame(minWidth: geometry.size.width, maxWidth: geometry.size.width)
                .ignoresSafeArea(.all)
        }
    }
}
                
#Preview {
    PhotoUploadView(isImageOverlayed: .constant(false))
}


