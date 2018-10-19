//
//  Experience.swift
//  ios-sprint13-challenge
//
//  Created by Conner on 10/19/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var mediaURL: URL
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, mediaURL: URL, coordinate: CLLocationCoordinate2D? = nil) {
        self.title = title
        self.mediaURL = mediaURL
        self.coordinate = coordinate ?? CLLocationCoordinate2D(latitude: -50.0, longitude: -50.0)
    }
}
