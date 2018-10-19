//
//  Experience.swift
//  ExperienceTracker
//
//  Created by Jonathan T. Miles on 10/19/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
    
    init(audioRecording: URL, videoRecording: URL, image: UIImage, coordinate: CLLocationCoordinate2D) {
        self.audioRecording = audioRecording
        self.videoRecording = videoRecording
        self.image = image
        self.coordinate = coordinate
    }
    
    let audioRecording: URL // to source of audio recording
    let videoRecording: URL // to source of video recording
    let image: UIImage
    var coordinate: CLLocationCoordinate2D
    
}
