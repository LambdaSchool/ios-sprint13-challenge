//
//  ExperienceTempModel.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import MapKit

class ExperienceTemp: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    let title: String?
    let imageURL: URL?
    let audioURL: URL?
    let videoURL: URL?
    let latitude: Double
    let longitude: Double
    let timestamp: Date

    init(title: String, imageURL: URL?, audioURL: URL?, videoURL: URL?, latitude: Double, longitude: Double, timestamp: Date = Date()) {
        self.title = title
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}
