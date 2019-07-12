//
//  Experience.swift
//  Experiences
//
//  Created by Jonathan Ferrer on 7/12/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {

    let title: String?
    let image: UIImage
    let audioURL: URL
    let videoURL: URL
    let coordinate: CLLocationCoordinate2D

    init(title: String, image: UIImage, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.coordinate = coordinate
    }
}
