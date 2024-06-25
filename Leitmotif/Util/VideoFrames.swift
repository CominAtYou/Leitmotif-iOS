import Foundation
import AVFoundation

func getFrameFromVideo(videoURL: URL) async -> CGImage? {
    let assetImageGen = AVAssetImageGenerator(asset: AVURLAsset(url: videoURL))
    assetImageGen.appliesPreferredTrackTransform = true
    assetImageGen.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
    
    let result = try? await assetImageGen.image(at: CMTime(value: 0, timescale: 60))
    
    return result?.image
}

func getFrameFromVideo(data video: Data) async -> CGImage? {
    let directory = FileManager.default.temporaryDirectory
    let fileName = "\(UUID().uuidString).mov"
    let fullUrl = URL(filePath: fileName, relativeTo: directory)
    
    do {
        try video.write(to: fullUrl)
    }
    catch {
        return nil
    }
    
    let frame = await getFrameFromVideo(videoURL: fullUrl)
    
    do {
        try FileManager.default.removeItem(at: fullUrl)
    }
    catch {
        NSLog("Failed to remove temp file located at \(fullUrl)")
    }
    
    return frame
}
