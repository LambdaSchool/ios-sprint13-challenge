//
//  Experience.swift
//  Experiences
//
//  Created by Mark Poggi on 6/4/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    var audio: URL?
    var video: URL?

    init(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?, audio: URL?, video: URL?) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
        self.audio = audio
        self.video = video
    }
}
