import Foundation
import SwiftUI

extension FileUploadViewBottomButtons {
    func uploadFile() async throws {
        guard let mime = try? mimeType(url: fileUploadFormData.selectedFile!) else {
            throw UploadError.fileAccessError
        }
        
        if let fileData = fileUploadFormData.fileData {
            do {
                try await uploadData(using: fileUploadFormData, file: fileData, mime: mime, topBarStateController: topBarStateController)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        topBarStateController.state = .inactive
                        topBarStateController.statusText = "Upload Complete!"
                    }
                }
            }
            catch {
                // TODO: impl
            }
        }
        else {
            do {
                let fileData = try Data(contentsOf: fileUploadFormData.selectedFile!)
                try await uploadData(using: fileUploadFormData, file: fileData, mime: mime, topBarStateController: topBarStateController)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        topBarStateController.state = .inactive
                        topBarStateController.statusText = "Upload Complete!"
                    }
                }
            }
            catch {
                // TODO: impl
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let name = UserDefaults.standard.string(forKey: "lastSeenServerName")!
            withAnimation {
                topBarStateController.statusText = "\(name) – Online"
                fileUploadFormData.filename = ""
                fileUploadFormData.selectedFile = nil
                fileUploadFormData.backgroundImage = nil
                topBarStateController.isImageOverlayed = false
            }
        }
    }
}
