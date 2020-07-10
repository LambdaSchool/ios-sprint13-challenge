//
//  Model.swift
//  Unit4Sprint1Challenge
//
//  Created by Jon Bash on 2020-01-17.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

import Foundation
import MapKit

class Experience {
    var title: String
    var timestamp: Date

    var text: String?
    var imageData: Data?
    var videoData: Data?
    var audioData: Data?
    var geotag: CLLocationCoordinate2D?

    var mapAnnotation: MapAnnotation? {
        if self.geotag != nil {
            return MapAnnotation(experience: self)
        } else { return nil }
    }

    // MARK: - Init

    init(title: String, timestamp: Date = Date()) {
        self.title = title
        self.timestamp = timestamp
    }

    // MARK: - Annotation

    class MapAnnotation: NSObject, MKAnnotation {
        unowned var experience: Experience

        var title: String? { experience.title }
        var coordinate: CLLocationCoordinate2D { experience.geotag! }
        var timestamp: Date { experience.timestamp }

        init(experience: Experience) {
            self.experience = experience
        }
    }
}
