import Foundation
import SwiftUI
import PhotosUI

class PhotoUploadFormData: UploadFormData {
    @Published var selectedImage: PhotosPickerItem? = nil
}

