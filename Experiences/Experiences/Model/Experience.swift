//
//  Experience.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_34 on 3/29/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {
    
    let title: String?
    let photo: UIImage
    let audioURL: URL
    let videoURL: URL
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, photo: UIImage, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.photo = photo
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.coordinate = coordinate
    }
}
