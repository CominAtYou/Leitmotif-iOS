import Foundation
import _PhotosUI_SwiftUI

class UploadFormData: ObservableObject {
    @Published var filename: String
    @Published var location: UploadLocation
    
    init(filename: String, location: UploadLocation) {
        self.filename = filename
        self.location = location
    }
}
