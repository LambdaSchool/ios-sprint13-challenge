//
//  Experience.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import UIKit

class Experience {
    
    let description: String
    let geoTag: GeoTag
    let audioComment: URL?
    let videoComment: URL?
    let photo: UIImage?
    
    init(description: String, geoTag: GeoTag, audioComment: URL?, videoComment: URL?, photo: UIImage?) {
        self.description = description
        self.geoTag = geoTag
        self.audioComment = audioComment
        self.videoComment = videoComment
        self.photo = photo
    }
}

enum MediaType: String {
    case image
    case audio
    case video
}
