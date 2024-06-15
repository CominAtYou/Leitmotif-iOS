import SwiftUI

extension PhotoUploadFormBottomButtons {
    func startUpload(_ content: PhotosPickerContentTransferrable) async {
        do {
            try await uploadData(using: photoUploadFormData, file: content.imageData!, mime: content.mimeType!, topBarStateController: topBarStateController)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    topBarStateController.state = .inactive
                    topBarStateController.statusText = "Upload Complete!"
                }
            }
        }
        catch UploadError.fileExistsError {
            // TODO: Something
        }
        catch (UploadError.uploadFailure) {
            // TODO: Something
        }
        catch (UploadError.wanQueryFailure) {
            // TODO: something
        }
        catch {
            // TODO: something
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let name = UserDefaults.standard.string(forKey: "lastSeenServerName")!
            withAnimation {
                topBarStateController.statusText = "\(name) – Online"
                photoUploadFormData.filename = ""
                photoUploadFormData.selectedImage = nil
            }
        }
    }
    
    func handleSelectionChange() {
        if photoUploadFormData.selectedImage != nil {
            photoUploadFormData.selectedImage!.loadTransferable(type: PhotosPickerContentTransferrable.self) { result in
                if var resultData = try? result.get() {
                    let fileExt = photoUploadFormData.selectedImage!.supportedContentTypes.first!.preferredFilenameExtension!
                    
                    DispatchQueue.main.async {
                        if (photoUploadFormData.filename.isEmpty) {
                            let nameComponent = UUID().uuidString.split(separator: "-").first!.lowercased()
                            photoUploadFormData.filename = "\(nameComponent).\(fileExt)"
                        }
                        else if (photoUploadFormData.filename.contains(".")) {
                            let nameComponent = photoUploadFormData.filename.split(separator: ".").first!
                            photoUploadFormData.filename = "\(nameComponent).\(fileExt)"
                        }
                        else {
                            photoUploadFormData.filename += ".\(fileExt)"
                        }
                    }
                    
                    resultData.mimeType = photoUploadFormData.selectedImage!.supportedContentTypes.first!.preferredMIMEType
                    withAnimation {
                        backgroundImageData = resultData
                    }
                    isImageOverlayed = true
                }
            }
        }
        else {
            withAnimation {
                backgroundImageData = nil
                isImageOverlayed = false
            }
        }
    }
}
