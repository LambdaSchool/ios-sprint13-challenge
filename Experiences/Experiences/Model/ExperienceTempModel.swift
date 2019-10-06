//
//  ExperienceTempModel.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MapKit

class ExperienceTemp: NSObject {

    let header: String?
    let image: Data?
    let audioURL: URL?
    let videoURL: URL?
    let latitude: Double
    let longitude: Double
    let timestamp: Date

    init(title: String, image: Data?, audioURL: URL?, videoURL: URL?, latitude: Double, longitude: Double, timestamp: Date = Date()) {
        self.header = title
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }

    private lazy var dateFormatter: DateFormatter = {
         let result = DateFormatter()
         result.dateStyle = .short
         result.timeStyle = .short
         return result
     }()
}

extension ExperienceTemp: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var title: String? {
        header
    }

    var subtitle: String? {
        dateFormatter.string(from: timestamp)
    }
}
