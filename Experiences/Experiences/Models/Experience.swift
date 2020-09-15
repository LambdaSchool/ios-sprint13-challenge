//
//  Experience.swift
//  Experiences
//
//  Created by Elizabeth Thomas on 9/11/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import MapKit

class Experience: NSObject {

    let title: String
    let image: UIImage?
    var audioURL: URL?
    let location: CLLocationCoordinate2D

    init(title: String, image: UIImage?, audioURL: URL?, location: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.audioURL = audioURL
        self.location = location
    }
}
