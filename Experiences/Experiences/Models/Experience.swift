//
//  Experience.swift
//  Experiences
//
//  Created by Bobby Keffury on 1/27/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation
import MapKit
import CoreLocation

class Experience: NSObject {
    
    var place: String
    var image: CIImage?
    var videoURL: URL?
    var latitude: Double
    var longitude: Double
    
    internal init(place: String, image: CIImage?, videoURL: URL?, latitude: Double, longitude: Double) {
        self.place = place
        self.image = image
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var title: String? {
        place
    }
}
