import Foundation

class URLUploadFormData: UploadFormData {
    @Published var url: String
    
    init(filename: String, location: UploadLocation, url: String) {
        self.url = url
        
        super.init(filename: filename, location: location)
    }
}
