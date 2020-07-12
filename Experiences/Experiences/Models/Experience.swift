//
//  Experience.swift
//  Experiences
//
//  Created by Cody Morley on 7/9/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class Experience: NSObject {
    var title: String?
    var caption: String?
    var video: URL?
    var photo: UIImage?
    var audio: URL?
    var location: CLLocationCoordinate2D
    
    init(title: String,
                  caption: String?,
                  video: URL?,
                  photo: UIImage?,
                  audio: URL?,
                  location: CLLocationCoordinate2D) {
        self.title = title
        self.caption = caption
        self.video = video
        self.photo = photo
        self.audio = audio
        self.location = location
        super.init()
    }
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        location
    }
}
