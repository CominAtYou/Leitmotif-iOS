import Foundation
import SwiftUI

extension FileUploadViewBottomButtons {
    func loadFile(_ result: Result<URL, any Error>) async {
        switch result {
        case .success(let file):
            DispatchQueue.main.async {
                withAnimation {
                    fileUploadFormData.selectedFile = file
                }
                
                let fileExt = file.pathExtension.lowercased()
                
                if (fileUploadFormData.filename.isEmpty) {
                    var fileNameSplit = file.lastPathComponent.components(separatedBy: ".")
                    fileNameSplit[fileNameSplit.count - 1] = fileNameSplit.last!.lowercased()
                    fileUploadFormData.filename = fileNameSplit.joined(separator: ".")
                }
                else if (fileUploadFormData.filename.contains(".")) {
                    let nameComponent = fileUploadFormData.filename.split(separator: ".").first!
                    fileUploadFormData.filename = "\(nameComponent).\(fileExt)"
                }
                else {
                    fileUploadFormData.filename += ".\(fileExt)"
                }
            }
            
            guard let type = try? mimeType(url: file) else {
                NSLog("Couldn't get a MIME type, aborting background task.")
                return
            }
            
            
            guard type.starts(with: /(video|image)\//) else { return }
            
            guard file.startAccessingSecurityScopedResource() else {
                NSLog("Can't access the file, aborting.")
                return
            }
            
            if type.starts(with: "image/") {
                guard let fileData = try? Data(contentsOf: file) else {
                    NSLog("Couldn't read the file, aborting.")
                    return
                }
                
                DispatchQueue.main.async {
                    withAnimation {
                        fileUploadFormData.backgroundImage = Image(uiImage: UIImage(data: fileData)!)
                    }
                    
                    fileUploadFormData.fileData = fileData
                    topBarStateController.isImageOverlayed = true
                    
                    file.stopAccessingSecurityScopedResource()
                }
            }
            
            if type.starts(with: "video/") {
                guard let frame = await getFrameFromVideo(videoURL: file) else { return }
                
                withAnimation {
                    fileUploadFormData.backgroundImage = Image(uiImage: UIImage(cgImage: frame))
                }
                
                topBarStateController.isImageOverlayed = true
            }
            
        case .failure(let error):
            print(error)
        }
    }
}
