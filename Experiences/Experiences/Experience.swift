//
//  Experience.swift
//  Experiences
//
//  Created by Jordan Christensen on 11/2/19.
//  Copyright © 2019 Mazjap Co. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Experience: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let name: String
    let image: UIImage?
    var audio: URL?
    var video: URL?
    
    var title: String? {
        name
    }
    
    init(name: String, image: UIImage?, audio: URL?, video: URL? = nil, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.image = image
        self.audio = audio
        self.video = video
        self.coordinate = coordinate
    }
}
