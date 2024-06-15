import Foundation
import Alamofire
import SwiftUI

func uploadData(using formData: UploadFormData, file: Data, mime: String, topBarStateController: TopBarStateController) async throws {
    DispatchQueue.main.async {
        topBarStateController.state = .indeterminate
        topBarStateController.statusText = "Determining WAN IP..."
    }
    
    let getIpUrl = URL(string: "https://api.ipify.org")!
    let ipRequestResult = try? await URLSession.shared.data(from: getIpUrl)
    
    guard let (data, _) = ipRequestResult else { throw UploadError.wanQueryFailure }
    let ip = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
    let isAvailableLocally = ip == WAN_IP
    
    NSLog("Got IP: \(ip)")
    NSLog("Is available locally: \(isAvailableLocally ? "YES" : "NO")")
    
    DispatchQueue.main.async {
        topBarStateController.state = .uploading
        topBarStateController.statusText = "Uploading..."
        topBarStateController.uploadProgress = 0.0
    }
    
    let logData = ["filename": formData.filename, "location": (taggedLocations.first(where: { $0.tag == formData.location })!).name]
    
    NSLog("Kicking off upload to \(isAvailableLocally ? "http://192.168.2.6:8020" : "https://\(ENDPOINT_DOMAIN)")/leitmotif/upload with a payload size of \(file.count / 1024) KB")
    NSLog("Details: \(String(data: try JSONSerialization.data(withJSONObject: logData), encoding: .utf8)!)")
    let request = AF.upload(multipartFormData: { data in
        data.append(file, withName: "file", fileName: formData.filename, mimeType: mime)
        data.append(formData.filename.data(using: .utf8)!, withName: "filename")
        data.append(locationIds[formData.location]!.data(using: .utf8)!, withName: "location")
    }, to: "\(isAvailableLocally ? "http://192.168.2.6:8020" : "https://\(ENDPOINT_DOMAIN)")/leitmotif/upload", method: .post, headers: ["Authorization": UPLOAD_TOKEN])
    
    Task {
        for await progress in request.uploadProgress() {
            DispatchQueue.main.async {
                topBarStateController.statusText = "Uploading (\(Int(round(progress.fractionCompleted * 100)))%)"
                withAnimation {
                    topBarStateController.uploadProgress = progress.fractionCompleted
                }
            }
        }
    }
    
    let response = await request.serializingString().response
    
    if let error = response.error {
        NSLog(error.localizedDescription)
        throw UploadError.uploadFailure
    }
    
    guard let serverResponse = response.response else { throw UploadError.uploadFailure }
    
    if (serverResponse.statusCode != 201) {
        throw serverResponse.statusCode == 409 ? UploadError.fileExistsError : UploadError.uploadFailure
    }
}
