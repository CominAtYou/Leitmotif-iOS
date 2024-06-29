import Foundation

struct TweetVideo: Codable {
    let videoInfo: VideoInfo
    /// Duration of the video in milliseconds.
    let duration: Int
    let variants: [VideoVariant]
    
    enum CodingKeys: String, CodingKey {
        case videoInfo = "video_info"
        case duration = "duration_millis"
        case variants
    }
    
    
    struct VideoInfo: Codable {
        let aspectRatio: [Int]
        
        enum CodingKeys: String, CodingKey {
            case aspectRatio = "aspect_ratio"
        }
    }
    
    struct VideoVariant: Codable {
        let bitrate: Int?
        let contentType: String
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case bitrate
            case url
            case contentType = "content_type"
        }
    }

}
