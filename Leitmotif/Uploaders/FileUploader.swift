import Foundation
import Alamofire
private let natWanIP = "136.35.34.249"

func uploadFile(fileName: String, file: URL, location: UploadLocation, progressCallback: @escaping (String, Double, Bool) -> Void) async throws {
    let getIpUrl = URL(string: "https://api.ipify.org")!
    let ipRequestResult = try? await URLSession.shared.data(from: getIpUrl)
    
    progressCallback("Determining WAN IP...", 0.0, false)
    guard let (data, _) = ipRequestResult else { throw UploadError.wanQueryFailure }
    let ip = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
    let isAvailableLocally = ip == natWanIP
    
    NSLog("Got IP: \(ip)")
    NSLog("Is available locally: \(isAvailableLocally ? "YES" : "NO")")
    
    progressCallback("Trying to access file...", 0.0, false)
    let canAccess = file.startAccessingSecurityScopedResource()
    guard canAccess else { throw UploadError.fileAccessError }
    
    progressCallback("Reading file...", 0.0, false)
    let fileData = try? Data(contentsOf: file)
    guard let fileData else {
        file.stopAccessingSecurityScopedResource()
        throw UploadError.fileReadError
    }
    file.stopAccessingSecurityScopedResource()
    
    progressCallback("Uploading...", 0.0, true)
    
    let request = AF.upload(multipartFormData: { data in
        data.append(fileData, withName: "file", fileName: file.lastPathComponent, mimeType: mimeTypes[file.pathExtension.lowercased()]!)
        data.append(fileName.data(using: .utf8)!, withName: "filename")
        data.append(locationIds[location]!.data(using: .utf8)!, withName: "location")
    }, to: "\(isAvailableLocally ? "http://192.168.2.6:8020" : "https://\(ENDPOINT_DOMAIN)")/leitmotif/upload", method: .post, headers: ["Authorization": UPLOAD_TOKEN])
    
    Task {
        for await progress in request.uploadProgress() {
            progressCallback("Uploading...", progress.fractionCompleted, true)
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
