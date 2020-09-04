//
//  Experience.swift
//  Media Programming Experiences
//
//  Created by Ivan Caldwell on 2/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import UIKit

class Experience {
    
    var message: String
    let image: UIImage
    let audio: URL
    let timestamp: Date
    var video: URL
    
    init(message: String, audioURL: URL, image: UIImage, video: URL, timestamp: Date = Date()) {
        self.message = message
        self.audio = audioURL
        self.image = image
        self.timestamp = timestamp
        self.video = video
    }
}
