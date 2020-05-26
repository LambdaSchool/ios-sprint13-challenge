//
//  MediaFileURL.swift
//  Experiences
//
//  Created by Gerardo Hernandez on 5/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation

class MediaFileURL {
    
    static func newURL(for mediaType: MediaType) -> URL {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let dateFormater = ISO8601DateFormatter()
        dateFormater.formatOptions = [.withInternetDateTime]
        
        let name = dateFormater.string(from: Date())
        
        var fileExtension: String
        
        switch mediaType {
        case .audio:
            fileExtension = "caf"
        case .image:
            fileExtension = "png"
        case .video:
            fileExtension = "mov"
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension(fileExtension)
    
        return fileURL
    }
}
