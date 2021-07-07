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
    
    init(title: String?, audioRecording: URL?, videoRecording: URL?, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.audioRecording = audioRecording
        self.videoRecording = videoRecording
        self.image = image
        self.coordinate = coordinate
    }
    
    var title: String?
    var audioRecording: URL? // to source of audio recording
    var videoRecording: URL? // to source of video recording
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
    
}
