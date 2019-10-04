//
//  Experience.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var title: String?
    let imageURL: URL?
    let audioURL: URL?
    let videoURL: URL?
    let latitude: Double
    let longitude: Double

    init(title: String, imageURL: URL?, audioURL: URL?, videoURL: URL?, latitude: Double, longitude: Double) {
        self.title = title
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude

    }
}
