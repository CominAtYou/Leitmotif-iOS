import Foundation
import UIKit

enum TweetRetreivalError: Error {
    case tokenRetreivalFailure
    /// Tweet is unavailable for some reason (deleted, moderated, etc.)
    case tweetUnavailable(String)
    /// Tweet is from a private account
    case protected
    /// Tweet is NSFW
    case guestAccessError
    /// Tweet has no media
    case noMedia
}

/// Get the current version of iOS.
///
/// This returns the version of iOS on the system in the major.minor format.
/// Patch is not included in the version. 
///
/// As an example, calling this function on iOS 17.5.1 will cause it to return 17.5.
private func getSystemVersion() -> String {
    let components = UIDevice.current.systemVersion.components(separatedBy: ".")
    return "\(components[0]).\(components[1])"
}

private let commonHeaders = [
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(getSystemVersion()) Safari/605.1.15",
    "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA",
    "X-Twitter-Client-Language": "en",
    "X-Twitter-Active-User": "yes",
    "Accept-Language": "en"
]

private func getGuestToken(forceReload: Bool = false) async throws -> String {
    if let previousGuestToken = UserDefaults.standard.string(forKey: "previous_guest_token"), !forceReload {
        return previousGuestToken
    }
    
    let urlRequest = try URLRequest(url: URL(string: "https://api.x.com/1.1/guest/activate.json")!, method: .post, headers: .init(commonHeaders))
    
    let (responseData, _response) = try await URLSession.shared.data(for: urlRequest)
    let response = _response as! HTTPURLResponse
    
    guard 200...299 ~= response.statusCode else {
        throw TweetRetreivalError.tokenRetreivalFailure
    }
    
    let jsonResponseObject = try JSONDecoder().decode(TokenResponse.self, from: responseData)
    UserDefaults.standard.setValue(jsonResponseObject.guest_token, forKey: "previous_guest_token")
    
    return jsonResponseObject.guest_token
}

func getMedia(fromTweetId id: String) async throws -> [String] {
    let token = try await getGuestToken()
    var graphqlTweetEndpoint = URL(string: "https://api.x.com/graphql/I9GDzyCGZL2wSoYFFrrTVw/TweetResultByRestId")!
    
    let headers = [
        "Content-Type": "application/json",
        "X-Guest-Token": token,
        "Cookie": "guest_id=\(token.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
    ]
    
    let combinedHeaders = headers.merging(commonHeaders, uniquingKeysWith: { _, _ in return "" })
    
    let queryParams: [String : Any] = [
        "tweetId": id,
        "withCommunity": false,
        "includePromotedContent": false,
        "withVoice": false
    ]
    
    graphqlTweetEndpoint.append(queryItems: [
        .init(name: "variables", value: String(data: try! JSONSerialization.data(withJSONObject: queryParams), encoding: .utf8)),
        .init(name: "features", value: TwitterRequestConstants.tweetFeatures),
        .init(name: "fieldToggles", value: TwitterRequestConstants.tweetFieldToggles)
    ])
    
    let request = try URLRequest(url: graphqlTweetEndpoint, method: .get, headers: .init(combinedHeaders))
    
    let (responseData, _response) = try await URLSession.shared.data(for: request)
    let response = _response as! HTTPURLResponse
    
    if response.statusCode == 403 || response.statusCode == 429 {
        _ = try await getGuestToken(forceReload: true)
        return try await getMedia(fromTweetId: id)
    }
    
    guard response.statusCode == 200 else { throw NSError() }
    
    let json = try JSONSerialization.jsonObject(with: responseData) as! [String : Any]
    let data = json["data"] as! [String : Any]
    let tweetResult = data["tweetResult"] as! [String : Any]
    let result = tweetResult["result"] as! [String : Any]
    let typename = result["__typename"] as! String
    
    if (typename == "TweetUnavailable") {
        switch result["reason"] as! String {
        case "Protected":
            throw TweetRetreivalError.protected
        case "NsfwLoggedOut":
            throw TweetRetreivalError.guestAccessError
        default:
            throw TweetRetreivalError.tweetUnavailable(result["reason"] as! String)
        }
    }
        
    if !["Tweet", "TweetWithVisibilityResults"].contains(typename) {
        throw TweetRetreivalError.tweetUnavailable("Tweet Unavailable")
    }
    
    let baseTweet: [String : Any]
    var retweetedTweet: [String : Any]? = nil
    
    if typename == "Tweet" {
        baseTweet = result["legacy"] as! [String : Any]
        
        if let retweet = baseTweet["retweeted_status_result"] as? [String : Any] {
            let retweetResult = retweet["result"] as! [String : Any]
            let retweetLegacy = retweetResult["legacy"] as! [String : Any]
            retweetedTweet = (retweetLegacy["extended_entities"] as! [String : Any])
        }
    }
    else {
        baseTweet = (result["tweet"] as! [String : Any])["legacy"] as! [String : Any]
        
        if let retweet = baseTweet["retweeted_status_result"] as? [String : Any] {
            let retweetResult = retweet["result"] as! [String : Any]
            let retweetResultTweet = retweetResult["tweet"] as! [String : Any]
            let retweetLegacy = retweetResultTweet["legacy"] as! [String : Any]
            retweetedTweet = (retweetLegacy["extended_entities"] as! [String : Any])
        }
    }
    
    let media = retweetedTweet?["media"] as? [[String: Any]] ?? (baseTweet["extended_entities"] as? [String : Any])?["media"] as? [[String: Any]]
    
    guard let media, media.count > 0 else { throw TweetRetreivalError.noMedia }
    
    var mediaUrls: [String] = []
    
    for item in media {
        let mediaType = item["type"] as! String
        
        if (mediaType == "photo") {
            mediaUrls.append(item["media_url_https"] as! String)
        }
        else if (["video", "animated_gif"].contains(mediaType)) {
            let videoInfo = try JSONDecoder().decode(TweetVideo.self, from: try JSONSerialization.data(withJSONObject: item["video_info"]!))
            let highestBitrateVariant = videoInfo.variants.filter({ $0.bitrate != nil }).max(by: { $0.bitrate! < $1.bitrate! })!
            mediaUrls.append(highestBitrateVariant.url)
        }
    }
    
    return mediaUrls
}
