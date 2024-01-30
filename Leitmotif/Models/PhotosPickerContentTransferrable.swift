//
//  BackgroundImage.swift
//  Leitmotif
//
//  Created by William Martin on 1/13/24.
//

import Foundation
import SwiftUI
import CoreTransferable

struct PhotosPickerContentTransferrable: Transferable {
    let image: Image?
    let imageData: Data?
    let videoData: Data?
    var mimeType: String?
    
    private enum TransferError: Error {
        case TransferFailed
    }
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                return PhotosPickerContentTransferrable(image: image, imageData: data, videoData: nil, mimeType: nil)
            }
            else {
                throw TransferError.TransferFailed
            }
        }
    }
}
