//
//  Visit.swift
//  Car Trek
//
//  Created by Christy Hicks on 5/17/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit
import MapKit

class Visit: NSObject {
    var name: String
    var latitude: Double
    var longitude: Double
    var photo: UIImage?
    var audioRecordingURL: URL?
    var videoRecordingURL: URL?
    
    init(name: String, latitude: Double, longitude: Double, photo: UIImage?, audioURL: URL?, videoURL: URL?) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.photo = photo
        self.audioRecordingURL = audioURL
        self.videoRecordingURL = videoURL
    }
}

extension Visit: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        name
    }

}
