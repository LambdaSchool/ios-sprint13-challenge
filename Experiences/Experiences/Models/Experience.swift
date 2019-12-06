//
//  Experience.swift
//  Experiences
//
//  Created by Jesse Ruiz on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum MediaType: String {
    case image
    case video
}

class Experience {
    
    var title: String
    var mediaURL: URL
    let mediaType: MediaType
    var audioURL: URL?
    
    init(title: String, mediaURL: URL, mediaType: MediaType, audioURL: URL? = nil) {
        self.title = title
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.audioURL = audioURL
    }
}
