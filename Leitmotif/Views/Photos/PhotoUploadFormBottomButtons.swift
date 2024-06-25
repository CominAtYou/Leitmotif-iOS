import SwiftUI
import PhotosUI

struct PhotoUploadFormBottomButtons: View {
    @EnvironmentObject var topBarStateController: TopBarStateController
    @EnvironmentObject var photoUploadFormData: PhotoUploadFormData
    @Binding var backgroundImageData: PhotosPickerContentTransferrable?
    @Binding var isImageOverlayed: Bool
    @Binding var shouldPaddingBeApplied: Bool
    
    var body: some View {
        VStack {
            HStack {
                PhotosPicker(selection: $photoUploadFormData.selectedImage, matching: .any(of: [.images, .videos]), photoLibrary: .shared()) {
                    ActionlessLargeButton(text: backgroundImageData != nil ? "Change Photo" : "Select Photo")
                }
                .onChange(of: photoUploadFormData.selectedImage, handleSelectionChange)
                if let backgroundImageData {
                    LargeButton(labelText: "Upload") {
                        Task { await startUpload(backgroundImageData) }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, shouldPaddingBeApplied ? 12 : 0)
    }
}

#Preview {
    PhotoUploadFormBottomButtons(backgroundImageData: .constant(nil), isImageOverlayed: .constant(false), shouldPaddingBeApplied: .constant(false))
        .environmentObject(PhotoUploadFormData(filename: "", location: .splatoon))
}
