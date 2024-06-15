import Foundation
import UniformTypeIdentifiers

private enum MimeRetrievalError: Error {
    case invalidUrlType
}

/// Gets the MIME type of a file URL.
/// - Parameter url: The URL to get the MIME of. This must be a URL where `URL.isFileURL` is true.
/// - Throws: `MimeRetreivalError.invalidUrlType` if the URL is not a file URL (as determined by `URL.isFileUrl`)
/// - Returns: The MIME type of the URL, or `nil` if the URL has no file extension.
func mimeType(url: URL) throws -> String? {
    guard url.isFileURL else {
        throw MimeRetrievalError.invalidUrlType
    }
    
    return UTType(filenameExtension: url.pathExtension)?.preferredMIMEType
}
