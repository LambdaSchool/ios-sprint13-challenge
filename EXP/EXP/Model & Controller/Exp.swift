//
//  Exp.swift
//  Exp
//
//  Created by Madison Waters on 2/23/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


class Exp: NSObject, MKAnnotation {
    
    var location: MKUserLocation
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let audioURL: URL?
    let videoURL: URL?
    let image: UIImage?

    
    init(location: MKUserLocation, coordinate: CLLocationCoordinate2D, title: String?, audioURL: URL?, videoURL: URL?, image: UIImage?) {
        self.location = location
        self.coordinate = coordinate
        self.title = title
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.image = image

    }
}
