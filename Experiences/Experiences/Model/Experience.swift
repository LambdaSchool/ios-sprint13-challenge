//
//  Experience.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import Foundation
import MapKit
import AVFoundation

class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        audio = title
        video = title
    }
    
    var audio: String?
    var video: String?
    var image: UIImage?
}
