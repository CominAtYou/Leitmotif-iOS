import SwiftUI

extension PhotoUploadFormBottomButtons {
    func startUpload(_ backgroundImageData: PhotosPickerContentTransferrable) async {
        do {
            try await uploadData(fileName: photoUploadFormData.fileName, file: backgroundImageData.imageData!, location: photoUploadFormData.selectedLocation, mime: backgroundImageData.mimeType!, topBarStateController: topBarStateController)
            
            topBarStateController.state = .inactive
            DispatchQueue.main.async {
                withAnimation {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let name = UserDefaults.standard.string(forKey: "lastSeenServerName")!
            withAnimation {
                topBarStateController.statusText = "\(name) | Online"
                photoUploadFormData.fileName = ""
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
                        if (photoUploadFormData.fileName.isEmpty) {
                            let nameComponent = UUID().uuidString.split(separator: "-").first!.lowercased()
                            photoUploadFormData.fileName = "\(nameComponent).\(fileExt)"
                        }
                        else if (photoUploadFormData.fileName.contains(".")) {
                            let nameComponent = photoUploadFormData.fileName.split(separator: ".").first!
                            photoUploadFormData.fileName = "\(nameComponent).\(fileExt)"
                        }
                        else {
                            photoUploadFormData.fileName += ".\(fileExt)"
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
