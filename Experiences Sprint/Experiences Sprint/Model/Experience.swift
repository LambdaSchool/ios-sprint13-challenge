//
//  Experience.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var image: UIImage?
    var audio: URL?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, image: UIImage?, audio: URL?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.audio = audio
        self.coordinate = coordinate
    }
}
