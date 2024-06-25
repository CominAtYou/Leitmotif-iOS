import Foundation
import SwiftUI

class FileUploadFormData: UploadFormData {
    @Published var selectedFile: URL? = nil
    // This will only be non-nil if the file is an image – the background image data will be stored here so we don't have to read the file twice
    @Published var fileData: Data? = nil
    @Published var backgroundImage: Image? = nil
}
