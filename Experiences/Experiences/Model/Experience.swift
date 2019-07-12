//
//  Experiences.swift
//  Experiences
//
//  Created by Christopher Aronson on 7/12/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Experience: NSObject {
    
    let experienceName: String
    let image: UIImage
    let videoURL: URL
    let audioURL: URL
    
    init(experienceName: String, image: UIImage, videoURL: URL, audioURL: URL) {
        self.experienceName = experienceName
        self.image = image
        self.videoURL = videoURL
        self.audioURL = audioURL
    }
}
