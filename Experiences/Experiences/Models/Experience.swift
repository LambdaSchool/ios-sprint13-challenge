//
//  Experience.swift
//  Experiences
//
//  Created by Enayatullah Naseri on 3/21/20.
//  Copyright © 2020 Enayatullah Naseri. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    
    
    var experienceTitle: String?
    let imageData: Data
    let audioURL: URL
    let videoURL: URL
    let latitude: Double
    let longitude: Double
    
    
    init(experienceTitle: String?, imageData: Data, audioURL: URL, videoURL: URL, latitude: Double, longitude: Double) {
        
        self.experienceTitle = experienceTitle
        self.imageData = imageData
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude
        
    }
}


extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
}
