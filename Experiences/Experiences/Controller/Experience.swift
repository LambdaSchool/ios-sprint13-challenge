//
//  Experience.swift
//  Experiences
//
//  Created by Nonye on 7/10/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var experienceTitle: String?
    var image: UIImage?
    var audio: URL?
    var video: URL?

    init(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?, audio: URL?, video: URL?) {
        self.coordinate = coordinate
        self.experienceTitle = title
        self.image = image
        self.audio = audio
        self.video = video
    }
}
