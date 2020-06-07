//
//  Experiences.swift
//  Experiences
//
//  Created by Bradley Diroff on 6/6/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit

class Experience: NSCoder {
    var message: String
    var picture: UIImage?
    var audio: URL?
    var latitude: Double
    var longitude: Double
    
    init(message: String, picture: UIImage? = nil, audio: URL? = nil, latitude: Double, longitude: Double) {
        self.message = message
        self.picture = picture
        self.audio = audio
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
