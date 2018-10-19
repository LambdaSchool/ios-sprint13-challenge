//
//  Experience.swift
//  ios-sprint13-challenge
//
//  Created by De MicheliStefano on 19.10.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class Experience: NSObject {
    
    init(title: String, audioURL: URL, videoURL: URL, image: UIImage) {
        self.experienceTitle = title
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.image = image
    }
    
    var experienceTitle: String
    var audioURL: URL?
    var videoURL: URL?
    var image: UIImage?
    
}

extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 0.0)!, longitude: CLLocationDegrees(exactly: 0.0)!)
    }
    
    var subtitle: String? {
        return self.experienceTitle
    }
    
}
