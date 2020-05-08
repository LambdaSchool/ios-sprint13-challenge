//
//  Experience.swift
//  Experiences
//
//  Created by Karen Rodriguez on 5/8/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation

class Experience: NSObject {

    var content: String
    var videoURL: String?
    var imageData: Data?
    var auddioURL: String?

    internal init(content: String, videoURL: String? = nil, imageData: Data? = nil, auddioURL: String? = nil) {
        self.content = content
        self.videoURL = videoURL
        self.imageData = imageData
        self.auddioURL = auddioURL
    }
}
