import SwiftUI
import PhotosUI

struct PhotoUploadViewBottomForm: View {
    @EnvironmentObject var topBarStateController: TopBarStateController
    @Binding var backgroundImageData: PhotosPickerContentTransferrable?
    @EnvironmentObject var photoUploadFormData: PhotoUploadFormData
    @State private var shouldPaddingBeApplied = false
    
    var body: some View {
        VStack(spacing: 12) {
            UploadForm(shouldPaddingBeApplied: $shouldPaddingBeApplied)
                .environmentObject(photoUploadFormData as UploadFormData)
            
            PhotoUploadFormBottomButtons(backgroundImageData: $backgroundImageData, isImageOverlayed: $topBarStateController.isImageOverlayed, shouldPaddingBeApplied: $shouldPaddingBeApplied)
        }
    }
    
}

#Preview {
    PhotoUploadViewBottomForm(backgroundImageData: .constant(nil))
        .environmentObject(PhotoUploadFormData(filename: "", location: .splatoon))
        .environmentObject(TopBarStateController.previewObject(position: 1))
}
