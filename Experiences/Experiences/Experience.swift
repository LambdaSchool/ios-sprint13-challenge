//
//  Experience.swift
//  Experiences
//
//  Created by Dahna on 7/10/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    
    let expTitle: String
    let image: UIImage?
    let audio: URL?
    let longitude: Double
    let latitude: Double
    
    init(expTitle: String, image: UIImage?, audio: URL?, longitude: Double, latitude: Double) {
        self.expTitle = expTitle
        self.image = image
        self.audio = audio
        self.latitude = latitude
        self.longitude = longitude
        
        super.init()
    }
    
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        expTitle
    }
}
