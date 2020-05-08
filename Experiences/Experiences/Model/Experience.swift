//
//  Experience.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class Experience: NSObject {
    var title: String?
    let time = Date()
    let latitude: Double
    let longitude: Double
    
    // Media
    var audioClips: [URL] = []
    var videos: [URL] = []
    var photos: [URL] = []
    
    init(title: String, latitude: Double, longitude: Double) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}
