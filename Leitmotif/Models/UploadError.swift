import Foundation

enum UploadError: Error {
    case wanQueryFailure
    case fileAccessError
    case fileReadError
    case uploadFailure
    case fileExistsError
}
