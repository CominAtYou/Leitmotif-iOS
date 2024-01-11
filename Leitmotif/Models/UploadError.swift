//
//  UploadError.swift
//  Leitmotif
//
//  Created by William Martin on 12/31/23.
//

import Foundation

enum UploadError: Error {
    case wanQueryFailure
    case fileAccessError
    case fileReadError
    case uploadFailure
    case fileExistsError
}
