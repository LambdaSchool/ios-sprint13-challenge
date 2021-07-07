//
//  Experience.swift
//  Experiences
//
//  Created by Moses Robinson on 3/22/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {
    
    let title: String?
    let image: UIImage
    let audioURL: URL
    let videoURL: URL
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, image: UIImage, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        (self.title, self.image, self.audioURL, self.videoURL, self.coordinate) = (title, image, audioURL, videoURL, coordinate)
    }
}
