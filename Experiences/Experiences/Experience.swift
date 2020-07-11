//
//  Experience.swift
//  Experiences
//
//  Created by Dahna on 7/10/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    
    let expTitle: String
    let image: UIImage?
    let audio: URL?
    
    var coordinate: CLLocationCoordinate2D
    
    init(expTitle: String, image: UIImage?, audio: URL?, coordinate: CLLocationCoordinate2D) {
        self.expTitle = expTitle
        self.image = image
        self.audio = audio
        self.coordinate = coordinate
    }
}

