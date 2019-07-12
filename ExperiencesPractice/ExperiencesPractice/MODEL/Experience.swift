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
    
    let name: String
    let image: UIImage?
    let audioRecording: URL?
    let videoRecording: URL?
    let location: CLLocationCoordinate2D
    
    init(name: String, image: UIImage, audioRecording: URL, videoRecording: URL, longitude: longitude, latitude: ) {
        self.name = name
        self.image = image
        self.audioRecording = audioRecording
        self.videoRecording = videoRecording
        // need to input user's current location or...
    }
    
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
