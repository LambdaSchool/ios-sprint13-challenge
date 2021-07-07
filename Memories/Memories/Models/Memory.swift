//
//  Memory.swift
//  Test
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import Foundation
import MapKit

class Memory: NSObject, Codable, MKAnnotation {
    let title: String?
    let date: Date
    let image: Data?
    let video: String?
    let audio: String?
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(title: String, image: Data?, videoURL: String?, audioURL: String?, latitude: Double, longitude: Double) {
        self.date = Date()
        self.title = title
        self.image = image
        self.video = videoURL
        self.audio = audioURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
