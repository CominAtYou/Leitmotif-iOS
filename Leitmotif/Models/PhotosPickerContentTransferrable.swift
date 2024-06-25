import Foundation
import SwiftUI
import CoreTransferable

struct PhotosPickerContentTransferrable: Transferable {
    var backgroundImage: Image?
    let imageData: Data?
    let videoData: Data?
    var mimeType: String?
    
    private enum TransferError: Error {
        case TransferFailed
    }
    
    init(background backgroundImage: Image? = nil, imageData: Data? = nil, videoData: Data? = nil, mimeType: String? = nil) {
        self.backgroundImage = backgroundImage
        self.imageData = imageData
        self.videoData = videoData
        self.mimeType = mimeType
    }
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                return PhotosPickerContentTransferrable(background: image, imageData: data)
            }
            else {
                throw TransferError.TransferFailed
            }
        }
        
        DataRepresentation(importedContentType: .movie) { data in
            return PhotosPickerContentTransferrable(videoData: data)
        }
    }
}
