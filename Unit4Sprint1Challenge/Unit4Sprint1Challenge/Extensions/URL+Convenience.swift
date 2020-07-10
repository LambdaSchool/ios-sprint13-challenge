//
//  URL+Convenience.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-15.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension URL {
    /// Creates a new file URL in the documents directory
    static func newLocalVideoURL() -> URL {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
            .first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory
            .appendingPathComponent(name)
            .appendingPathExtension("mov")
        return fileURL
    }
}
