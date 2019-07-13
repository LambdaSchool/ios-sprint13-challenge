//
//  Experience.swift
//  ExperiencesPractice
//
//  Created by John Pitts on 7/12/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class Experience: NSObject {
    
    var name: String
    var image: UIImage?
    var audioRecording: URL?
    var videoRecording: URL?
    var location: CLLocationCoordinate2D
    
    init(name: String, image: UIImage, audioRecording: URL, longitude: Double, latitude: Double) {
        self.name = name
        self.image = image
        self.audioRecording = audioRecording
        //self.videoRecording = videoRecording
        // need to input user's current location or...
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    // videoRecording: URL,
}





import MapKit

extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location
    }
    
    var title: String? {
        return name
        
    }
}
