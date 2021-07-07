//
//  MediaFile.swift
//  Experiences
//
//  Created by David Wright on 5/18/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation

class MediaFile {
    
    static func newURL(forType mediaType: MediaType) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        
        var fileExtension: String
        
        switch mediaType {
        case .image:
            fileExtension = "png"
        case .audio:
            fileExtension = "caf"
        case .video:
            fileExtension = "mov"
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension(fileExtension)
        
        return fileURL
    }
}
