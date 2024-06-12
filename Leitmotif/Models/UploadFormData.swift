import Foundation
import _PhotosUI_SwiftUI

class UploadFormData: ObservableObject {
    @Published var fileName: String
    @Published var selectedLocation: UploadLocation
    
    init(fileName: String, selectedLocation: UploadLocation, selectedImage: PhotosPickerItem? = nil) {
        self.fileName = fileName
        self.selectedLocation = selectedLocation
    }
}
