//
//  Experience.swift
//  Experiences
//
//  Created by Tobi Kuyoro on 08/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?

    init(title: String, image: UIImage?, audioURL: URL?, videoURL: URL?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
    }
}
