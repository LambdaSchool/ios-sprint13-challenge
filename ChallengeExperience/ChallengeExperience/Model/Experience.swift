//
//  Experience.swift
//  ChallengeExperience
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import AVFoundation
import CoreLocation

class Experience: NSObject {
    var name: String
    var imageData: Data
    var video: URL
    var audio: URL
    var location: CLLocationCoordinate2D
    
    init(name: String, imageData: Data, video: URL, audio: URL, location: CLLocationCoordinate2D){
        self.name = name
        self.imageData = imageData
        self.video = video
        self.audio = audio
        self.location = location
    }
}
