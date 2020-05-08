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
    let time: Date
    let latitude: Double
    let longitude: Double
    
    // Media
    var audioClips: [URL]
    var videos: [URL]
    var photos: [URL]
    
    init(title: String, time: Date, latitude: Double, longitude: Double, audioClips: [URL], videos: [URL], photos: [URL]) {
        self.title = title
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
        self.audioClips = audioClips
        self.videos = videos
        self.photos = photos
    }
}
