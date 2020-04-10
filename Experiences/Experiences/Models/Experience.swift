//
//  Experience.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

class Experience: NSObject {
    internal init(experiencetitle: String, posterImage: Data?, videoURL: URL?, audioRecordingURL: URL?, longitude: Double, latitude: Double) {
        self.experiencetitle = experiencetitle
        self.posterImage = posterImage
        self.videoURL = videoURL
        self.audioRecordingURL = audioRecordingURL
        self.longitude = longitude
        self.latitude = latitude
    }
    
    let experiencetitle: String
    let posterImage: Data?
    let videoURL: URL?
    let audioRecordingURL: URL?
    let longitude: Double
    let latitude: Double
    
}
