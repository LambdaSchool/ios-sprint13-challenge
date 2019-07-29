//
//  Experience.swift
//  Experiences
//
//  Created by Sameera Roussi on 7/29/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import MapKit

struct Experience {
    let myLocation: CLLocationCoordinate2D
    var myTitle: String
    let myImage: URL
    let myAudioRecording: URL
    let myVideoRecording: URL
    
    init(myLocation: CLLocationCoordinate2D, myTitle: String, myImage: URL, myAudioRecording: URL, myVideoRecording: URL) {
        (self.myLocation, self.myTitle, self.myImage, self.myAudioRecording, self.myVideoRecording) =
            (myLocation, myTitle, myImage, myAudioRecording, myVideoRecording)
    }
}

