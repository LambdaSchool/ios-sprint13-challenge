//
//  Experience.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import UIKit

class Experience: NSObject {
    let name: String
    let image: UIImage?
    let audioURL: URL?
    let videoURL: URL?
    let longitude: Double
    let latitude: Double
    
    internal init(name: String, image: UIImage?, audioURL: URL?, videoURL: URL?, longitude: Double, latitude: Double) {
        self.name = name
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.longitude = longitude
        self.latitude = latitude
    }
}
