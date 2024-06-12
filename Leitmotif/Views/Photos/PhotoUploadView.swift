import SwiftUI
import Foundation
import PhotosUI

struct PhotoUploadView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var photoUploadFormData = PhotoUploadFormData(fileName: "", selectedLocation: .splatoon)
    
    @State private var backgroundImageData: PhotosPickerContentTransferrable?
    @State private var isPhotoPickerVisible = false
    @State private var selectedItem: URL?
    @State private var fileExtension: String?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                PhotoUploadViewBottomForm(backgroundImageData: $backgroundImageData)
                    .environmentObject(photoUploadFormData)
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
    PhotoUploadView()
        .environmentObject(UploadFormData(fileName: "", selectedLocation: .splatoon))
        .environmentObject(TopBarStateController(state: .inactive, statusText: "", uploadProgress: 0, isImageOverlayed: false, selectedButton: 1))
}

class PhotoUploadFormData: UploadFormData {
    @Published var selectedImage: PhotosPickerItem?
    
    override init(fileName: String, selectedLocation: UploadLocation, selectedImage: PhotosPickerItem? = nil) {
        self.selectedImage = selectedImage
        super.init(fileName: fileName, selectedLocation: selectedLocation, selectedImage: nil)
    }
}
