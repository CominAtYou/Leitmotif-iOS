import SwiftUI

extension PhotoUploadFormBottomButtons {
    func startUpload(_ content: PhotosPickerContentTransferrable) async {
        do {
            try await uploadData(using: photoUploadFormData, file: content.imageData ?? content.videoData!, mime: content.mimeType!, topBarStateController: topBarStateController)
            
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
    
    private func setFileName() {
        guard let fileExt = photoUploadFormData.selectedImage?.supportedContentTypes.first?.preferredFilenameExtension else { return }
        
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
    
    func handleSelectionChange() {
        guard let selectedImage = photoUploadFormData.selectedImage else {
            withAnimation {
                backgroundImageData = nil
            }
            
            return
        }
        
        selectedImage.loadTransferable(type: PhotosPickerContentTransferrable.self) { result in
            guard var resultData = try? result.get() else {
                withAnimation {
                    backgroundImageData = nil
                }
                
                isImageOverlayed = false
                return
            }
            
            resultData.mimeType = selectedImage.supportedContentTypes.first!.preferredMIMEType
            
            if let videoData = resultData.videoData {
                Task {
                    if let videoFrame = await getFrameFromVideo(data: videoData) {
                        resultData.backgroundImage = Image(uiImage: UIImage(cgImage: videoFrame))
                        
                        DispatchQueue.main.async {
                            withAnimation {
                                backgroundImageData = resultData
                            }
                            
                            setFileName()
                            isImageOverlayed = true
                            topBarStateController.isImageOverlayed = true
                        }
                    }
                }
            }
            else {
                withAnimation {
                    backgroundImageData = resultData
                }
                
                setFileName()
                isImageOverlayed = true
                topBarStateController.isImageOverlayed = true
            }
        }
    }
}
