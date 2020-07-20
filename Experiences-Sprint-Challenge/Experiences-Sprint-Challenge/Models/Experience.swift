//
//  Experience.swift
//  Experiences-Sprint-Challenge
//
//  Created by Matthew Martindale on 7/19/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject {
    var title: String?
    var image: UIImage?
    var audioURL: URL?
    var latitude: Double
    var longitude: Double
    
    init(title: String? = "New Experience", image: UIImage?, audioURL: URL?, latitude: Double, longitude: Double) {
        self.title = title
        self.image = image
        self.audioURL = audioURL
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
