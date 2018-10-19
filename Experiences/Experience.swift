//
//  Experience.swift
//  Experiences
//
//  Created by Vuk Radosavljevic on 10/19/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject {
    
    
    let image: UIImage
    let recordingURL: URL
    let videoURL: URL
    
    init(image: UIImage, recordingURL: URL, videoURL: URL) {
        self.image = image
        self.recordingURL = recordingURL
        self.videoURL = videoURL
    }
    
}

extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 41, longitude: -87)
    }
    
    var title: String? {
        return "Test"
    }
    
    
    
}
