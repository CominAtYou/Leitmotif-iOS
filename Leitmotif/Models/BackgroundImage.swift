//
//  BackgroundImage.swift
//  Leitmotif
//
//  Created by William Martin on 1/13/24.
//

import Foundation
import SwiftUI
import CoreTransferable

struct BackgroundImage: Transferable {
    let image: Image
    let imageData: Data
    
    private enum TransferError: Error {
        case TransferFailed
    }
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                return BackgroundImage(image: image, imageData: data)
            }
            else {
                throw TransferError.TransferFailed
            }
        }
    }
}
