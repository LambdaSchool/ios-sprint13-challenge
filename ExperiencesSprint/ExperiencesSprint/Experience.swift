//
//  Experience.swift
//  ExperiencesSprint
//
//  Created by Jorge Alvarez on 3/13/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import UIKit

class Experience: NSObject, MKAnnotation {
    
    var comment: String
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    var audioURL: URL
    var videoURL: URL
    
    init(comment: String,
         coordinate: CLLocationCoordinate2D,
         image: UIImage,
         audioURL: URL,
         videoURL: URL) {
        self.comment = comment
        self.coordinate = coordinate
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        
        // ?
        //super.init()
    }
}
